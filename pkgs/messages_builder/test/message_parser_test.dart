// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/messages_json.dart';
import 'package:messages_builder/message_parser/message_parser.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:test/test.dart';

Message _pluralSelector(
  num howMany,
  String locale, {
  Map<int, Message>? numberCases,
  Map<int, Message>? wordCases,
  Message? few,
  Message? many,
  required Message other,
}) =>
    numberCases?[howMany] ?? other;

/// Parses [text], and renders it with [args] after a serialization roundtrip.
String _render(String text, List<Object> args) {
  final message = MessageParser.parse('test', text, 'test').message;
  final data = JsonSerializer().serialize('', 'en', [message]).data;
  return MessageListJson.fromString(data, _pluralSelector)
      .generateStringAtIndex(0, args);
}

void main() {
  test('placeholders before a plural are kept', () {
    const text =
        '{name} has {count, plural, =1{one message} other{{count} messages}}';
    expect(_render(text, ['Ada', 1]), 'Ada has one message');
    expect(_render(text, ['Ada', 3]), 'Ada has 3 messages');
  });

  test('placeholders after a select are kept', () {
    const text = '{gender, select, female{She} other{They}} invited {name}.';
    expect(_render(text, ['female', 'Ada']), 'She invited Ada.');
  });

  test('messages without plurals or selects are unchanged', () {
    expect(_render('Hello {first} {last}!', ['Ada', 'Lovelace']),
        'Hello Ada Lovelace!');
    expect(_render('{first}{last}', ['Ada', 'Lovelace']), 'AdaLovelace');
    expect(_render('Hello', []), 'Hello');
  });
}
