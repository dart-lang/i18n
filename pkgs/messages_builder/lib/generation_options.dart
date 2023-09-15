// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:yaml/yaml.dart';

class GenerationOptions {
  final bool messageCalls;
  final bool findById;
  final IndexType findByType;
  final SerializationType serialization;
  final DeserializationType deserialization;

  GenerationOptions({
    required this.serialization,
    required this.deserialization,
    required this.messageCalls,
    required this.findById,
    required this.findByType,
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
      findByType: IndexType.values
              .where((type) =>
                  type.name == messagesOptions['generateFindBy'] as String?)
              .firstOrNull ??
          IndexType.none,
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

enum IndexType {
  none,
  integer,
  enumerate;
}
