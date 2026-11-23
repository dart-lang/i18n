// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl_translation/src/message_parser.dart';
import 'package:intl_translation/src/messages/composite_message.dart';
import 'package:intl_translation/src/messages/literal_string_message.dart';
import 'package:intl_translation/src/messages/message.dart';
import 'package:intl_translation/src/messages/submessages/gender.dart';
import 'package:intl_translation/src/messages/submessages/plural.dart';
import 'package:intl_translation/src/messages/submessages/select.dart';
import 'package:intl_translation/src/messages/variable_substitution_message.dart';
import 'package:test/test.dart';

void main() {
  test('Test escaping', () {
    testEscaping(
      r"interessant (fr): '<>{}= +-_$()&^%$#@!~`'",
      r"interessant (fr): \'<>{}= +-_\$()&^%\$#@!~`\'",
    );
    testEscaping('Escapes: \n\r\f\b\t\v.', r'Escapes: \n\r\f\b\t\v.');
    testEscaping("te'{st'}", 'te{st}');
    testEscaping("'{st'}te", '{st}te');
    testEscaping('{st}', r'${st}');
    testEscaping('{st}ts', r'${st}ts');
    testEscaping('te\${st}', r'te\$${st}');
    testEscaping('te{st}', r'te${st}');
    testEscaping("tes''t", "tes\\'t");
    testEscaping("t'e'''{st'}", "t\\'e\\'{st}");
    testEscaping(
      'Escapes: \u202a\u202b\u202c\u202d\u202e'
          '\u2066\u2067\u2068\u2069',
      r'Escapes: \u{202a}\u{202b}\u{202c}\u{202d}\u{202e}'
          r'\u{2066}\u{2067}\u{2068}\u{2069}',
    );
  });

  test('Gender', () {
    var input =
        '''{gender_of_host, select, female {test} male {test2} other {test3}}''';
    var parsedMessage = MessageParser(input).pluralGenderSelectParse();
    Message expectedMessage = Gender.from('gender_of_host', [
      ['female', 'test'],
      ['male', 'test2'],
      ['other', 'test3'],
    ], null);
    expect(parsedMessage.toCode(), expectedMessage.toCode());
  });

  test('Plural', () {
    var input = '''{num_guests, plural,
      =0 {Anna does not give a party.}
      =1 {Anna invites Bob to her party.}
      =2 {Anna invites Bob and one other person to her party.}
      other {Anna invites Bob and 2 other people to her party.}}''';
    var parsedMessage = MessageParser(input).pluralGenderSelectParse();
    Message expectedMessage = Plural.from('num_guests', [
      ['=0', 'Anna does not give a party.'],
      ['=1', 'Anna invites Bob to her party.'],
      ['=2', 'Anna invites Bob and one other person to her party.'],
      ['other', 'Anna invites Bob and 2 other people to her party.'],
    ], null);
    expect(parsedMessage.toCode(), expectedMessage.toCode());
  });

  test('Select', () {
    var input = '''{selector, select,
      type1 {Anna does not give a party.}
      type2 {Anna invites Bob to her party.}}''';
    var parsedMessage = MessageParser(input).pluralGenderSelectParse();
    Message expectedMessage = Select.from('selector', [
      ['type1', 'Anna does not give a party.'],
      ['type2', 'Anna invites Bob to her party.'],
    ], null);
    expect(parsedMessage.toCode(), expectedMessage.toCode());
  });

  test('Plural with args', () {
    var input = '''{num_guests, plural,
      =0 {{host} does not give a party.}
      =1 {{host} invites {guest} to her party.}
      =2 {{host} invites {guest} and one other person to her party.}
      other {{host} invites {guest} and # other people to her party.}}''';
    var parsedMessage = MessageParser(input).pluralGenderSelectParse();
    Message expectedMessage = Plural.from('num_guests', [
      [
        '=0',
        CompositeMessage([
          VariableSubstitution.named('host'),
          LiteralString(' does not give a party.'),
        ]),
      ],
      [
        '=1',
        CompositeMessage([
          VariableSubstitution.named('host'),
          LiteralString(' invites '),
          VariableSubstitution.named('guest'),
          LiteralString(' to her party.'),
        ]),
      ],
      [
        '=2',
        CompositeMessage([
          VariableSubstitution.named('host'),
          LiteralString(' invites '),
          VariableSubstitution.named('guest'),
          LiteralString(' and one other person to her party.'),
        ]),
      ],
      [
        'other',
        CompositeMessage([
          VariableSubstitution.named('host'),
          LiteralString(' invites '),
          VariableSubstitution.named('guest'),
          LiteralString(' and # other people to her party.'),
        ]),
      ],
    ], null);
    expect(parsedMessage.toCode(), expectedMessage.toCode());
  });

  group("'<' in clauses", () {
    test('Plural with less than', () {
      var input = '{count, plural, =1{<1 hour} other{{count} hours}}';
      var parsedMessage = MessageParser(input).pluralGenderSelectParse();
      expect(parsedMessage, isA<Plural>());
      Message expectedMessage = Plural.from('count', [
        ['=1', '<1 hour'],
        [
          'other',
          CompositeMessage([
            VariableSubstitution.named('count'),
            LiteralString(' hours'),
          ]),
        ],
      ], null);
      expect(parsedMessage.toCode(), expectedMessage.toCode());
    });

    test('Plural with markup around placeholders', () {
      var input =
          '{count, plural, =1{<b>{count}</b> item} '
          'other{<b>{count}</b> items, <a href="{url}">more</a>}}';
      var parsedMessage = MessageParser(input).pluralGenderSelectParse();
      expect(parsedMessage, isA<Plural>());
      Message expectedMessage = Plural.from('count', [
        [
          '=1',
          CompositeMessage([
            LiteralString('<b>'),
            VariableSubstitution.named('count'),
            LiteralString('</b> item'),
          ]),
        ],
        [
          'other',
          CompositeMessage([
            LiteralString('<b>'),
            VariableSubstitution.named('count'),
            LiteralString('</b> items, <a href="'),
            VariableSubstitution.named('url'),
            LiteralString('">more</a>'),
          ]),
        ],
      ], null);
      expect(parsedMessage.toCode(), expectedMessage.toCode());
    });

    test('Select with markup around placeholders', () {
      var input =
          '{choice, select, a{<b>{name}</b>} '
          'other{<a href="{url}">x</a>}}';
      var parsedMessage = MessageParser(input).pluralGenderSelectParse();
      expect(parsedMessage, isA<Select>());
      Message expectedMessage = Select.from('choice', [
        [
          'a',
          CompositeMessage([
            LiteralString('<b>'),
            VariableSubstitution.named('name'),
            LiteralString('</b>'),
          ]),
        ],
        [
          'other',
          CompositeMessage([
            LiteralString('<a href="'),
            VariableSubstitution.named('url'),
            LiteralString('">x</a>'),
          ]),
        ],
      ], null);
      expect(parsedMessage.toCode(), expectedMessage.toCode());
    });

    test('Gender with markup around placeholders', () {
      var input =
          '{gender, select, female{<b>{name}</b> < 1} '
          'male{<a href="{url}">x</a>} other{<i>they</i>}}';
      var parsedMessage = MessageParser(input).pluralGenderSelectParse();
      expect(parsedMessage, isA<Gender>());
      Message expectedMessage = Gender.from('gender', [
        [
          'female',
          CompositeMessage([
            LiteralString('<b>'),
            VariableSubstitution.named('name'),
            LiteralString('</b> < 1'),
          ]),
        ],
        [
          'male',
          CompositeMessage([
            LiteralString('<a href="'),
            VariableSubstitution.named('url'),
            LiteralString('">x</a>'),
          ]),
        ],
        ['other', '<i>they</i>'],
      ], null);
      expect(parsedMessage.toCode(), expectedMessage.toCode());
    });
  });
}

void testEscaping(String actual, String expected) {
  expect(MessageParser(actual).nonIcuMessageParse().toCode(), expected);
}
