// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/messages.dart';
import 'package:messages_builder/message_parser/message_parser.dart';
import 'package:test/test.dart';

void main() {
  group('MessageParser', () {
    test('parses simple text message', () {
      final parsed = MessageParser.parse('debug', 'Hello world', 'hello');
      expect(parsed.name, 'hello');
      expect(parsed.placeholders, isEmpty);
      expect((parsed.message as StringMessage).value, 'Hello world');
    });

    test('parses message with placeholders', () {
      final parsed = MessageParser.parse(
        'debug',
        'Hello {name}, welcome to {place}!',
        'welcome',
      );
      expect(parsed.name, 'welcome');
      expect(parsed.placeholders.map((p) => p.name), ['name', 'place']);
    });

    test('parses plural message with number and word cases', () {
      final parsed = MessageParser.parse(
        'debug',
        '{count, plural, =0{no items} =1{one item} =2{two items} '
            'few{few items} many{many items} other{other items}}',
        'itemsCount',
      );
      expect(parsed.name, 'itemsCount');
      final plural = parsed.message as PluralMessage;
      expect(plural.argIndex, 0);
      expect((plural.numberCases[0] as StringMessage).value, 'no items');
      expect((plural.numberCases[1] as StringMessage).value, 'one item');
      expect((plural.numberCases[2] as StringMessage).value, 'two items');
      expect((plural.few as StringMessage).value, 'few items');
      expect((plural.many as StringMessage).value, 'many items');
      expect((plural.other as StringMessage).value, 'other items');
    });

    test('parses select message with cases', () {
      final parsed = MessageParser.parse(
        'debug',
        '{gender, select, female{she} male{he} other{they}}',
        'pronoun',
      );
      expect(parsed.name, 'pronoun');
      final select = parsed.message as SelectMessage;
      expect(select.argIndex, 0);
      expect((select.cases['female'] as StringMessage).value, 'she');
      expect((select.cases['male'] as StringMessage).value, 'he');
      expect((select.other as StringMessage).value, 'they');
    });
  });
}
