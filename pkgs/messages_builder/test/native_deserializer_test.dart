@TestOn('vm')
import 'dart:convert';
import 'dart:io';

import 'package:messages/message_format.dart';
import 'package:messages_builder/arb_parser.dart';
import 'package:messages_builder/message_with_metadata.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:test/test.dart';

import 'testdata/testarb.arb.dart';

void main() {
  test('generateMessageFile from Object', () {
    Message message = StringMessage('Hello World');
    var message1 = MessageWithMetadata(message, [], 'helloWorld');
    var messageList = <MessageWithMetadata>[message1];
    var buffer = NativeSerializer()
        .serialize('', '', messageList.map((e) => e.message).toList())
        .data;
    var stringMessage = NativeDeserializer(buffer).deserialize().messages.first
        as StringMessage;
    expect(stringMessage.value, 'Hello World');
  });

  test('generateMessageFile from simple arb', () {
    var arb = <String, dynamic>{'@@locale': 'en', 'helloWorld': 'Hello World'};
    var parsed = ArbParser().parseMessageFile(arb);
    var buffer = NativeSerializer()
        .serialize('', '', parsed.messages.map((e) => e.message).toList())
        .data;
    var stringMessage = NativeDeserializer(buffer).deserialize().messages.first
        as StringMessage;
    expect(stringMessage.value, 'Hello World');
  });
  test('generateMessageFile from complex arb', () {
    Map<String, dynamic> arb = jsonDecode(arbFile);
    var parsed = ArbParser().parseMessageFile(arb);
    var buffer = NativeSerializer()
        .serialize('', '', parsed.messages.map((e) => e.message).toList())
        .data;
    var list = NativeDeserializer(buffer).deserialize().messages;
    expect(list.last.generateString(['female', 'b'], locale: 'en'),
        'test One new message');
  });

  test('generateMessageFile from complex arb 2', () {
    for (var locale in ['de', 'hu', 'sk']) {
      var arbFile = File('test/testdata/manymessages_$locale.arb');
      Map<String, dynamic> arb = jsonDecode(arbFile.readAsStringSync());
      var parsed = ArbParser().parseMessageFile(arb);
      NativeSerializer()
          .serialize('', '', parsed.messages.map((e) => e.message).toList())
          .data;
    }
  });
}

String extractJsonFromClass(String buffer) {
  var jsonStart = buffer.indexOf('r\'');
  var jsonEnd = buffer.lastIndexOf('\';');
  return buffer.substring(jsonStart + 2, jsonEnd);
}
