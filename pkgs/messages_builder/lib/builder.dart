// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as path;

import 'arb_parser.dart';
import 'code_generation/code.dart';
import 'generation_options.dart';
import 'message_with_metadata.dart';
import 'messages_cli.dart';

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

  Future<void> build() async {
    final allMessageFiles = await getParsedMessageFiles();
    final inputMessageFile = allMessageFiles
        .singleWhere((messageFile) => messageFile.path == inputId.path);
    final parentFile =
        MessageFileBuilder.getParentFile(allMessageFiles, inputMessageFile);

    final reducedMessageFile =
        MessageFileBuilder.reduce(parentFile, inputMessageFile);

    if (parentFile.path == inputId.path) {
      await writeDartLibrary(allMessageFiles, reducedMessageFile);
    }
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
                path: path.setExtension(resource.path, '.json'),
                hash: resource.hash,
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
      assetId.path,
      inferredLocale,
    );
    return messageList;
  }

  /// Display a notification to the user to include the newly generated files
  /// in their assets.
  void printIncludeFilesNotification(
    String? context,
    Map<String, ({String hash, String path})> localeToResource,
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
