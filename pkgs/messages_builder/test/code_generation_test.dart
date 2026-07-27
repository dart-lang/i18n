// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages_builder/arb_parser.dart';
import 'package:messages_builder/code_generation/classes_generation.dart';
import 'package:messages_builder/code_generation/code_generation.dart';
import 'package:messages_builder/generation_options.dart';
import 'package:messages_builder/located_message_file.dart';
import 'package:test/test.dart';

void main() {
  group('CodeGenerator with PluralSelectorType.custom', () {
    test(
      'generates constructor parameter and field for custom pluralSelector',
      () async {
        const pubspec = '''
name: test_pkg
package_options:
  messages_builder:
    plural_selector: custom
''';
        final options = await GenerationOptions.fromPubspec(pubspec);

        final arb = <String, dynamic>{
          '@@locale': 'en',
          '@@context': 'App',
          'hello': 'Hello world',
        };
        final messageFile = ArbParser().parseMessageFile(arb);
        final locatedFile = LocatedMessageFile(
          path: 'assets/app_en.arb.json',
          file: messageFile,
        );

        final classes = ClassesGeneration(
          options: options,
          context: 'App',
          parent: locatedFile,
          children: [locatedFile],
          emptyFiles: {'en': 'App_en_empty'},
        ).generate();

        final code = CodeGenerator(
          options: options,
          classes: classes,
          emptyFilePaths: ['App_en_empty'],
        ).generate();

        // Should require pluralSelector parameter in constructor
        expect(
          code,
          contains('AppMessages(this._assetLoader, this.pluralSelector)'),
        );

        // Should define pluralSelector field
        expect(code, contains('pluralSelector;'));

        // Should NOT generate default _pluralSelector function
        expect(code, isNot(contains('Message _pluralSelector(')));

        // Should NOT import package:intl or package:intl4x
        expect(code, isNot(contains("import 'package:intl/intl.dart'")));
        expect(
          code,
          isNot(contains("import 'package:intl4x/plural_rules.dart'")),
        );
      },
    );
  });
}
