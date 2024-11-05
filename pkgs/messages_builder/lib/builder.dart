// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

import 'arb_parser.dart';
import 'code_generation/code_generation.dart';
import 'code_generation/library_generation.dart';
import 'code_generation/message_file_metadata.dart';
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
    final messageFiles = await parseMessageFiles();

    final families = messageFiles.groupListsBy(
        (messageFile) => getParentFile(messageFiles, messageFile));

    var counter = 0;

    for (final MapEntry(key: parent, value: children) in families.entries) {
      final context = parent.file.context;

      final childrensMetadata = collectMetadata(children);

      printIncludeFilesNotification(
          context, childrensMetadata.map((e) => e.path));

      final dummyFilePaths = Map.fromEntries(childrensMetadata
          .map((e) => e.locale)
          .map((e) => MapEntry(e, [context, e, 'empty'].join('_'))));

      final library = LibraryGeneration(
              options: options,
              context: context,
              initialLocale: parent.file.locale!,
              messages: parent.file.messages,
              messageFilesMetadata: childrensMetadata,
              emptyFiles: dummyFilePaths)
          .generate();

      final code = CodeGenerator(
        options: options,
        library: library,
        emptyFilePaths: dummyFilePaths.values,
      ).generate();

      final parentPath = Directory(options.generatedCodeFiles.path);

      final mainFile = File(path.join(
          parentPath.path, '${context ?? 'm${counter++}'}_messages.g.dart'));
      await mainFile.create(recursive: true);
      await mainFile.writeAsString(code);

      for (final MapEntry(key: locale, value: emptyFilePath)
          in dummyFilePaths.entries) {
        final file = File(path.join(parentPath.path, '$emptyFilePath.g.dart'));
        await file.create();
        await file.writeAsString('''
/// This is a helper file for deferred loading of the messages for locale $locale, generated by `dart run messages`.
''');
      }
    }
  }

  List<MessageFileMetadata> collectMetadata(
          List<LocatedMessageFile> messageFiles) =>
      messageFiles
          .map((messageFile) => MessageFileMetadata(
                locale: messageFile.file.locale ?? 'en_US',
                path: 'packages/${options.packageName}/${messageFile.path}',
                hash: messageFile.file.hash,
              ))
          .sortedBy((resource) => resource.locale);

  Future<List<LocatedMessageFile>> parseMessageFiles() async =>
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
  return ArbParser(options.findById).parseMessageFile(arb);
}

class LocatedMessageFile {
  final String path;
  final MessageFile file;

  LocatedMessageFile({required this.path, required this.file});
}
