// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart' as old_intl;
import 'package:messages/messages_json.dart';
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
  test('JSON MessageList', () {
    final MessageList messageList = MessageListJson(
      JsonPreamble.build(
        serializationVersion: serializationVersion,
        locale: 'en_US',
        hash: 'hash',
        hasIds: false,
      ),
      [
        StringMessage('Hello World'),
        SelectMessage(
          StringMessage('Some case'),
          {
            'case1': StringMessage(
              'Case ',
              argPositions: [(stringIndex: 5, argIndex: 0)],
            ),
            'case2': StringMessage('Case 2'),
            'case3': PluralMessage(
              other: StringMessage('other nested'),
              numberCases: {
                2: StringMessage(': ', argPositions: [
                  (stringIndex: 0, argIndex: 0),
                  (stringIndex: 2, argIndex: 1),
                ])
              },
              argIndex: 1,
            ),
          },
          0,
        )
      ],
      intlPluralSelector,
      null,
    );

    expect(messageList.preamble.hasIds, false);
    expect(messageList.preamble.locale, 'en_US');
    expect(messageList.generateStringAtIndex(0, []), 'Hello World');
    expect(messageList.generateStringAtIndex(1, ['case1']), 'Case case1');
    expect(messageList.generateStringAtIndex(1, ['case2']), 'Case 2');
    expect(messageList.generateStringAtIndex(1, ['case3', 2]), 'case3: 2');
    expect(messageList.generateStringAtIndex(1, ['case4']), 'Some case');
  });
}
