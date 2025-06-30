// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../located_message_file.dart';

class FieldGeneration {
  final GenerationOptions options;
  final Iterable<LocatedMessageFile> messageFiles;
  final String initialLocale;

  FieldGeneration(
    this.options,
    this.messageFiles,
    this.initialLocale,
  );

  List<Field> generate() {
    final loadingStrategy = Field(
      (fb) {
        final returnType = const Reference('Future<String>').symbol;
        fb
          ..name = '_assetLoader'
          ..modifier = FieldModifier.final$
          ..type = Reference('$returnType Function(String id)');
      },
    );
    final currentLocale = Field(
      (fb) => fb
        ..type = const Reference('String')
        ..name = '_currentLocale'
        ..assignment = Code("'$initialLocale'"),
    );
    final messages = Field(
      (fb) => fb
        ..modifier = FieldModifier.final$
        ..type = const Reference('Map<String, MessageList>')
        ..name = '_messages'
        ..assignment = const Code('{}'),
    );
    final dataFiles = Field(
      (fb) {
        final paths = messageFiles
            .map((e) => """
'${e.locale}' : ('${e.namespacedPath(options.packageName)}', '${e.hash}')""")
            .join(',');
        fb
          ..name = '_dataFiles'
          ..modifier = FieldModifier.constant
          ..static = true
          ..assignment = Code('{$paths}');
      },
    );
    final pluralSelector = Field(
      (fb) => fb
        ..name = 'pluralSelector'
        ..type = const Reference(
            '''Message Function(num howMany, {Map<int, Message>? numberCases, Map<int, Message>? wordCases, Message? few, Message? many, Message other, String? locale})'''),
    );
    final fields = [
      loadingStrategy,
      currentLocale,
      messages,
      dataFiles,
      if (options.pluralSelector == PluralSelectorType.custom) pluralSelector,
    ];
    return fields;
  }
}
