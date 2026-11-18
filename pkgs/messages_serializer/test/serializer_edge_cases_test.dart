// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart' as old_intl;
import 'package:messages/messages_json.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:test/test.dart';

Message intlPluralSelector(
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
  group('JsonSerializer Edge Cases', () {
    test('serializes empty message list', () {
      final serializer = JsonSerializer();
      final result = serializer.serialize('hash123', 'en', []);
      final deserializer = JsonDeserializer(result.data);
      final deserialized = deserializer.deserialize();

      expect(deserialized.preamble.hash, 'hash123');
      expect(deserialized.preamble.locale, 'en');
      expect(deserialized.messages, isEmpty);
    });

    test('serializes empty string message', () {
      final messages = [StringMessage('')];
      final serializer = JsonSerializer();
      final result = serializer.serialize('hash', 'fr', messages);
      final deserialized = JsonDeserializer(result.data).deserialize();

      expect(deserialized.messages.length, 1);
      expect((deserialized.messages[0] as StringMessage).value, '');
    });

    test('serializes nested combined message with select and plural', () {
      final nestedMsg = CombinedMessage([
        StringMessage('Prefix: '),
        SelectMessage(StringMessage('default item'), {
          'special': PluralMessage(
            numberCases: {1: StringMessage('one special item')},
            other: StringMessage('many special items'),
            argIndex: 1,
          ),
        }, 0),
      ]);

      final serializer = JsonSerializer();
      final result = serializer.serialize('hash_nested', 'de', [nestedMsg]);
      final data = JsonDeserializer(result.data).deserialize();
      final deserialized = MessageListJson(data, intlPluralSelector);

      expect(deserialized.data.messages.length, 1);
      final output = deserialized.generateStringAtIndex(0, ['special', 1]);
      expect(output, 'Prefix: one special item');
    });
  });
}
