import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:yaml/yaml.dart';

class GenerationOptions {
  final bool messageCalls;
  final bool findById;
  final bool findByEnum;
  final bool findByIndex;
  final bool useCleaner;
  final SerializationType serialization;
  final DeserializationType deserialization;
  final bool makeAsync;
  final bool isInline;

  GenerationOptions({
    required this.serialization,
    required this.deserialization,
    required this.messageCalls,
    required this.findById,
    required this.findByEnum,
    required this.findByIndex,
    required this.useCleaner,
    required this.makeAsync,
    required this.isInline,
  });

  static Future<GenerationOptions> fromPubspec(BuildStep buildStep) async {
    final pubspecId = await buildStep.findAssets(Glob('pubspec.yaml')).first;
    final pubspecData = await buildStep.readAsString(pubspecId);
    final pubspec = loadYaml(pubspecData) as YamlMap;
    final messagesOptions = pubspec['messages'] as YamlMap;
    final generationOptions = GenerationOptions(
      serialization: SerializationType.json,
      deserialization: DeserializationType.web,
      messageCalls: (messagesOptions['generateMethods'] as bool?) ?? true,
      findById: (messagesOptions['generateFindById'] as bool?) ?? false,
      findByEnum: (messagesOptions['generateFindByEnum'] as bool?) ?? false,
      findByIndex: (messagesOptions['generateFindByIndex'] as bool?) ?? false,
      useCleaner: (messagesOptions['useCleaner'] as bool?) ?? false,
      makeAsync: (messagesOptions['async'] as bool?) ?? false,
      isInline: (messagesOptions['inline'] as bool?) ?? false,
    );
    return generationOptions;
  }
}

enum SerializationType {
  json;
}

enum DeserializationType {
  web;
}
