// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/locale.dart';
import 'package:intl4x/src/locale/platform_locale_name.dart';
import 'package:test/test.dart';

void main() {
  const cases = {
    // Linux and Android: POSIX locale names from `LANG`.
    'en_US': 'en-US',
    'en_US.UTF-8': 'en-US',
    'en_AU.UTF-8': 'en-AU',
    'de_DE@euro': 'de-DE-u-cu-eur',
    'de_DE.ISO-8859-15@euro': 'de-DE-u-cu-eur',
    'sr_RS@latin': 'sr-Latn-RS',
    'sr_RS.UTF-8@latin': 'sr-Latn-RS',
    'uz_UZ.UTF-8@cyrillic': 'uz-Cyrl-UZ',
    'C': 'und',
    'C.UTF-8': 'und',
    'POSIX': 'und',
    '': 'und',
    // Windows: `GetUserDefaultLocaleName`.
    'en-US': 'en-US',
    'sr-Latn-RS': 'sr-Latn-RS',
    'zh-Hant-TW': 'zh-Hant-TW',
    'de-DE_phoneb': 'de-DE-u-co-phonebk',
    'es-ES_tradnl': 'es-ES-u-co-trad',
    'zh-CN_stroke': 'zh-CN-u-co-stroke',
    'zh-TW_pronun': 'zh-TW-u-co-zhuyin',
    'ja-JP_radstr': 'ja-JP-u-co-unihan',
    'hu-HU_tchncl': 'hu-HU',
    // macOS and iOS: preferred language, or a `CFLocale` identifier.
    'zh-Hans-CN': 'zh-Hans-CN',
    'en-DE': 'en-DE',
    'zh_Hant_TW': 'zh-Hant-TW',
    'en-US-u-ca-japanese': 'en-US-u-ca-japanese',
    'en_US@calendar=japanese': 'en-US-u-ca-japanese',
    'en_US@rg=dezzzz': 'en-US-u-rg-dezzzz',
    'th_TH@calendar=buddhist;numbers=thai': 'th-TH-u-ca-buddhist-nu-thai',
    // Keys are sorted, and legacy keyword names and values are mapped.
    'en_GB@hours=h23;calendar=gregorian;measure=imperial':
        'en-GB-u-ca-gregory-hc-h23-ms-uksystem',
    'de_DE@collation=phonebook;currency=EUR': 'de-DE-u-co-phonebk-cu-eur',
    'ar_SA@calendar=islamic-umalqura': 'ar-SA-u-ca-islamic-umalqura',
    'en_US@fw=mon': 'en-US-u-fw-mon',
    'en_US@colnumeric=yes': 'en-US-u-kn-true',
    // Invalid values and unknown keywords are dropped.
    'en_US@timezone=America/New_York': 'en-US',
    'en_US@unknownkeyword=value;calendar=hebrew': 'en-US-u-ca-hebrew',
    'en_US_POSIX': 'en-US-POSIX',
    // Mixed separators, with the underscore before the hyphen.
    'en_US-POSIX': 'en-US-POSIX',
    'sr_Latn-RS': 'sr-Latn-RS',
  };

  group('platformLocaleNameToBcp47', () {
    for (final MapEntry(key: localeName, value: expected) in cases.entries) {
      test('"$localeName" -> "$expected"', () {
        final tag = platformLocaleNameToBcp47(localeName);
        expect(tag, expected);
        // Only check that the tag is accepted, as the canonical form differs
        // between backends: ICU4X turns `en-US-POSIX` into `en-US-posix`,
        // while browsers turn it into `en-US-u-va-posix`.
        expect(() => Locale.parse(tag), returnsNormally);
      });
    }
  });
}
