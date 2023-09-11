// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:messages/messages_json.dart';
import 'package:messages/package_intl_object.dart';
import 'package:messages_deserializer/messages_deserializer_json.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:test/test.dart';

StringMessage stringMessage = StringMessage('Hello World', id: 'hello_world');

CombinedMessage combinedMessage = CombinedMessage('combined', [
  StringMessage('First '),
  StringMessage('Second'),
]);

PluralMessage pluralMessage = PluralMessage(
  id: 'pluralMes',
  few: StringMessage('few case'),
  many: StringMessage('many case'),
  oneNumber: StringMessage('oneNumber case'),
  twoWord: StringMessage('twoWord case'),
  other: StringMessage('Other case'),
  argIndex: 0,
);

SelectMessage selectMessage = SelectMessage(
  StringMessage('Other'),
  {
    'case1': StringMessage('Case1'),
    'case2': StringMessage('Case2'),
  },
  0,
  'selectMes',
);

GenderMessage genderMessage = GenderMessage(
  female: StringMessage('Female'),
  male: StringMessage('Male'),
  argIndex: 0,
  other: StringMessage('other'),
  id: 'genderMes',
);

void main() {
  test('First serialize, then deserialize again', () {
    for (var writeIds in [true, false]) {
      for (var messages in [
        [stringMessage],
        [
          stringMessage,
          combinedMessage,
          pluralMessage,
          selectMessage,
          genderMessage
        ]
      ]) {
        serializeThenDeserialize<String>(
          messages,
          () => JsonSerializer(writeIds),
          (data) => JsonDeserializer(_extractJsonFromClass(data)),
        );
      }
    }
  });
}

void serializeThenDeserialize<T>(
  List<Message> messages,
  Serializer<T> Function() serializer,
  Deserializer Function(T data) deserializer,
) {
  final hash = 'testhash';
  final locale = 'de_DE';
  final serialized = serializer().serialize(hash, locale, messages);
  final deserialized =
      deserializer(serialized.data).deserialize(OldIntlObject());
  expect(deserialized.hash, hash);
  expect(deserialized.locale, locale);
  if (deserialized is MessageListJson) {
    compareMessages(deserialized.messages, messages);
  }
}

void compareMessages(
  List<Message> deserializedMessages,
  List<Message> originalMessages,
) {
  for (var i = 0;
      i < max(deserializedMessages.length, originalMessages.length);
      i++) {
    final deserialized = deserializedMessages[i];
    final original = originalMessages[i];
    compareMessage(original, deserialized);
  }
}

void compareMessage(Message? original, Message? deserialized) {
  if (original is StringMessage) {
    expect((deserialized as StringMessage).value, original.value);
  } else if (original is PluralMessage) {
    compareMessage((deserialized as PluralMessage).zeroWord, original.zeroWord);
    compareMessage(deserialized.zeroNumber, original.zeroNumber);
    compareMessage(deserialized.oneWord, original.oneWord);
    compareMessage(deserialized.oneNumber, original.oneNumber);
    compareMessage(deserialized.twoWord, original.twoWord);
    compareMessage(deserialized.twoNumber, original.twoNumber);
    compareMessage(deserialized.few, original.few);
    compareMessage(deserialized.many, original.many);
    compareMessage(deserialized.other, original.other);
    expect(deserialized.argIndex, original.argIndex);
  } else if (original is SelectMessage) {
    compareMessage((deserialized as SelectMessage).other, original.other);
    for (var caseKey in original.cases.keys) {
      expect(deserialized.cases.keys, contains(caseKey));
      compareMessage(deserialized.cases[caseKey]!, original.cases[caseKey]!);
    }
    expect(deserialized.argIndex, original.argIndex);
  }
}

String _extractJsonFromClass(String buffer) {
  final jsonStart = buffer.indexOf('r\'');
  final jsonEnd = buffer.lastIndexOf('\';');
  return buffer.substring(jsonStart + 2, jsonEnd);
}
