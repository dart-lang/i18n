import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:path/path.dart' as path;

import 'arb_parser.dart';
import 'generation_options.dart';
import 'message_with_metadata.dart';

Future<void> buildMessages(
  List<String> args,
  String pathToMessages,
  GenerationOptions options,
) async {
  final input = await BuildConfig.fromArgs(args);
  final output = BuildOutput();

  final messagesPath =
      path.join(input.packageRoot.toFilePath(), pathToMessages);
  MessageFileBuilder(input, output, options, messagesPath).build();

  await output.writeToFile(outDir: input.outDir);
}

class MessageFileBuilder {
  final BuildConfig input;
  final BuildOutput output;
  final GenerationOptions options;
  final String pathToMessages;

  MessageFileBuilder(
    this.input,
    this.output,
    this.options,
    this.pathToMessages,
  );

  void build() {
    final allMessageFiles = getParsedMessageFiles();
    for (final messageFile in allMessageFiles) {
      final parentFile = getParentFile(allMessageFiles, messageFile);

      final reducedMessageFile = reduce(parentFile, messageFile);
      writeDataFile(reducedMessageFile, input);
    }
  }

  Serializer get serializer => getSerializer(options);

  Serializer<dynamic> getSerializer(GenerationOptions generationOptions) {
    return JsonSerializer(generationOptions.findById);
  }

  /// This writes the file containing the messages, which can be either a binary
  /// `.carb` file or a JSON file, depending on the serializer.
  ///
  /// This message data file must be shipped with the application, it is
  /// unpacked at runtime so that the messages can be read from it.
  ///
  /// Returns the list of indices of the messages which are visible to the user.
  void writeDataFile(MessagesWithMetadata messages, BuildConfig input) {
    final serialization = serializer.serialize(
      messages.hash,
      messages.locale,
      messages.messages.map((e) => e.message).toList(),
    );
    final carbFile = path.setExtension(messages.path, '.json');
    final relative = path.relative(carbFile, from: pathToMessages);
    final carbPath = path.join(input.outDir.toFilePath(), relative);
    final file = File(carbPath)..createSync(recursive: true);
    final data = serialization.data;
    if (data is Uint8List) {
      file.writeAsBytesSync(data);
    } else if (data is String) {
      file.writeAsStringSync(data);
    }
    output.assets.add(
      Asset(
        id: 'package:${input.packageName}/$relative',
        linkMode: LinkMode.dynamic,
        target: input.target,
        path: AssetAbsolutePath(Uri.file(carbPath)),
      ),
    );
  }

  /// Only keep the messages which are in the parent file, as only those will
  /// get a generated method to embed them in code.
  static MessagesWithMetadata reduce(
    MessagesWithMetadata parentFile,
    MessagesWithMetadata inputMessageFile,
  ) {
    final messageNames = parentFile.messages.map((e) => e.name).toList();

    final messages = inputMessageFile.messages
        .where((message) => messageNames.contains(message.name))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return inputMessageFile.copyWith(messages: messages);
  }

  List<MessagesWithMetadata> getParsedMessageFiles() =>
      Directory(pathToMessages)
          .listSync(recursive: true)
          .whereType<File>()
          .where((element) => path.extension(element.path) == '.arb')
          .map(parseMessageFile)
          .toList();

  MessagesWithMetadata parseMessageFile(File file) {
    final arbFile = file.readAsStringSync();
    final decoded = jsonDecode(arbFile) as Map;
    final arb = Map.castFrom<dynamic, dynamic, String, dynamic>(decoded);
    final inferredLocale =
        path.basenameWithoutExtension(file.path).split('_').skip(1).join('_');
    final messageList = ArbParser(options.findById).parseMessageFile(
      arb,
      file.path,
      inferredLocale,
    );
    return messageList;
  }

  /// Either get the referenced parent file, or try to infer which it might be.
  static MessagesWithMetadata getParentFile(
    List<MessagesWithMetadata> arbResources,
    MessagesWithMetadata arb,
  ) {
    /// If the reference file is explicitly named, return that.
    if (arb.referencePath != null) {
      final reference = arbResources
          .where((element) => element.path == arb.referencePath)
          .firstOrNull;
      if (reference != null) {
        return reference;
      }
    }

    /// If the current file is a reference for others, return the current file.
    final references =
        arbResources.where((resource) => resource.referencePath == arb.path);
    if (references.contains(arb)) {
      return arb;
    }

    /// Try to infer by looking at which files contain metadata, which is a sign
    /// they might be the references for others in the same context.
    final contextLeads =
        arbResources.groupListsBy((resource) => resource.context);
    final contextWithMetadata = contextLeads[arb.context]!
        .firstWhereOrNull((element) => element.hasMetadata);
    if (contextWithMetadata != null) {
      return contextWithMetadata;
    }

    return arb;
  }
}
