// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:messages_serializer/messages_serializer.dart';
import 'package:path/path.dart' as p;

import 'builder.dart';
import 'generation_options.dart';
import 'message_with_metadata.dart';

class MessageDataFileBuilder {
  final Directory inputFolder;
  final Directory outputFolder;
  final GenerationOptions generationOptions;

  MessageDataFileBuilder({
    required this.inputFolder,
    required this.outputFolder,
    required this.generationOptions,
  });

  Future<Map<String, String>> run() async {
    print('Starting to add arb files from $inputFolder to $outputFolder');
    final arbFiles = await inputFolder
        .list()
        .where((file) => file is File)
        .map((file) => file.path)
        .where((path) => p.extension(path) == '.arb')
        .toList();

    final mapping = <String, String>{};
    if (arbFiles.isEmpty) {
      print('No `.arb` files found in $inputFolder.');
      return mapping;
    }

    for (final arbFilePath in arbFiles) {
      print('Generating $arbFilePath, bundle this in your assets.');
      final arbFileUri = Uri.file(arbFilePath);
      final arbFileContents = await File.fromUri(arbFileUri).readAsString();
      final messageBundle = await parseMessageFile(
        arbFileContents,
        generationOptions,
      );

      final serializer = JsonSerializer(generationOptions.findById);

      final data = _arbToData(messageBundle, arbFilePath, serializer);

      final assetName = p.setExtension(
        p.basename(arbFilePath),
        '.arb${serializer.extension}',
      );

      final outputDataPath = outputFolder.uri.resolve(assetName);
      final dataFile = File.fromUri(outputDataPath);
      await dataFile.create();
      await dataFile.writeAsString(data);
      mapping[arbFilePath] = outputDataPath.path;
    }
    return mapping;
  }

  String _arbToData(
    MessagesWithMetadata messageBundle,
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
