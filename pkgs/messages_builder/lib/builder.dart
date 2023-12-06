// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:glob/glob.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:path/path.dart' as path;

import 'arb_parser.dart';
import 'code_generation/code.dart';
import 'generation_options.dart';
import 'message_with_metadata.dart';

Builder messagesBuilder(BuilderOptions options) =>
    MessagesBuilder(options.config);

class MessagesBuilder implements Builder {
  final Map<String, dynamic> config;

  MessagesBuilder(this.config);

  @override
  Map<String, List<String>> get buildExtensions => {
        '.arb': ['.g.dart', '.json'],
        '^pubspec.yaml': [],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final generationOptions = await GenerationOptions.fromPubspec(buildStep);
    await BuildStepGenerator(buildStep, generationOptions).build();
  }
}

class BuildStepGenerator {
  final BuildStep buildStep;
  AssetId get inputId => buildStep.inputId;
  final GenerationOptions options;

  BuildStepGenerator(this.buildStep, this.options);

  Serializer get serializer => getSerializer(options);

  Future<void> build() async {
    final allMessageFiles = await getParsedMessageFiles();
    final inputMessageFile = allMessageFiles
        .singleWhere((messageFile) => messageFile.assetId == inputId);
    final parentFile = getParentFile(allMessageFiles, inputMessageFile);

    final reducedMessageFile = reduce(parentFile, inputMessageFile);

    await writeDataFile(reducedMessageFile);
    if (parentFile.assetId == inputId) {
      await writeDartLibrary(allMessageFiles, reducedMessageFile);
    }
  }

  /// Only keep the messages which are in the parent file, as only those will
  /// get a generated method to embed them in code.
  MessagesWithMetadata reduce(
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

  /// Generates the Dart library which extracts the messages from their file
  /// format and makes the available to the user in a way specified through the
  /// `GenerationOptions`.
  Future<void> writeDartLibrary(
    List<MessagesWithMetadata> assetList,
    MessagesWithMetadata messageList,
  ) async {
    final resourcesInContext =
        assetList.where((resource) => resource.context == messageList.context);

    final localeToResourceInfo =
        Map.fromEntries(resourcesInContext.map((resource) => MapEntry(
              resource.locale,
              (
                path: resource.assetId.changeExtension('.json').path,
                hasch: resource.hash,
              ),
            )));

    printIncludeFilesNotification(messageList.context, localeToResourceInfo);
    final libraryCode = CodeGenerator(
      options,
      messageList,
      localeToResourceInfo,
    ).generate();

    await buildStep.writeAsString(
      inputId.changeExtension('.g.dart'),
      libraryCode,
    );
  }

  Serializer<dynamic> getSerializer(GenerationOptions generationOptions) {
    return JsonSerializer(generationOptions.findById);
  }

  Future<List<MessagesWithMetadata>> getParsedMessageFiles() async =>
      buildStep.findAssets(Glob('**.arb')).asyncMap(parseMessageFile).toList();

  Future<MessagesWithMetadata> parseMessageFile(AssetId assetId) async {
    final arbFile = await buildStep.readAsString(assetId);
    final decoded = jsonDecode(arbFile) as Map;
    final arb = Map.castFrom<dynamic, dynamic, String, dynamic>(decoded);
    final inferredLocale = path
        .basenameWithoutExtension(assetId.path)
        .split('_')
        .skip(1)
        .join('_');
    final messageList = ArbParser(options.findById).parseMessageFile(
      arb,
      assetId,
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
          .where((element) => element.assetId.path == arb.referencePath)
          .firstOrNull;
      if (reference != null) {
        return reference;
      }
    }

    /// If the current file is a reference for others, return the current file.
    final references = arbResources
        .where((resource) => resource.referencePath == arb.assetId.path);
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

  /// This writes the file containing the messages, which can be either a binary
  /// `.carb` file or a JSON file, depending on the serializer.
  ///
  /// This message data file must be shipped with the application, it is
  /// unpacked at runtime so that the messages can be read from it.
  ///
  /// Returns the list of indices of the messages which are visible to the user.
  Future<void> writeDataFile(MessagesWithMetadata messages) async {
    final serialization = serializer.serialize(
      messages.hash,
      messages.locale,
      messages.messages.map((e) => e.message).toList(),
    );
    final carbFile = messages.assetId.changeExtension('.json');
    final data = serialization.data;
    if (data is Uint8List) {
      await buildStep.writeAsBytes(carbFile, data);
    } else if (data is String) {
      await buildStep.writeAsString(carbFile, data);
    }
  }

  /// Display a notification to the user to include the newly generated files
  /// in their assets.
  void printIncludeFilesNotification(
    String? context,
    Map<String, ({String hasch, String path})> localeToResource,
  ) {
    var contextMessage = 'The';
    if (context != null) {
      contextMessage = 'For the messages in $context, the';
    }
    final fileList =
        localeToResource.entries.map((e) => '\t${e.value.path}').join('\n');
    print(
        '''$contextMessage following files need to be declared in your assets:\n$fileList''');
  }
}
