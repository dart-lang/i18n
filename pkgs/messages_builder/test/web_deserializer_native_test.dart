// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:messages/message_format.dart';
import 'package:messages_builder/arb_parser.dart';
import 'package:messages_builder/message_with_metadata.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:test/test.dart';

import 'testdata/testarb.arb.dart';

void main() {
  test('generateMessageFile from Object json', () {
    var message = StringMessage('Hello World');
    var message1 = MessageWithMetadata(message, [], 'helloWorld');
    var messageList = <MessageWithMetadata>[message1];
    var buffer = WebSerializer()
        .serialize(
          '',
          '',
          messageList.map((e) => e.message).toList(),
          useWrapper: false,
        )
        .data;
    var messages = WebDeserializer(buffer).deserialize().messages;
    expect((messages[0] as StringMessage).value, message.value);
  });

  test('generateMessageFile from simple arb JSON', () {
    var arb = <String, dynamic>{'@@locale': 'en', 'helloWorld': 'Hello World'};
    var parsed = ArbParser().parseMessageFile(arb);
    var buffer = WebSerializer()
        .serialize(
          '',
          '',
          parsed.messages.map((e) => e.message).toList(),
          useWrapper: false,
        )
        .data;
    var messages = WebDeserializer(buffer).deserialize().messages;
    expect((messages[0] as StringMessage).value, 'Hello World');
  });

  test('generateMessageFile from complex arb JSON', () {
    Map<String, dynamic> arb = jsonDecode(arbFile);
    var parsed = ArbParser().parseMessageFile(arb);
    var buffer = WebSerializer()
        .serialize(
          '',
          '',
          parsed.messages.map((e) => e.message).toList(),
          useWrapper: false,
        )
        .data;
    var messages = WebDeserializer(buffer).deserialize().messages;
    expect(messages[2].generateString(['female', 'b']), 'test One new message');
  });
}
