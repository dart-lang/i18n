// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:messages_builder/builder.dart';
import 'package:messages_builder/generation_options.dart';
import 'package:messages_builder/message_data_builder.dart';

/// Regenerates both data files and code for retrieving the messages from the
/// data files.
///
/// Executed by running `dart run messages_builder` in a project with a
/// dependency on `package:messages`.
Future<void> main(List<String> args) async {
  final generationOptions = await _generationOptions();
  final inputFolder = Directory.fromUri(
      Directory.current.uri.resolve('assets/').resolve('l10n/'));
  final outputFolder =
      Directory.fromUri(Directory.current.uri.resolve('assets/'));

  final mapping = await MessageDataFileBuilder(
    inputFolder: inputFolder,
    outputFolder: outputFolder,
    generationOptions: generationOptions,
  ).run();

  await MessageCallingCodeGenerator(
    mapping: mapping,
    options: generationOptions,
  ).build();
}

Future<GenerationOptions> _generationOptions() async {
  final pubspecUri = Directory.current.uri.resolve('pubspec.yaml');
  final file = File.fromUri(pubspecUri);
  final pubspecContents = await file.readAsString();
  return await GenerationOptions.fromPubspec(pubspecContents);
}
