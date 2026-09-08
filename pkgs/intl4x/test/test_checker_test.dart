// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/src/test_checker.dart';
import 'package:test/test.dart';

import 'utils.dart';

const bool _allowBrittleFormatting = bool.fromEnvironment(
  'intl4x.brittle_test_formatting',
  defaultValue: false,
);

void main() {
  group('isInTest', () {
    test('reflects brittle formatting compile-time define', () {
      if (_allowBrittleFormatting) {
        expect(isInTest, isFalse);
      } else {
        expect(isInTest, isTrue);
      }
    });

    test('withFormatting zone override disables isInTest', () {
      withFormatting(() {
        expect(isInTest, isFalse);
      });
    });

    test('formatting output respects brittle formatting flag', () {
      final dateTime = DateTime(2026, 3, 26);
      final formatted = DateTimeFormat.day(
        locale: Locale.parse('en-US'),
      ).format(dateTime);
      if (_allowBrittleFormatting) {
        expect(formatted, '26');
      } else {
        expect(formatted, contains('//en-US'));
      }
    });
  });
}
