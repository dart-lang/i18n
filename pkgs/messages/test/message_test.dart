// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart' as old_intl;
import 'package:messages/messages.dart';
import 'package:test/test.dart';

Message testPluralSelector(
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

void main() {
  group('StringMessage', () {
    test('renders static text without placeholders', () {
      final msg = StringMessage('Hello world');
      expect(
        msg.generateString([], pluralSelector: testPluralSelector),
        'Hello world',
      );
    });

    test('renders string with placeholders', () {
      final msg = StringMessage(
        'Hello , welcome to !',
        argPositions: [
          (stringIndex: 6, argIndex: 0),
          (stringIndex: 19, argIndex: 1),
        ],
      );
      expect(
        msg.generateString([
          'Alice',
          'Wonderland',
        ], pluralSelector: testPluralSelector),
        'Hello Alice, welcome to Wonderland!',
      );
    });

    test('applies cleaner function when provided', () {
      final msg = StringMessage('Hello world');
      expect(
        msg.generateString(
          [],
          pluralSelector: testPluralSelector,
          cleaner: (s) => s.toUpperCase(),
        ),
        'HELLO WORLD',
      );
    });
  });

  group('SelectMessage', () {
    test('selects matching case', () {
      final msg = SelectMessage(StringMessage('they'), {
        'female': StringMessage('she'),
        'male': StringMessage('he'),
      }, 0);
      expect(
        msg.generateString(['female'], pluralSelector: testPluralSelector),
        'she',
      );
      expect(
        msg.generateString(['male'], pluralSelector: testPluralSelector),
        'he',
      );
    });

    test('falls back to other when case is missing', () {
      final msg = SelectMessage(StringMessage('they'), {
        'female': StringMessage('she'),
      }, 0);
      expect(
        msg.generateString(['unknown'], pluralSelector: testPluralSelector),
        'they',
      );
    });
  });

  group('PluralMessage', () {
    test('selects correct plural logic case', () {
      final msg = PluralMessage(
        numberCases: {0: StringMessage('no items'), 1: StringMessage('1 item')},
        other: StringMessage('many items'),
        argIndex: 0,
      );

      expect(
        msg.generateString(
          [0],
          pluralSelector: testPluralSelector,
          locale: 'en',
        ),
        'no items',
      );
      expect(
        msg.generateString(
          [1],
          pluralSelector: testPluralSelector,
          locale: 'en',
        ),
        '1 item',
      );
      expect(
        msg.generateString(
          [5],
          pluralSelector: testPluralSelector,
          locale: 'en',
        ),
        'many items',
      );
    });
  });

  group('CombinedMessage', () {
    test('joins multiple submessages', () {
      final msg = CombinedMessage([
        StringMessage('Hello '),
        StringMessage('World!'),
      ]);
      expect(
        msg.generateString([], pluralSelector: testPluralSelector),
        'Hello World!',
      );
    });
  });
}
