// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:yaml/yaml.dart';

/// Options for the message data file and code generation.
class GenerationOptions {
  /// Whether to generate named message calls. Example:
  /// An arb file like this
  /// ```json
  /// {
  ///   "helloName": "Hello {name}"
  /// }
  /// ```
  /// leads to
  /// ```dart
  /// String helloName(String name) {
  /// ```
  /// being generated.
  final bool messageCalls;

  /// Whether to generate a method to fetch a message by its id. Leads to the
  /// ids being stored in the data file.
  final bool findById;

  /// How the messages should be indexed, either through `int`s or an `enum`
  final IndexType indexType;

  /// The data file serialization, either json or (TBD) binary.
  final SerializationType serialization;

  /// The data file deserialization, either through browser functionalities or
  /// dart native code.
  final DeserializationType deserialization;

  GenerationOptions({
    required this.serialization,
    required this.deserialization,
    required this.messageCalls,
    required this.findById,
    required this.indexType,
  });

  static Future<GenerationOptions> fromPubspec(BuildStep buildStep) async {
    final pubspecId = await buildStep.findAssets(Glob('pubspec.yaml')).first;
    final pubspecData = await buildStep.readAsString(pubspecId);
    final pubspec = loadYaml(pubspecData) as YamlMap;
    final messagesOptions = pubspec['messages_builder'] as YamlMap?;
    final generationOptions = GenerationOptions(
      serialization: SerializationType.json,
      deserialization: DeserializationType.web,
      messageCalls: (messagesOptions?['generateMethods'] as bool?) ?? true,
      findById: (messagesOptions?['generateFindById'] as bool?) ?? false,
      indexType: IndexType.values
              .where((type) =>
                  type.name == messagesOptions?['generateFindBy'] as String?)
              .firstOrNull ??
          IndexType.integer,
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
