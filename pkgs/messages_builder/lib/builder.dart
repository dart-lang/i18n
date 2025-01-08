// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

import 'arb_parser.dart';
import 'code_generation/classes_generation.dart';
import 'code_generation/code_generation.dart';
import 'generation_options.dart';
import 'located_message_file.dart';
import 'message_file.dart';

class MessageCallingCodeGenerator {
  final GenerationOptions options;
  final Map<String, String> mapping;

  MessageCallingCodeGenerator({
    required this.options,
    required this.mapping,
  });

  Future<void> build() async {
    final messageFiles = await _parseMessageFiles();
    final codeOutDirectory = options.generatedCodeFiles.path;

    final families = messageFiles
        .groupListsBy((messageFile) => getParentFile(messageFiles, messageFile))
        .map((key, value) =>
            MapEntry(key, value.sortedBy((messageFile) => messageFile.locale)));

    var counter = 0;

    for (final MapEntry(key: parent, value: children) in families.entries) {
      final context = parent.file.context;

      printIncludeFilesNotification(context, children.map((f) => f.path));

      final library = ClassesGeneration(
        options: options,
        context: context,
        parent: parent,
        children: children,
      ).generate();

      final code = CodeGenerator(
        options: options,
        classes: library,
      ).generate();

      final parentPath = Directory(codeOutDirectory);

      final mainFile = File(path.join(
          parentPath.path, '${context ?? 'm${counter++}'}_messages.g.dart'));
      await mainFile.create(recursive: true);
      await mainFile.writeAsString(code);
    }
  }

  Future<List<LocatedMessageFile>> _parseMessageFiles() async =>
      Future.wait(mapping.entries
          .map((p) async => LocatedMessageFile(
                path: path.relative(p.value, from: Directory.current.path),
                file: await parseMessageFile(await getArbfile(p.key), options),
              ))
          .toList());

  Future<String> getArbfile(String path) async =>
      await File(path).readAsString();

  /// Either get the referenced parent file, or try to infer which it might be.
  static LocatedMessageFile getParentFile(
    List<LocatedMessageFile> messageFiles,
    LocatedMessageFile currentFile,
  ) {
    /// Try to infer by looking at which files contain metadata, which is a sign
    /// they might be the references for others in the same context.
    final filesInContext = messageFiles.where(
        (messageFile) => messageFile.file.context == currentFile.file.context);
    final potentialParent =
        filesInContext.firstWhereOrNull((element) => element.file.hasMetadata);
    if (potentialParent == null && filesInContext.length > 1) {
      throw ArgumentError('''
The files $filesInContext have no metadata, so it is not clear which one is the main source of truth.''');
    }
    return potentialParent ?? currentFile;
  }

  /// Display a notification to the user to include the newly generated files
  /// in their assets.
  void printIncludeFilesNotification(
    String? context,
    Iterable<String> fileList,
  ) {
    final contextMessage =
        context != null ? 'For the messages in $context, the' : 'The';
    final fileListJoined = fileList.map((e) => '\t$e').join('\n');
    print(
        '''$contextMessage following files need to be declared in your assets:\n$fileListJoined''');
  }
}

Future<MessageFile> parseMessageFile(
  String arbFile,
  GenerationOptions options,
) async {
  final decoded = jsonDecode(arbFile) as Map;
  final arb = Map.castFrom<dynamic, dynamic, String, dynamic>(decoded);
  return ArbParser().parseMessageFile(arb);
}
