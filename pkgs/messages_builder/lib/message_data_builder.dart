// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:messages_serializer/messages_serializer.dart';
import 'package:path/path.dart' as p;

import 'builder.dart';
import 'generation_options.dart';
import 'located_message_file.dart';
import 'message_family.dart';
import 'message_file.dart';

class MessageDataFileBuilder {
  final Directory inputFolder;
  final Directory outputFolder;
  final GenerationOptions options;

  MessageDataFileBuilder({
    required this.inputFolder,
    required this.outputFolder,
    required this.options,
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

    final messageFiles = [
      for (final arbFilePath in arbFiles)
        LocatedMessageFile(
          path: arbFilePath,
          file: await parseMessageFile(
            await File.fromUri(Uri.file(arbFilePath)).readAsString(),
            options,
          ),
        ),
    ];

    // Translations are aligned with their template, so that the generated
    // code finds the right message in every data file.
    for (final family in groupIntoFamilies(messageFiles, warn: print)) {
      for (final messageFile in family.files) {
        final arbFilePath = messageFile.path;
        print('Generating $arbFilePath, bundle this in your assets.');

        final serializer = JsonSerializer(options.findById);

        final data = _arbToData(messageFile.file, serializer);

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
    }
    return mapping;
  }

  String _arbToData(
    MessageFile messageBundle,
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
