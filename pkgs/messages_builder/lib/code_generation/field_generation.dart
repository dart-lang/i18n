// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';
import 'generation.dart';

class FieldGeneration extends Generation<Field> {
  final GenerationOptions options;
  final Map<String, String> localeCarbPaths;
  final MessageListWithMetadata messageList;
  final Map<String, String> resourceToHash;

  FieldGeneration(
    this.options,
    this.localeCarbPaths,
    this.messageList,
    this.resourceToHash,
  );

  @override
  List<Field> generate() {
    final loadingStrategy = Field(
      (fb) {
        final returnType = const Reference('String').symbol;
        fb
          ..name = '_fileLoader'
          ..modifier = FieldModifier.final$
          ..type = Reference('$returnType Function(String id)');
      },
    );
    final currentLocale = Field(
      (fb) => fb
        ..type = const Reference('String')
        ..name = '_currentLocale'
        ..assignment = Code("'${messageList.locale}'"),
    );
    final messages = Field(
      (fb) => fb
        ..modifier = FieldModifier.final$
        ..type = const Reference('Map<String, MessageList>')
        ..name = '_messages'
        ..assignment = const Code('{}'),
    );
    final carbs = Field(
      (fb) {
        final paths = localeCarbPaths.entries
            .map((e) => "'${e.key}' : '${e.value}'")
            .join(',');
        fb
          ..name = '_carbs'
          ..modifier = FieldModifier.final$
          ..assignment = Code('{$paths}');
      },
    );
    final hashes = Field(
      (p0) {
        final hashList = resourceToHash.entries
            .map((e) => "'${e.key}' : '${e.value}'")
            .join(',');
        p0
          ..name = '_messageListHashes'
          ..modifier = FieldModifier.final$
          ..assignment = Code('{$hashList}');
      },
    );
    final intlObject = Field(
      (fb) => fb
        ..name = 'intlObject'
        ..type = const Reference('IntlObject'),
    );
    final fields = [
      loadingStrategy,
      currentLocale,
      messages,
      carbs,
      hashes,
      intlObject,
    ];
    return fields;
  }
}
