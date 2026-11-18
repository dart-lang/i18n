// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart' as old_intl;
import 'package:messages/messages_json.dart';
import 'package:messages_builder/message_parser/icu_message_parser.dart';
import 'package:messages_builder/message_parser/message_parser.dart';
import 'package:test/test.dart';

Message _intlPluralSelector(
  num howMany,
  String locale, {
  Map<int, Message>? numberCases,
  Map<int, Message>? wordCases,
  Message? few,
  Message? many,
  required Message other,
}) {
  return old_intl.Intl.pluralLogic(
    howMany,
    few: few,
    many: many,
    zero: numberCases?[0] ?? wordCases?[0],
    one: numberCases?[1] ?? wordCases?[1],
    two: numberCases?[2] ?? wordCases?[2],
    other: other,
    locale: locale,
  );
}

String _render(String template, List<Object?> args, {String locale = 'en'}) {
  final parsed = MessageParser.parse('test.arb', template, 'msg');
  return parsed.message.generateString(
    args,
    pluralSelector: _intlPluralSelector,
    locale: locale,
  );
}

void main() {
  group('ICU single-quote escaping', () {
    test('preserves lone apostrophes not preceding braces', () {
      final parsed = MessageParser.parse('test.arb', "It's {name}'", 'msg');
      expect(parsed.placeholders.map((p) => p.name), ['name']);
      expect(_render("It's {name}'", ['Ada']), "It's Ada'");
      expect(_render("L'article", const []), "L'article");
      expect(_render("'", const []), "'");
    });

    test('collapses doubled single quotes to a single literal quote', () {
      expect(_render("It''s {name}", ['Ada']), "It's Ada");
      expect(_render("''", const []), "'");
      expect(_render("''''", const []), "''");
    });

    test('treats quoted braces and placeholders as literal text', () {
      final parsed = MessageParser.parse(
        'test.arb',
        "Use '{name}' here",
        'msg',
      );
      expect(parsed.placeholders, isEmpty);
      expect(_render("Use '{name}' here", const []), 'Use {name} here');
      expect(_render("Literal '{' and '}'", const []), 'Literal { and }');
    });

    test('supports doubled single quotes inside quoted sections', () {
      expect(_render("'{isn''t}'", const []), "{isn't}");
      expect(
        _render("Prefix '{a ''quoted'' {brace}}' suffix", const []),
        "Prefix {a 'quoted' {brace}} suffix",
      );
    });

    test('handles escaped quotes adjacent to real placeholders and braces', () {
      final parsed = MessageParser.parse('test.arb', "''{name}", 'msg');
      expect(parsed.placeholders.map((p) => p.name), ['name']);
      expect(_render("''{name}", ['Ada']), "'Ada");
      expect(_render("'''{'", const []), "'{");
      expect(_render("'{a}'{name}", ['Ada']), '{a}Ada');
    });

    test('supports escapes inside plural and select branches', () {
      const pluralTemplate =
          "{count, plural, =0{No '{items}'} other{It''s {count} '{items}'}}";
      expect(_render(pluralTemplate, [0]), 'No {items}');
      expect(_render(pluralTemplate, [3]), "It's 3 {items}");

      const selectTemplate =
          "{role, select, admin{'{admin}' role} other{User's role}}";
      expect(_render(selectTemplate, ['admin']), '{admin} role');
      expect(_render(selectTemplate, ['guest']), "User's role");
    });

    test('throws L10nParserException on unclosed quoted braces', () {
      expect(
        () => MessageParser.parse('test.arb', "Use '{unclosed", 'msg'),
        throwsA(
          isA<L10nParserException>()
              .having(
                (e) => e.error,
                'error',
                'ICU Lexing Error: Unmatched single quotes.',
              )
              .having((e) => e.charNumber, 'charNumber', 4),
        ),
      );
      expect(
        () => MessageParser.parse('test.arb', "Ok '}' bad '{''", 'msg'),
        throwsA(
          isA<L10nParserException>().having(
            (e) => e.charNumber,
            'charNumber',
            11,
          ),
        ),
      );
    });

    test('throws L10nParserException on unescaped closing brace', () {
      expect(
        () => MessageParser.parse('test.arb', 'Hello } world', 'msg'),
        throwsA(isA<L10nParserException>()),
      );
      expect(
        () => MessageParser.parse('test.arb', 'Hello }', 'msg'),
        throwsA(
          isA<L10nParserException>().having(
            (e) => e.charNumber,
            'charNumber',
            6,
          ),
        ),
      );
    });
  });
}
