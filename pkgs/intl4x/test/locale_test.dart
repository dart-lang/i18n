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

    test('subtag getters (language, region, script)', () {
      final enUS = Locale.parse('en-US');
      expect(enUS.language, 'en');
      expect(enUS.region, 'US');
      expect(enUS.script, isNull);

      final zhHantTW = Locale.parse('zh-Hant-TW');
      expect(zhHantTW.language, 'zh');
      expect(zhHantTW.script, 'Hant');
      expect(zhHantTW.region, 'TW');

      final srLatn = Locale.parse('sr-Latn');
      expect(srLatn.language, 'sr');
      expect(srLatn.script, 'Latn');
      expect(srLatn.region, isNull);

      final de = Locale.parse('de');
      expect(de.language, 'de');
      expect(de.region, isNull);
      expect(de.script, isNull);
    });

    test('equality and hashCode', () {
      final a1 = Locale.parse('en-US');
      final a2 = Locale.parse('en-US');
      final b = Locale.parse('en-GB');

      expect(a1, equals(a2));
      expect(a1.hashCode, equals(a2.hashCode));
      expect(a1, isNot(equals(b)));
    });
  });
}
