// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/messages.dart';
import 'package:test/test.dart';

Message _otherSelector(
  num howMany,
  String locale, {
  Map<int, Message>? numberCases,
  Map<int, Message>? wordCases,
  Message? few,
  Message? many,
  required Message other,
}) =>
    other;

void main() {
  // 'About {website}!'
  final message = StringMessage(
    'About !',
    argPositions: [(stringIndex: 6, argIndex: 0)],
  );

  test('inserts arguments', () {
    expect(
      message.generateString(['dart.dev'], pluralSelector: _otherSelector),
      'About dart.dev!',
    );
  });

  test('cleaner is applied to the text, but not to arguments', () {
    expect(
      message.generateString(
        ['dart.dev'],
        pluralSelector: _otherSelector,
        cleaner: (text) => text.toUpperCase(),
      ),
      'ABOUT dart.dev!',
    );
  });

  test('cleaner may change the length of the text', () {
    expect(
      message.generateString(
        ['dart.dev'],
        pluralSelector: _otherSelector,
        cleaner: (text) => text.isEmpty ? text : '[$text~~]',
      ),
      '[About ~~]dart.dev[!~~]',
    );
  });

  test('cleaner with adjacent arguments', () {
    // '{first}{last}'
    final adjacent = StringMessage(
      '',
      argPositions: [
        (stringIndex: 0, argIndex: 0),
        (stringIndex: 0, argIndex: 1),
      ],
    );
    expect(
      adjacent.generateString(
        ['Ada', 'Lovelace'],
        pluralSelector: _otherSelector,
        cleaner: (text) => text.toUpperCase(),
      ),
      'AdaLovelace',
    );
  });

  test('cleaner without arguments', () {
    expect(
      StringMessage('About').generateString(
        [],
        pluralSelector: _otherSelector,
        cleaner: (text) => text.toUpperCase(),
      ),
      'ABOUT',
    );
  });
}
