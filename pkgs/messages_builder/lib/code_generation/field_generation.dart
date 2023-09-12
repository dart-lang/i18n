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
        final returnType = getAsyncReference('String', options).symbol;
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
      (fb) => fb
        ..name = '_carbs'
        ..modifier = FieldModifier.final$
        ..assignment = Code(
            '{${localeCarbPaths.entries.map((e) => "'${e.key}' : '${e.value}'").join(',')}}'),
    );
    final hashes = Field(
      (p0) => p0
        ..name = '_messageListHashes'
        ..modifier = FieldModifier.final$
        ..assignment = Code(
            '{${resourceToHash.entries.map((e) => "'${e.key}' : '${e.value}'").join(',')}}'),
    );
    final intlObject = Field(
      (fb) => fb
        ..name = 'intlObject'
        ..type = const Reference('IntlObject'),
    );
    final cleaner = Field(
      (fb) => fb
        ..name = 'cleaner'
        ..type = const Reference('String Function(String)?'),
    );
    final fields = [
      loadingStrategy,
      currentLocale,
      messages,
      carbs,
      hashes,
      intlObject,
      if (options.useCleaner) cleaner
    ];
    return fields;
  }
}
