import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'arb_parser.dart';
import 'code_generation/code.dart';
import 'generation_options.dart';
import 'message_with_metadata.dart';

Builder carbBuilder(BuilderOptions options) =>
    GenerateCarbBuilder(options.config);

class GenerateCarbBuilder implements Builder {
  final Map<String, dynamic> config;
  late final List<String> extensionsForArb;

  GenerateCarbBuilder(this.config) {
    final locales = availableLocalesForDateFormatting;
    final contextYamlList = config['contexts'] as YamlList?;
    final contexts = contextYamlList?.value.cast() ?? ['msg'];
    extensionsForArb = [
      ...contexts.expand((context) => locales.map((locale) => '.carb')).toSet(),
      ...contexts
          .expand((context) => locales.map((locale) => '.carb.dart'))
          .toSet(),
      ...contexts.map((context) => '.g.dart').toSet(),
    ].toList();
  }

  @override
  get buildExtensions => {
        '.arb': extensionsForArb,
        '^pubspec.yaml': [],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    var generationOptions = await GenerationOptions.fromPubspec(buildStep);

    await BuildStepGenerator(buildStep, generationOptions).build();
  }
}

class BuildStepGenerator {
  final BuildStep buildStep;
  final GenerationOptions options;

  BuildStepGenerator(this.buildStep, this.options);

  Serializer get serializer => getSerializer(options);

  Future<void> build() async {
    var parsedMessageFiles = await getParsedMessageFiles();
    assertFilesAreValid(parsedMessageFiles);

    var currentMessageFile = parsedMessageFiles
        .singleWhere((element) => element.assetId == buildStep.inputId);

    await writeDataFile(currentMessageFile);
    if (shouldGenerateDartLib(parsedMessageFiles, currentMessageFile)) {
      writeDartLibrary(parsedMessageFiles, currentMessageFile);
    }
  }

  /// Generates the Dart library which extracts the messages from their file
  /// format and makes the available to the user in a way specified through the
  /// `GenerationOptions`.
  Future<void> writeDartLibrary(
    List<MessageFileResource> assetList,
    MessageFileResource arb,
  ) async {
    var resourcesInContext =
        assetList.where((element) => element.context == arb.context);
    var localeToResource = Map.fromEntries(resourcesInContext.map((resource) =>
        MapEntry(
            resource.locale,
            resource.assetId
                .changeExtension(getDataFileExtension())
                .path
                .split(path.separator)
                .last)));
    printIncludeFilesNotification(arb.context, localeToResource);
    var resourceToHash = Map.fromEntries(
      resourcesInContext.map((resource) => MapEntry(
            localeToResource[resource.locale]!,
            resource.hash,
          )),
    );
    var libraryCode = CodeGenerator(
      options,
      arb.messageList,
      localeToResource,
      resourceToHash,
    ).generate();

    var generatedMessageFile = buildStep.inputId.changeExtension('.g.dart');
    await buildStep.writeAsString(generatedMessageFile, libraryCode);
  }

  String getDataFileExtension() => options.isWeb ? '.carb.dart' : '.carb';

  Serializer<dynamic> getSerializer(GenerationOptions generationOptions) {
    Serializer serializer;
    if (generationOptions.isNative) {
      serializer = NativeSerializer(generationOptions.findById);
    } else {
      serializer = WebSerializer(generationOptions.findById);
    }
    return serializer;
  }

  void assertFilesAreValid(List<MessageFileResource> arbFiles) {
    final contexts = arbFiles.map((e) => e.context).whereType<String>().toSet();
    for (var context in contexts) {
      var filesWithContext = arbFiles.where((arb) => arb.context == context);
      if (filesWithContext
              .where((element) => element.isReferenceForContext)
              .length >
          1) {
        throw ArgumentError('Multiple arb files are marked as reference');
      }
      var localesInContext = filesWithContext.map((e) => e.locale).toList();
      if (localesInContext.length != localesInContext.toSet().length) {
        throw ArgumentError(
            'Multiple arb files for the same context have the same locale');
      }
    }
  }

  Future<List<MessageFileResource>> getParsedMessageFiles() async {
    return buildStep.findAssets(Glob('**.arb')).asyncMap((assetId) async {
      var arbFile = await buildStep.readAsString(assetId);
      var arb =
          Map.castFrom<dynamic, dynamic, String, dynamic>(jsonDecode(arbFile));
      var messageList = ArbParser(options.findById).parseMessageFile(arb);
      return MessageFileResource(
        assetId,
        messageList,
        arbFile.hashCode.toRadixString(32),
      );
    }).toList();
  }

  bool shouldGenerateDartLib(
      List<MessageFileResource> arbResources, MessageFileResource arb) {
    var isOnlyResourceForContext = arbResources
            .where((element) => element.context == arb.context)
            .length ==
        1;
    var shouldGenerateDartLib =
        arb.isReferenceForContext || isOnlyResourceForContext;
    return shouldGenerateDartLib;
  }

  /// This writes the file containing the messages, which can be either a binary
  /// `.carb` file or a JSON file, depending on the serializer.
  ///
  /// This message data file must be shipped with the application, it is
  /// unpacked at runtime so that the messages can be read from it.
  ///
  /// Returns the list of indices of the messages which are visible to the user.
  Future<void> writeDataFile<T>(MessageFileResource currentMessageFile) async {
    var serialization = serializer.serialize(
      currentMessageFile.hash,
      currentMessageFile.locale,
      currentMessageFile.messages.map((e) => e.message).toList(),
    );
    var carbFile =
        currentMessageFile.assetId.changeExtension(getDataFileExtension());
    var data = serialization.data;
    if (data is Uint8List) {
      await buildStep.writeAsBytes(carbFile, data);
    } else if (data is String) {
      await buildStep.writeAsString(carbFile, data);
    }
  }

  void printIncludeFilesNotification(
      String? context, Map<String, String> localeToResource) {
    var contextMessage = 'The';
    if (context != null) {
      contextMessage = 'For the messages in $context, the';
    }
    print(
        '$contextMessage following files need to be declared in your assets:\n${localeToResource.entries.map((e) => '\t${e.value}').join('\n')}');
  }
}

class MessageFileResource {
  final AssetId assetId;
  final String hash;
  final MessageListWithMetadata messageList;

  MessageFileResource(this.assetId, this.messageList, this.hash);

  String get locale => messageList.locale!;
  bool get isReferenceForContext => messageList.isReference;
  List<MessageWithMetadata> get messages => messageList.messages;
  String? get context => messageList.context;
}
