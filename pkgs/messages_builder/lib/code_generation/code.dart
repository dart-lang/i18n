// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../generation_options.dart';
import 'import_generation.dart';

class CodeGenerator {
  final GenerationOptions options;
  final List<Library> libraries;

  CodeGenerator({required this.options, required this.libraries});

  String generate() {
    final imports = ImportGeneration(options).generate();

    final lib = libraries.reduce((value, element) => Library(
          (p0) => p0
            ..comments.add(options.header)
            ..directives.addAll(imports)
            ..body.addAll([
              ...value.body,
              ...element.body,
              if (options.pluralSelector != PluralSelectorType.custom)
                pluralSelector(),
            ]),
        ));

    final emitter = DartEmitter(orderDirectives: true);
    final source = '${lib.accept(emitter)}';
    final code = DartFormatter().format(source);
    return code;
  }

  // Message Function(num,
  //     String locale,
  //     {Message? few,
  //     String? locale,
  //     Message? many,
  //     Map<int, Message>? numberCases,
  //     required Message other,
  //     Map<int, Message>? wordCases}) intl;
  Method pluralSelector() => Method(
        (mb) => mb
          ..name = '_pluralSelector'
          ..returns = const Reference('Message')
          ..requiredParameters.addAll([
            Parameter(
              (pb) => pb
                ..name = 'howMany'
                ..type = const Reference('num')
                ..named = false,
            ),
            Parameter(
              (pb) => pb
                ..name = 'locale'
                ..type = const Reference('String')
                ..named = false,
            ),
          ])
          ..optionalParameters.addAll([
            Parameter(
              (pb) => pb
                ..name = 'other'
                ..type = const Reference('Message')
                ..required = true
                ..named = true,
            ),
            Parameter(
              (pb) => pb
                ..name = 'few'
                ..type = const Reference('Message?')
                ..named = true,
            ),
            Parameter(
              (pb) => pb
                ..name = 'many'
                ..type = const Reference('Message?')
                ..named = true,
            ),
            Parameter(
              (pb) => pb
                ..name = 'numberCases'
                ..type = const Reference('Map<int, Message>?')
                ..named = true,
            ),
            Parameter(
              (pb) => pb
                ..name = 'wordCases'
                ..type = const Reference('Map<int, Message>?')
                ..named = true,
            ),
          ])
          ..body = pluralSelectorBody(),
      );

  Code pluralSelectorBody() {
    return switch (options.pluralSelector) {
      PluralSelectorType.intl => const Code('''
return Intl.pluralLogic(
    howMany,
    few: few,
    many: many,
    zero: numberCases?[0] ?? wordCases?[0],
    one: numberCases?[1] ?? wordCases?[1],
    two: numberCases?[2] ?? wordCases?[2],
    other: other,
    locale: currentLocale,
  );
  '''),
      PluralSelectorType.intl4x => const Code('''
    Message getCase(int i) => numberCases?[i] ?? wordCases?[i] ?? other;
        return switch (Intl(locale: Locale.parse(locale)).plural().select(howMany)) {
    PluralCategory.zero => getCase(0),
    PluralCategory.one => getCase(1),
    PluralCategory.two => getCase(2),
    PluralCategory.few => few ?? other,
    PluralCategory.many => many ?? other,
    PluralCategory.other => other,
        };
        '''),
      PluralSelectorType.custom => throw ArgumentError(),
    };
  }
}
