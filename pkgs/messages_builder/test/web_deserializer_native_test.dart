// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:intl/intl.dart' as old_intl;
import 'package:messages/messages_json.dart';
import 'package:messages_builder/arb_parser.dart';
import 'package:messages_builder/message_with_metadata.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:test/test.dart';

import 'testarb.arb.dart';

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
  test('generateMessageFile from Object json', () {
    final message = StringMessage('Hello World');
    final message1 = MessageWithMetadata(message, [], 'helloWorld');
    final messageList = <MessageWithMetadata>[message1];
    final buffer = JsonSerializer()
        .serialize('', '', messageList.map((e) => e.message).toList())
        .data;
    final messages =
        JsonDeserializer(buffer).deserialize(intlPluralSelector).messages;
    expect((messages[0] as StringMessage).value, message.value);
  });

  test('generateMessageFile from simple arb JSON', () {
    final arb = <String, dynamic>{
      '@@locale': 'en',
      'helloWorld': 'Hello World'
    };
    final parsed = ArbParser().parseMessageFile(arb);
    final buffer = JsonSerializer()
        .serialize('', '', parsed.messages.map((e) => e.message).toList())
        .data;
    final messages =
        JsonDeserializer(buffer).deserialize(intlPluralSelector).messages;
    expect((messages[0] as StringMessage).value, 'Hello World');
  });
  test('generateMessageFile from simple arb JSON with placeholder', () {
    final arb = <String, dynamic>{
      '@@locale': 'en',
      'helloWorld': 'Hello {name}'
    };
    final parsed = ArbParser().parseMessageFile(arb);
    final buffer = JsonSerializer()
        .serialize('', '', parsed.messages.map((e) => e.message).toList())
        .data;
    final messages =
        JsonDeserializer(buffer).deserialize(intlPluralSelector).messages;
    expect((messages[0] as StringMessage).value, 'Hello ');
    expect(
      (messages[0] as StringMessage).argPositions,
      [(argIndex: 0, stringIndex: 6)],
    );
  });
  test('generateMessageFile from simple arb JSON with only placeholders', () {
    final arb = <String, dynamic>{
      '@@locale': 'en',
      'helloWorld': '{greeting}{space}{name}'
    };
    final parsed = ArbParser().parseMessageFile(arb);
    final buffer = JsonSerializer()
        .serialize('', '', parsed.messages.map((e) => e.message).toList())
        .data;
    final messages =
        JsonDeserializer(buffer).deserialize(intlPluralSelector).messages;
    expect((messages[0] as StringMessage).value, '');
    expect(
      (messages[0] as StringMessage).argPositions,
      [
        (argIndex: 0, stringIndex: 0),
        (argIndex: 1, stringIndex: 0),
        (argIndex: 2, stringIndex: 0),
      ],
    );
  });

  test('generateMessageFile from complex arb JSON', () {
    final arb = jsonDecode(arbFile) as Map<String, dynamic>;
    final parsed = ArbParser().parseMessageFile(arb);
    final buffer = JsonSerializer()
        .serialize('', '', parsed.messages.map((e) => e.message).toList())
        .data;
    final messages =
        JsonDeserializer(buffer).deserialize(intlPluralSelector).messages;
    expect(
        messages[2].generateString(
          ['female', 'b'],
          pluralSelector: intlPluralSelector,
        ),
        'test One new message');
  });

  test('Key with spaces is not ok', () {
    final key = 'key with spaces';
    final message = ArbParser().parseMessage({key: 'Some message'}, key, 'id');
    expect(message.nameIsDartConform, false);
  });

  test('Key without spaces is ok', () {
    final key = 'key_without_spaces';
    final message = ArbParser().parseMessage({key: 'Some message'}, key, 'id');
    expect(message.nameIsDartConform, true);
  });
}
