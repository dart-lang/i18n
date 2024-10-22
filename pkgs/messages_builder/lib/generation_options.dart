// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:collection/collection.dart';
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

  /// The header to add to all generated files, for example for licensing.
  final String header;

  /// The origin of the algorithm for determining which plural case to use.
  final PluralSelectorType pluralSelector;

  /// Where the arb files are located.
  final Directory arbFolder;

  /// Where to write the message data files to.
  final Directory messageFolder;

  final File generatedCodeFile;

  final String packageName;

  static const _generateMethodsKey = 'generate_methods';
  static const _generateFindByIdKey = 'generate_find_by_id';
  static const _generateFindByKey = 'generate_find_by';
  static const _headerKey = 'header';
  static const _pluralSelectorKey = 'plural_selector';
  static const _arbInputFolderKey = 'arb_input_folder';
  static const _messageOutputFolderKey = 'message_output_folder';
  static const _generatedCodeFileKey = 'generated_code_file';

  static List<String> get validKeys => [
        _generateMethodsKey,
        _generateFindByIdKey,
        _generateFindByKey,
        _pluralSelectorKey,
        _headerKey,
        _arbInputFolderKey,
        _messageOutputFolderKey,
        _generatedCodeFileKey,
      ];

  GenerationOptions({
    required this.serialization,
    required this.deserialization,
    required this.messageCalls,
    required this.findById,
    required this.indexType,
    required this.header,
    required this.pluralSelector,
    required this.packageName,
    required this.arbFolder,
    required this.messageFolder,
    required this.generatedCodeFile,
  });

  static Future<GenerationOptions> fromPubspec(String pubspecData) async {
    final pubspec = loadYaml(pubspecData) as YamlMap;
    final packageOptions = pubspec['package_options'] as YamlMap?;
    final messagesOptions = packageOptions?['messages_builder'] as YamlMap?;
    final illegalKey = messagesOptions?.keys
        .firstWhereOrNull((key) => !validKeys.contains(key));
    if (illegalKey != null) {
      throw ArgumentError(
          'The message options contain the illegal key $illegalKey');
    }
    final generationOptions = GenerationOptions(
        serialization: SerializationType.json,
        deserialization: DeserializationType.web,
        messageCalls: (messagesOptions?[_generateMethodsKey] as bool?) ?? true,
        findById: (messagesOptions?[_generateFindByIdKey] as bool?) ?? false,
        indexType: _indexType(messagesOptions),
        header: messagesOptions?[_headerKey] as String? ??
            'Generated by package:messages_builder.',
        pluralSelector: _pluralSelector(messagesOptions),
        packageName: pubspec['name'] as String,
        arbFolder: Directory(
            messagesOptions?[_arbInputFolderKey] as String? ?? 'assets/l10n/'),
        messageFolder: Directory(
            messagesOptions?[_messageOutputFolderKey] as String? ?? 'assets/'),
        generatedCodeFile: File(
            messagesOptions?[_generatedCodeFileKey] as String? ??
                'lib/src/messages.g.dart'));
    return generationOptions;
  }

  static IndexType _indexType(YamlMap? messagesOptions) {
    final generateFindString = messagesOptions?[_generateFindByKey] as String?;
    return generateFindString != null
        ? IndexType.values
            .where((type) => type.name == generateFindString)
            .first
        : IndexType.integer;
  }

  static PluralSelectorType _pluralSelector(YamlMap? messagesOptions) {
    final pluralSelectorString =
        messagesOptions?[_pluralSelectorKey] as String?;
    return pluralSelectorString != null
        ? PluralSelectorType.values
            .where((type) => type.name == pluralSelectorString)
            .first
        : PluralSelectorType.intl;
  }
}

enum SerializationType {
  json;
}

enum DeserializationType {
  web;
}

/// How the indexing of the messages should be implemented.
enum IndexType {
  /// No indexing.
  none,

  /// Indexing via a collection of `static int`s.
  integer,

  /// Indexing via an enum.
  enumerate;
}

/// The origin of the algorithm for determining which plural case to use.
enum PluralSelectorType {
  /// From `package:intl`.
  intl,

  /// From `package:intl4x`.

  intl4x,

  /// A user-specified algorithm.
  custom;
}
