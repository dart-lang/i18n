// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import 'generation.dart';

class FieldGeneration extends Generation<Field> {
  final GenerationOptions options;
  final Map<String, ({String path, String hasch})> localeToResourceInfo;
  final String locale;

  FieldGeneration(
    this.options,
    this.localeToResourceInfo,
    this.locale,
  );

  @override
  List<Field> generate() {
    final loadingStrategy = Field(
      (fb) {
        final returnType = const Reference('Future<String>').symbol;
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
        ..assignment = Code("'$locale'"),
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
        final paths = localeToResourceInfo.entries
            .map((e) => "'${e.key}' : ('${e.value.path}', '${e.value.hasch}')")
            .join(',');
        fb
          ..name = 'carbs'
          ..modifier = FieldModifier.constant
          ..static = true
          ..assignment = Code('{$paths}');
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
      intlObject,
    ];
    return fields;
  }
}
