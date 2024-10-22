// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

import 'arb_parser.dart';
import 'code_generation/code.dart';
import 'code_generation/library_generation.dart';
import 'generation_options.dart';
import 'message_with_metadata.dart';

class MessageCallingCodeGenerator {
  final GenerationOptions options;
  final Map<String, String> mapping;

  MessageCallingCodeGenerator({
    required this.options,
    required this.mapping,
  });

  Future<void> build() async {
    final allMessageFiles = await getParsedMessageFiles();
    final libraries = <Library>[];
    for (final input in allMessageFiles) {
      final parentFile = getParentFile(allMessageFiles, input);
      final scrubbedMessageFile = scrub(
        input.message,
        parentFile.message.messages.map((e) => e.name).toList(),
      );
      if (parentFile.path == input.path) {
        final library = await writeDartLibrary(
          allMessageFiles,
          scrubbedMessageFile,
        );
        libraries.add(library);
      }
    }
    if (libraries.isNotEmpty) {
      final code = CodeGenerator(
        options: options,
        libraries: libraries,
      ).generate();

      await options.generatedCodeFile.create(recursive: true);
      await options.generatedCodeFile.writeAsString(code);
    }
  }

  /// Only keep the messages which are in the parent file, as only those will
  /// get a generated method to embed them in code.
  MessagesWithMetadata scrub(
    MessagesWithMetadata inputMessageFile,
    List<String> messageNames,
  ) {
    final messages = inputMessageFile.messages
        .where((message) => messageNames.contains(message.name))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return inputMessageFile.copyWith(messages: messages);
  }

  /// Generates the Dart library which extracts the messages from their file
  /// format and makes the available to the user in a way specified through the
  /// `GenerationOptions`.
  Future<Library> writeDartLibrary(
    List<ParsedMessageFile> assetList,
    MessagesWithMetadata messageList,
  ) async {
    final resourcesInContext = assetList
        .where((resource) => resource.message.context == messageList.context);

    final localeToResourceInfo =
        Map.fromEntries(resourcesInContext.map((resource) => MapEntry(
              resource.message.locale ?? 'en_US',
              (
                id: 'package:${options.packageName}/${resource.path}',
                hasch: resource.message.hash,
              ),
            ))
          ..sortedBy((element) => element.key));

    printIncludeFilesNotification(messageList.context, localeToResourceInfo);
    return LibraryGeneration(
      options,
      messageList.context,
      messageList.locale!,
      messageList.messages,
      localeToResourceInfo,
    ).generate();
  }

  Future<List<ParsedMessageFile>> getParsedMessageFiles() async =>
      Future.wait(mapping.entries
          .map((p) async => ParsedMessageFile(
                path: path.relative(p.value, from: Directory.current.path),
                message:
                    await parseMessageFile(await getArbfile(p.key), options),
              ))
          .toList());

  Future<String> getArbfile(String path) async =>
      await File(path).readAsString();

  /// Either get the referenced parent file, or try to infer which it might be.
  static ParsedMessageFile getParentFile(
    List<ParsedMessageFile> arbFiles,
    ParsedMessageFile currentFile,
  ) {
    /// If the reference file is explicitly named, return that.
    if (currentFile.message.referencePath != null) {
      final reference = arbFiles
          .where((element) => element.path == currentFile.message.referencePath)
          .firstOrNull;
      if (reference != null) {
        return reference;
      }
    }

    /// If the current file is a reference for others, return the current file.
    final references = arbFiles.where(
        (resource) => resource.message.referencePath == currentFile.path);
    if (references.contains(currentFile)) {
      return currentFile;
    }

    /// Try to infer by looking at which files contain metadata, which is a sign
    /// they might be the references for others in the same context.
    final contextLeads =
        arbFiles.groupListsBy((resource) => resource.message.context);
    final contextWithMetadata = contextLeads[currentFile.message.context]!
        .firstWhereOrNull((element) => element.message.hasMetadata);
    if (contextWithMetadata != null) {
      return contextWithMetadata;
    }

    return currentFile;
  }

  /// Display a notification to the user to include the newly generated files
  /// in their assets.
  void printIncludeFilesNotification(
    String? context,
    Map<String, ({String hasch, String id})> localeToResource,
  ) {
    var contextMessage = 'The';
    if (context != null) {
      contextMessage = 'For the messages in $context, the';
    }
    final fileList =
        localeToResource.entries.map((e) => '\t${e.value.id}').join('\n');
    print(
        '''$contextMessage following files need to be declared in your assets:\n$fileList''');
  }
}

Future<MessagesWithMetadata> parseMessageFile(
  String arbFile,
  GenerationOptions options,
) async {
  final decoded = jsonDecode(arbFile) as Map;
  final arb = Map.castFrom<dynamic, dynamic, String, dynamic>(decoded);
  return ArbParser(options.findById).parseMessageFile(arb);
}

class ParsedMessageFile {
  final String path;
  final MessagesWithMetadata message;

  ParsedMessageFile({required this.path, required this.message});
}
