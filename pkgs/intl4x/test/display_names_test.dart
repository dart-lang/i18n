// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/display_names.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  testWithFormatting('basic', () {
    expect(
      DisplayNames(
        locale: Locale.parse('en-US'),
      ).ofLanguage(Locale.parse('de-DE')),
      'German (Germany)',
    );
  });

  group('language', () {
    String languageOf(Locale locale, Locale language) =>
        DisplayNames(locale: locale, style: Style.long).ofLanguage(language);
    final en = Locale.parse('en');
    final fr = Locale.parse('fr');
    final de = Locale.parse('de');
    final zh = Locale.parse('zh-Hant');
    testWithFormatting('French', () {
      expect(languageOf(en, fr), 'French');
    });
    testWithFormatting('German', () {
      expect(languageOf(en, de), 'German');
    });
    testWithFormatting('French Canada', () {
      expect(languageOf(en, Locale.parse('fr-CA')), 'Canadian French');
    });
    testWithFormatting('Trad Chinese', () {
      expect(languageOf(en, zh), 'Traditional Mandarin Chinese');
    }, tags: ['ecmaUnsupported']);
    testWithFormatting('US English', () {
      expect(languageOf(en, Locale.parse('en-US')), 'American English');
    });
    testWithFormatting('Taiwan Chinese', () {
      expect(
        languageOf(en, Locale.parse('zh-TW')),
        'Mandarin Chinese (Taiwan)',
      );
    }, tags: ['ecmaUnsupported']);
    testWithFormatting('French Chinese', () {
      expect(languageOf(zh, fr), '法文');
    });
    testWithFormatting('Chinese', () {
      expect(languageOf(zh, Locale.parse('zh')), '中文');
    });
    testWithFormatting('German chinese', () {
      expect(languageOf(zh, de), '德文');
    });
  });

  testWithFormatting('language with languageDisplay', () {
    String languageWith(LanguageDisplay display) => DisplayNames(
      locale: Locale.parse('en'),
      languageDisplay: display,
    ).ofLanguage(Locale.parse('en-GB'));

    expect(languageWith(LanguageDisplay.dialect), 'British English');
    expect(languageWith(LanguageDisplay.standard), 'English (United Kingdom)');
  });

  testWithFormatting('region', () {
    String regionNames(Locale locale, String region) =>
        DisplayNames(locale: locale).ofRegion(region);

    final en = Locale.parse('en');
    expect(regionNames(en, '419'), 'Latin America');
    expect(regionNames(en, 'BZ'), 'Belize');
    expect(regionNames(en, 'US'), 'United States');
    expect(regionNames(en, 'BA'), 'Bosnia & Herzegovina');
    expect(regionNames(en, 'MM'), 'Myanmar (Burma)');

    final zh = Locale.parse('zh-Hant');
    expect(regionNames(zh, '419'), '拉丁美洲');
    expect(regionNames(zh, 'BZ'), '貝里斯');
    expect(regionNames(zh, 'US'), '美國');
    expect(regionNames(zh, 'BA'), '波士尼亞與赫塞哥維納');
    expect(regionNames(zh, 'MM'), '緬甸');

    final es = Locale.parse('es-419');
    expect(regionNames(es, 'DE'), 'Alemania');
  });
}
