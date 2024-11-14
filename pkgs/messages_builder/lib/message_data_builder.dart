// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:messages_serializer/messages_serializer.dart';
import 'package:path/path.dart' as p;

import 'generation_options.dart';
import 'message_file.dart';

class MessageDataBuilder {
  final Directory inputFolder;
  final Directory outputFolder;
  final GenerationOptions options;

  MessageDataBuilder({
    required this.inputFolder,
    required this.outputFolder,
    required this.options,
  });

  Future<Map<String, String>> run() async {
    print('''
Searching "${p.relative(inputFolder.path, from: '.')}" for arb files.''');
    final arbFiles = await inputFolder
        .list()
        .where((file) => file is File)
        .map((file) => file.path)
        .where((path) => p.extension(path) == '.arb')
        .toList();

    if (arbFiles.isEmpty) {
      print('No arb files in ${p.relative(inputFolder.path, from: '.')}.');
      return {};
    }

    final serializer = JsonSerializer(generationOptions.findById);
    final inputOutputPairs = Map.fromEntries(arbFiles.map(
      (inputPath) {
        final assetName = p.setExtension(
          p.basename(inputPath),
          '.arb${serializer.extension}',
        );
        final outputDataPath = p.join(outputFolder.path, assetName);
        return MapEntry(inputPath, outputDataPath);
      },
    ));

    if (arbFiles.isNotEmpty) {
      print('Generating data files from arb sources.');
    }
    for (final MapEntry(key: arbFilePath, value: outputDataPath)
        in inputOutputPairs.entries) {
      stdout.write('${p.relative(arbFilePath, from: '.')} --> ');
      final arbFileUri = Uri.file(arbFilePath);
      final arbFileContents = await File.fromUri(arbFileUri).readAsString();
      final messageBundle = await parseMessageFile(arbFileContents, options);

      final serializer = JsonSerializer(options.findById);

      final data = _arbToData(messageBundle, arbFilePath, serializer);

      stdout.writeln('${p.relative(outputDataPath, from: '.')}.');
      final dataFile = File(outputDataPath);
      if (await dataFile.exists() && (await dataFile.readAsString() == data)) {
        continue;
      } else {
        await dataFile.create();
        await dataFile.writeAsString(data);
        print('''
${p.relative(arbFilePath, from: '.')} --> ${p.relative(outputDataPath, from: '.')}''');
      }
    }
    return inputOutputPairs;
  }

  String _arbToData(
    MessageFile messageBundle,
    String arbFilePath,
    Serializer<String> serializer,
  ) =>
      serializer
          .serialize(
            messageBundle.hash,
            messageBundle.locale ?? 'en_US',
            messageBundle.messages.map((e) => e.message).toList(),
          )
          .data;
}
