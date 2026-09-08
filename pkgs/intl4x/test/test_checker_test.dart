// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/src/test_checker.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('isInTest', () {
    test('reflects brittle i18n testing compile-time define', () {
      if (allowBrittleI18nTesting) {
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

    test('formatting output respects brittle i18n testing flag', () {
      final dateTime = DateTime(2026, 3, 26);
      final formatted = DateTimeFormat.day(
        locale: Locale.parse('en-US'),
      ).format(dateTime);
      if (allowBrittleI18nTesting) {
        expect(formatted, '26');
      } else {
        expect(formatted, contains('//en-US'));
      }
    });
  });
}
