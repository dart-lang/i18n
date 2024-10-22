import 'dart:io';

import 'package:messages_builder/builder.dart';
import 'package:messages_builder/generation_options.dart';
import 'package:messages_builder/message_data_builder.dart';

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
