// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';
import 'package:test/test.dart';

void main() {
  group('Locale', () {
    test('parse and toLanguageTag', () {
      final locale = Locale.parse('en-US');
      expect(locale.toLanguageTag(), 'en-US');
      expect(locale.toString(), 'en-US');
    });

    test('toLanguageTag', () {
      final locale = Locale.parse('de-DE');
      expect(locale.toLanguageTag(), 'de-DE');
    });

    test('withCalendar', () {
      final locale = Locale.parse('en-US').withCalendar(Calendar.buddhist);
      expect(locale.toLanguageTag(), 'en-US-u-ca-buddhist');
    });

    test('withNumberingSystem', () {
      final locale = Locale.parse(
        'en-US',
      ).withNumberingSystem(NumberingSystem.arabic);
      expect(locale.toLanguageTag(), 'en-US-u-nu-arab');
    });

    test('withClockStyle', () {
      final locale = Locale.parse(
        'en-US',
      ).withClockStyle(ClockStyle.oneToTwelve);
      expect(locale.toLanguageTag(), 'en-US-u-hc-h12');
    });
  });
}
