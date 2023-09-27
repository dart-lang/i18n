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
  test('Serialize with IDs', () {
    final messages = [
      stringMessage,
      combinedMessage,
      pluralMessage,
      selectMessage,
      genderMessage
    ];
    final serialized =
        JsonSerializer(true).serialize('hash', 'locale', messages);
    final deserialize =
        JsonDeserializer(serialized.data).deserialize(OldIntlObject());
    expect(
      deserialize.messages.map((e) => e.id),
      orderedEquals(messages.map((e) => e.id)),
    );
  });

  test('Serialize partially', () {
    final messages = [
      stringMessage,
      combinedMessage,
      pluralMessage,
      selectMessage,
      genderMessage
    ];
    final serialized =
        JsonSerializer(true).serialize('hash', 'locale', messages, [1, 4]);
    final deserialize =
        JsonDeserializer(serialized.data).deserialize(OldIntlObject());
    expect(
      deserialize.messages.map((e) => e.id),
      orderedEquals([messages[1], messages[4]].map((e) => e.id)),
    );
  });

  test('First serialize, then deserialize again', () {
    final messageTypes = [
      [stringMessage],
      [
        stringMessage,
        combinedMessage,
        pluralMessage,
        selectMessage,
        genderMessage
      ]
    ];
    final params = [
      for (var writeId in [true, false])
        for (var messages in messageTypes) (writeId, messages)
    ];
    for (final (writeId, messages) in params) {
      serializeThenDeserialize<String>(
        messages,
        JsonSerializer(writeId),
        JsonDeserializer.new,
      );
    }
  });
}

void serializeThenDeserialize<T>(
  List<Message> messages,
  Serializer<T> serializer,
  Deserializer Function(T data) deserializerBuilder,
) {
  final hash = 'testhash';
  final locale = 'de_DE';
  final serialized = serializer.serialize(hash, locale, messages);

  final deserializer = deserializerBuilder(serialized.data);
  final deserialized = deserializer.deserialize(OldIntlObject());

  expect(deserialized.preamble.hash, hash);
  expect(deserialized.preamble.locale, locale);
  if (deserialized is MessageListJson) {
    compareMessages(deserialized.messages, messages);
  }
}

void compareMessages(
  List<Message> deserializedMessages,
  List<Message> originalMessages,
) {
  final maxLength = max(deserializedMessages.length, originalMessages.length);
  for (var i = 0; i < maxLength; i++) {
    compareMessage(originalMessages[i], deserializedMessages[i]);
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
