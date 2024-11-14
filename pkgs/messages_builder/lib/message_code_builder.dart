// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import 'arb_parser.dart';
import 'code_generation/classes_generation.dart';
import 'code_generation/code_generation.dart';
import 'generation_options.dart';
import 'located_message_file.dart';
import 'message_file.dart';

class MessageCodeBuilder {
  final GenerationOptions options;
  final Map<String, String> inputToOutputFiles;
  final Uri pubspecUri;

  MessageCodeBuilder({
    required this.options,
    required this.inputToOutputFiles,
    required this.pubspecUri,
  });

  Future<void> build() async {
    final messageFiles = await _parseMessageFiles();

    final families = messageFiles
        .groupListsBy((messageFile) => getParentFile(messageFiles, messageFile))
        .map((key, value) =>
            MapEntry(key, value.sortedBy((messageFile) => messageFile.locale)));

    var counter = 0;

    for (final MapEntry(key: parent, value: children) in families.entries) {
      final context = parent.file.context;

      await includeFilesInPubspec(context, children.map((f) => f.path));

      final dummyFilePaths = Map.fromEntries(children
          .map((e) => e.locale)
          .map((e) => MapEntry(e, [context, e, 'empty'].join('_'))));

      final library = ClassesGeneration(
        options: options,
        context: context,
        parent: parent,
        children: children,
        emptyFiles: dummyFilePaths,
      ).generate();

      final code = CodeGenerator(
        options: options,
        classes: library,
        emptyFilePaths: dummyFilePaths.values,
      ).generate();

      final parentPath = Directory(options.generatedCodeFiles.path);

      final codeFile = File(path.join(
          parentPath.path, '${context ?? 'm${counter++}'}_messages.g.dart'));
      print(
          'Generate dart file at ${path.relative(codeFile.path, from: '.')}.');
      await codeFile.create(recursive: true);
      await codeFile.writeAsString(code);

      for (final MapEntry(key: locale, value: emptyFilePath)
          in dummyFilePaths.entries) {
        final file = File(path.join(parentPath.path, '$emptyFilePath.g.dart'));
        await file.create();
        await file.writeAsString('''
// This is a helper file for deferred loading of the messages for locale $locale,
// generated by `dart run messages`.
''');
      }
    }
  }

  Future<List<LocatedMessageFile>> _parseMessageFiles() async =>
      Future.wait(inputToOutputFiles.entries
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
  Future<void> includeFilesInPubspec(
    String? context,
    Iterable<String> fileList,
  ) async {
    final contextMessage =
        context != null ? 'For the messages in $context, the' : 'The';
    final fileListJoined = fileList.map((e) => '\t$e').join('\n');

    final pubspecFile = File.fromUri(pubspecUri);
    final pubspecString = await pubspecFile.readAsString();
    final yamlEditor = YamlEditor(pubspecString);
    if (yamlEditor.contains(['flutter', 'assets']) ||
        yamlEditor.contains(['dependencies', 'flutter'])) {
      if (!yamlEditor.contains(['flutter', 'assets'])) {
        yamlEditor.update(['flutter'], {'assets': <String>[]});
      }
      final existingAssets =
          (yamlEditor.parseAt(['flutter', 'assets']).value as YamlList)
              .map((element) => element as String);
      final newFiles = fileList.whereNot(existingAssets.contains);
      for (final file in newFiles) {
        yamlEditor.appendToList(['flutter', 'assets'], file);
      }
      if (newFiles.isNotEmpty) {
        print(
            '''$contextMessage following files have been declared in your assets:\n$newFiles''');
      }
      await pubspecFile.writeAsString(yamlEditor.toString());
    } else {
      print(
          '''$contextMessage following files must be added to your assets:\n$fileListJoined''');
    }
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

extension on YamlEditor {
  bool contains(List<String> path) =>
      parseAt(path, orElse: () => wrapAsYamlNode(null)).value != null;
}
