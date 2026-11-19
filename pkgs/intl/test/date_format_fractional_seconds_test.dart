// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Tests that fractional seconds are parsed as a fraction of a second, padded
/// on the right like they are when formatting.
/// https://github.com/dart-lang/i18n/issues/382
library;

import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  int millis(String pattern, String input) =>
      DateFormat(pattern).parseUtc(input).millisecond;

  test('one digit is tenths of a second', () {
    expect(millis('HH:mm:ss.S', '12:15:46.7'), 700);
  });

  test('two digits are hundredths of a second', () {
    expect(millis('HH:mm:ss.SS', '12:15:46.75'), 750);
  });

  test('three digits are milliseconds', () {
    expect(millis('HH:mm:ss.SSS', '12:15:46.007'), 7);
    expect(millis('HH:mm:ss.SSS', '12:15:46.283'), 283);
  });

  test('digits past milliseconds are dropped', () {
    expect(millis('HH:mm:ss.SSSSSS', '12:15:46.283420'), 283);
    expect(
      millis(
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'",
        '2015-04-24T20:52:26.283420393Z',
      ),
      283,
    );
  });

  test('round-trips with formatting at any width', () {
    final date = DateTime.utc(2015, 4, 24, 20, 52, 26, 283);
    for (final pattern in ['ss.S', 'ss.SSS', 'ss.SSSSSS']) {
      final format = DateFormat(pattern);
      expect(
        format.parseUtc(format.format(date)).millisecond,
        283,
        reason: pattern,
      );
    }
  });
}
