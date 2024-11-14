// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:messages_builder/generation_options.dart';
import 'package:messages_builder/message_code_builder.dart';
import 'package:messages_builder/message_data_builder.dart';

/// Regenerates both data files and code for retrieving the messages from the
/// data files.
///
/// Executed by running `dart run messages_builder` in a project with a
/// dependency on `package:messages`.
Future<void> main(List<String> args) async {
  final pubspecUri = Directory.current.uri.resolve('pubspec.yaml');
  final generationOptions = await _generationOptions(pubspecUri);
  final inputFolder = Directory.fromUri(
      Directory.current.uri.resolve('assets/').resolve('l10n/'));
  final outputFolder =
      Directory.fromUri(Directory.current.uri.resolve('assets/'));

  final mapping = await MessageDataBuilder(
    inputFolder: inputFolder,
    outputFolder: outputFolder,
    options: generationOptions,
  ).run();

  await MessageCodeBuilder(
    inputToOutputFiles: mapping,
    options: generationOptions,
    pubspecUri: pubspecUri,
  ).build();
}

Future<GenerationOptions> _generationOptions(Uri pubspecUri) async {
  final file = File.fromUri(pubspecUri);
  final pubspecContents = await file.readAsString();
  return await GenerationOptions.fromPubspec(pubspecContents);
}
