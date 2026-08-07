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
      expect(enUS.languageCode, 'en');
      expect(enUS.region, 'US');
      expect(enUS.countryCode, 'US');
      expect(enUS.script, isNull);
      expect(enUS.scriptCode, isNull);

      final zhHantTW = Locale.parse('zh-Hant-TW');
      expect(zhHantTW.language, 'zh');
      expect(zhHantTW.languageCode, 'zh');
      expect(zhHantTW.script, 'Hant');
      expect(zhHantTW.scriptCode, 'Hant');
      expect(zhHantTW.region, 'TW');
      expect(zhHantTW.countryCode, 'TW');

      final srLatn = Locale.parse('sr-Latn');
      expect(srLatn.language, 'sr');
      expect(srLatn.languageCode, 'sr');
      expect(srLatn.script, 'Latn');
      expect(srLatn.scriptCode, 'Latn');
      expect(srLatn.region, isNull);
      expect(srLatn.countryCode, isNull);

      final de = Locale.parse('de');
      expect(de.language, 'de');
      expect(de.languageCode, 'de');
      expect(de.region, isNull);
      expect(de.countryCode, isNull);
      expect(de.script, isNull);
      expect(de.scriptCode, isNull);
    });

    test('tryParse', () {
      final valid = Locale.tryParse('en-US');
      expect(valid, isNotNull);
      expect(valid!.toLanguageTag(), 'en-US');

      final invalid = Locale.tryParse('invalid!!locale??');
      expect(invalid, isNull);
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
