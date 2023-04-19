// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';
import 'package:messages_builder/code_generation/generation.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';

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
    var loadingStrategy = Field((fb) => fb
      ..name = '_loadingStrategy'
      ..modifier = FieldModifier.final$
      ..type = Reference(
          '${getAsyncReference('Uint8List', options).symbol} Function(String id)'));
    var currentLocale = Field(
      (fb) => fb
        ..type = Reference('String')
        ..name = '_currentLocale'
        ..assignment = Code("'${messageList.locale}'"),
    );
    var messages = Field(
      (fb) => fb
        ..modifier = FieldModifier.final$
        ..type = Reference('Map<String, MessageList>')
        ..name = '_messages'
        ..assignment = Code('{}'),
    );
    var carbs = Field(
      (fb) => fb
        ..name = '_carbs'
        ..modifier = FieldModifier.final$
        ..assignment = Code(
            '{${localeCarbPaths.entries.map((e) => "'${e.key}' : '${e.value}'").join(',')}}'),
    );
    var hashes = Field(
      (p0) => p0
        ..name = '_messageListHashes'
        ..modifier = FieldModifier.final$
        ..assignment = Code(
            '{${resourceToHash.entries.map((e) => "'${e.key}' : '${e.value}'").join(',')}}'),
    );
    var cleaner = Field(
      (fb) => fb
        ..name = 'cleaner'
        ..type = Reference('String Function(String)?'),
    );
    var fields = [
      if (options.isNative) loadingStrategy,
      currentLocale,
      messages,
      carbs,
      hashes,
      if (options.useCleaner) cleaner
    ];
    return fields;
  }
}
