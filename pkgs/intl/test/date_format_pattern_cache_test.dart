// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Tests that instances which share a parsed pattern do not affect each other.
library;

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  final date = DateTime(2012, 1, 27, 20, 58, 59);

  setUpAll(() => initializeDateFormatting());

  test('Same pattern in different locales uses the symbols of each', () {
    expect(DateFormat('d MMMM y', 'en_US').format(date), '27 January 2012');
    expect(DateFormat('d MMMM y', 'de').format(date), '27 Januar 2012');
    expect(DateFormat('d MMMM y', 'en_US').format(date), '27 January 2012');
  });

  test('addPattern does not change other instances', () {
    final first = DateFormat('HH:mm', 'en_US');
    final second = DateFormat('HH:mm', 'en_US');
    expect(first.format(date), '20:58');
    expect(second.format(date), '20:58');
    first.addPattern('ss', ':');
    expect(first.format(date), '20:58:59');
    expect(second.format(date), '20:58');
    expect(DateFormat('HH:mm', 'en_US').format(date), '20:58');
  });

  test('Quoted text', () {
    final format = DateFormat("h 'o''clock' a", 'en_US');
    expect(format.format(date), "8 o'clock PM");
    expect(DateFormat("h 'o''clock' a", 'en_US').format(date), "8 o'clock PM");
    expect(format.parse("8 o'clock PM"), DateTime(1970, 1, 1, 20));
  });

  test('More patterns than the cache holds', () {
    for (var i = 0; i < 600; i++) {
      expect(DateFormat("'x$i' HH", 'en_US').format(date), 'x$i 20');
    }
    // x0 was removed from the cache. x599 is still in it.
    expect(DateFormat("'x0' HH", 'en_US').format(date), 'x0 20');
    expect(DateFormat("'x599' HH", 'en_US').format(date), 'x599 20');
    expect(DateFormat("'x0' HH", 'en_US').format(date), 'x0 20');
  });
}
