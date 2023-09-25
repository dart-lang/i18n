import 'dart:io';

import 'package:args/args.dart';
import 'package:messages_shrinker/messages_shrinker.dart';

void main(List<String> args) {
  final argParser = ArgParser()
    ..addOption(
      'data-file',
      mandatory: true,
      help:
          '''The path to the data file containing the serialized translation messages.''',
    )
    ..addOption(
      'const-file',
      mandatory: true,
      help: 'The path to the output of the `const_finder`.',
    )
    ..addOption(
      'output-file',
      mandatory: true,
      help:
          '''The path to the data file containing the needed serialized translation messages.''',
    );
  String dataFile;
  String constInstancesFile;
  String outputFile;
  try {
    final results = argParser.parse(args);
    dataFile = results['data-file'] as String;
    constInstancesFile = results['const-file'] as String;
    outputFile = results['output-file'] as String;
  } catch (e) {
    print('Error: $e');
    print('\nUsage:');
    print(argParser.usage);
    exit(1);
  }
  MessageShrinker().shrink(dataFile, constInstancesFile, outputFile);
}
