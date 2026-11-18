// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'package:intl/intl.dart' as old_intl;
import 'package:messages/messages_json.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:messages_shrinker/messages_shrinker.dart';
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
  test('shrinkJson keeps specified message indices and reduces size', () {
    final messages = List.generate(
      10,
      (i) =>
          StringMessage('This is a longer message text for message number $i'),
    );
    final fullJson = JsonSerializer().serialize('hash', 'en', messages).data;
    final shrunkJson = MessageShrinker().shrinkJson(fullJson, [0, 2]);

    final data = JsonDeserializer(shrunkJson).deserialize();
    final deserialized = MessageListJson(data, intlPluralSelector);
    expect(
      deserialized.generateStringAtIndex(0, []),
      'This is a longer message text for message number 0',
    );
    expect(
      deserialized.generateStringAtIndex(2, []),
      'This is a longer message text for message number 2',
    );
    expect(shrunkJson.length, lessThan(fullJson.length));
  });
}
