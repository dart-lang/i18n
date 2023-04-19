@TestOn('browser')
import 'dart:convert';

import 'package:messages/message_format.dart';
import 'package:messages/message_json.dart';
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
        .serialize('', '', messageList.map((e) => e.message).toList())
        .data;
    buffer = extractJsonFromClass(buffer);
    var messages = MessageListJson.fromString(buffer);
    expect(messages.generateStringAtIndex(0, []), 'Hello World');
  });

  test('generateMessageFile from simple arb JSON', () {
    var arb = <String, dynamic>{'@@locale': 'en', 'helloWorld': 'Hello World'};
    var parsed = ArbParser().parseMessageFile(arb);
    var buffer = WebSerializer()
        .serialize('', '', parsed.messages.map((e) => e.message).toList())
        .data;
    buffer = extractJsonFromClass(buffer);
    var messageList = MessageListJson.fromString(buffer);
    expect(messageList.generateStringAtIndex(0, []), 'Hello World');
  });

  test('generateMessageFile from complex arb JSON', () {
    Map<String, dynamic> arb = jsonDecode(arbFile);
    var parsed = ArbParser().parseMessageFile(arb);
    var buffer = WebSerializer()
        .serialize('', '', parsed.messages.map((e) => e.message).toList())
        .data;
    buffer = extractJsonFromClass(buffer);
    var messageListJson = MessageListJson.fromString(buffer);
    expect(messageListJson.generateStringAtIndex(2, ['female', 'b']),
        'test One new message');
  });
}

String extractJsonFromClass(String buffer) {
  var jsonStart = buffer.indexOf('r\'');
  var jsonEnd = buffer.lastIndexOf('\';');
  return buffer.substring(jsonStart + 2, jsonEnd);
}
