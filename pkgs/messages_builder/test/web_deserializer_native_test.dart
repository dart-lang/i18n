// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:messages/messages.dart';
import 'package:messages/package_intl_object.dart';
import 'package:messages_builder/arb_parser.dart';
import 'package:messages_builder/message_with_metadata.dart';
import 'package:messages_deserializer/messages_deserializer_json.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:test/test.dart';

import 'testdata/testarb.arb.dart';

void main() {
  test('generateMessageFile from Object json', () {
    final message = StringMessage('Hello World');
    final message1 = MessageWithMetadata(message, [], 'helloWorld');
    final messageList = <MessageWithMetadata>[message1];
    final buffer = JsonSerializer()
        .serialize('', '', messageList.map((e) => e.message).toList())
        .data;
    final messages =
        JsonDeserializer(buffer).deserialize(OldIntlObject()).messages;
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
        JsonDeserializer(buffer).deserialize(OldIntlObject()).messages;
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
        JsonDeserializer(buffer).deserialize(OldIntlObject()).messages;
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
        JsonDeserializer(buffer).deserialize(OldIntlObject()).messages;
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
        JsonDeserializer(buffer).deserialize(OldIntlObject()).messages;
    expect(
        messages[2].generateString(
          ['female', 'b'],
          intl: OldIntlObject(),
        ),
        'test One new message');
  });
}
