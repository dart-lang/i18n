// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:messages_serializer/messages_serializer.dart';
import 'package:path/path.dart' as p;

import 'builder.dart';
import 'generation_options.dart';
import 'message_with_metadata.dart';

class MessagesDataBuilder {
  //TODO allow arbs from other locations than package root subfolders
  MessagesDataBuilder();

  Future<void> run({
    required Directory inputFolder,
    required Directory outputFolder,
    required String libOutput,
  }) async {
    print('Starting to add arb files from $inputFolder to $outputFolder');
    final arbFiles = await inputFolder
        .list()
        .where((file) => file is File)
        .map((file) => file.path)
        .where((path) => p.extension(path) == '.arb')
        .toList();
    for (final arbFilePath in arbFiles) {
      print('Generating $arbFilePath, bundle this in your assets.');
      final arbFileUri = Uri.file(arbFilePath);
      final arbFileContents = await File.fromUri(arbFileUri).readAsString();
      final generationOptions = await _generationOptions();
      final messageBundle = await parseMessageFile(
        arbFileContents,
        generationOptions,
      );

      final serializer = JsonSerializer(generationOptions.findById);

      final data = _arbToData(messageBundle, arbFilePath, serializer);

      final assetName =
          p.setExtension(p.basename(arbFilePath), serializer.extension);

      final dataFile = File.fromUri(outputFolder.uri.resolve(assetName));
      await dataFile.create();
      await dataFile.writeAsString(data);
    }
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

  Future<GenerationOptions> _generationOptions() async {
    final pubspecUri = Directory.current.uri.resolve('pubspec.yaml');
    final file = File.fromUri(pubspecUri);
    return GenerationOptions.fromPubspec(await file.readAsString());
  }
}
