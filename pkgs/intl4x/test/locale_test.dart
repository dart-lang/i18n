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

    test('maximize', () {
      final en = Locale.parse('en');
      final enMax = en.maximize();
      expect(enMax.toLanguageTag(), 'en-Latn-US');
      expect(enMax.language, 'en');
      expect(enMax.script, 'Latn');
      expect(enMax.region, 'US');
      // Original locale is not mutated
      expect(en.toLanguageTag(), 'en');

      final zh = Locale.parse('zh');
      expect(zh.maximize().toLanguageTag(), 'zh-Hans-CN');

      final sr = Locale.parse('sr');
      expect(sr.maximize().toLanguageTag(), 'sr-Cyrl-RS');
    });

    test('minimize', () {
      final enLatnUS = Locale.parse('en-Latn-US');
      final enMin = enLatnUS.minimize();
      expect(enMin.toLanguageTag(), 'en');
      expect(enMin.language, 'en');
      expect(enMin.script, isNull);
      expect(enMin.region, isNull);
      // Original locale is not mutated
      expect(enLatnUS.toLanguageTag(), 'en-Latn-US');

      final zhHansCN = Locale.parse('zh-Hans-CN');
      expect(zhHansCN.minimize().toLanguageTag(), 'zh');

      final zhHantTW = Locale.parse('zh-Hant-TW');
      expect(zhHantTW.minimize().toLanguageTag(), 'zh-TW');

      final withExtension = Locale.parse('en-Latn-US-u-ca-buddhist');
      expect(withExtension.minimize().toLanguageTag(), 'en-u-ca-buddhist');
    });

    test('canonicalize', () {
      final enUS = Locale.parse('en-US');
      expect(enUS.canonicalize().toLanguageTag(), 'en-US');

      final indonesian = Locale.parse('in');
      expect(indonesian.canonicalize().toLanguageTag(), 'id');

      final hebrew = Locale.parse('iw');
      expect(hebrew.canonicalize().toLanguageTag(), 'he');

      final moldavian = Locale.parse('mo');
      expect(moldavian.canonicalize().toLanguageTag(), 'ro');

      final withExtension = Locale.parse('en-US-u-ca-buddhist');
      expect(
        withExtension.canonicalize().toLanguageTag(),
        'en-US-u-ca-buddhist',
      );
    });
  });
}
