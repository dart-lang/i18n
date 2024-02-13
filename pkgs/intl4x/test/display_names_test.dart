// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/display_names.dart';
import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  testWithFormatting('basic', () {
    expect(
        Intl(locale: const Locale(language: 'en', region: 'US'))
            .displayNames()
            .ofLanguage(const Locale(language: 'de', region: 'DE')),
        'German (Germany)');
  });

  testWithFormatting('language', () {
    String languageOf(Locale locale, Locale language) => Intl(locale: locale)
        .displayNames(const DisplayNamesOptions(style: Style.long))
        .ofLanguage(language);

    const en = Locale(language: 'en');
    const fr = Locale(language: 'fr');
    const de = Locale(language: 'de');
    const zh = Locale(language: 'zh', script: 'Hant');
    expect(languageOf(en, fr), 'French');
    expect(languageOf(en, de), 'German');
    expect(languageOf(en, const Locale(language: 'fr', region: 'CA')),
        'Canadian French');
    //TODO(mosuem): Skip as ECMA seems to have a bug here.
    // expect(languageOf(en, zh), 'Traditional Chinese');
    expect(languageOf(en, const Locale(language: 'en', region: 'US')),
        'American English');
    //TODO(mosuem): Skip as ECMA seems to have a bug here.
    // expect(languageOf(en, const Locale(language: 'zh', region: 'TW')),
    //     'Chinese (Taiwan)');

    expect(languageOf(zh, fr), '法文');
    expect(languageOf(zh, const Locale(language: 'zh')), '中文');
    expect(languageOf(zh, de), '德文');
  });

  testWithFormatting(
    'language with languageDisplay',
    () {
      String languageWith(LanguageDisplay display) =>
          Intl(locale: const Locale(language: 'en'))
              .displayNames(DisplayNamesOptions(languageDisplay: display))
              .ofLanguage(const Locale(language: 'en', region: 'GB'));

      expect(languageWith(LanguageDisplay.dialect), 'British English');
      expect(
          languageWith(LanguageDisplay.standard), 'English (United Kingdom)');
    },
    tags: ['icu4xUnimplemented'],
  );

  testWithFormatting(
    'calendar',
    () {
      final displayNames =
          Intl(locale: const Locale(language: 'en')).displayNames();

      expect(displayNames.ofCalendar(Calendar.roc), 'Minguo Calendar');
      expect(displayNames.ofCalendar(Calendar.gregory), 'Gregorian Calendar');
      expect(displayNames.ofCalendar(Calendar.chinese), 'Chinese Calendar');
    },
    tags: ['icu4xUnimplemented'],
  );

  testWithFormatting(
    'dateTimeField',
    () {
      final displayNames =
          Intl(locale: const Locale(language: 'pt')).displayNames();
      expect(displayNames.ofDateTime(DateTimeField.era), 'era');
      expect(displayNames.ofDateTime(DateTimeField.year), 'ano');
      expect(displayNames.ofDateTime(DateTimeField.month), 'mês');
      expect(displayNames.ofDateTime(DateTimeField.quarter), 'trimestre');
      expect(displayNames.ofDateTime(DateTimeField.weekOfYear), 'semana');
      expect(displayNames.ofDateTime(DateTimeField.weekday), 'dia da semana');
      expect(displayNames.ofDateTime(DateTimeField.dayPeriod), 'AM/PM');
      expect(displayNames.ofDateTime(DateTimeField.day), 'dia');
      expect(displayNames.ofDateTime(DateTimeField.hour), 'hora');
      expect(displayNames.ofDateTime(DateTimeField.minute), 'minuto');
      expect(displayNames.ofDateTime(DateTimeField.second), 'segundo');
    },
    tags: ['icu4xUnimplemented'],
  );

  testWithFormatting(
    'currency',
    () {
      expect(
        Intl(locale: const Locale(language: 'pt'))
            .displayNames()
            .ofCurrency('USD'),
        'Dólar americano',
      );
    },
    tags: ['icu4xUnimplemented'],
  );

  testWithFormatting(
    'script',
    () {
      expect(
        Intl(locale: const Locale(language: 'fr'))
            .displayNames()
            .ofScript('Egyp'),
        'hiéroglyphes égyptiens',
      );
    },
    tags: ['icu4xUnimplemented'],
  );

  testWithFormatting('region', () {
    String regionNames(Locale locale, String region) =>
        Intl(locale: locale).displayNames().ofRegion(region);

    const en = Locale(language: 'en');
    expect(regionNames(en, '419'), 'Latin America');
    expect(regionNames(en, 'BZ'), 'Belize');
    expect(regionNames(en, 'US'), 'United States');
    expect(regionNames(en, 'BA'), 'Bosnia & Herzegovina');
    expect(regionNames(en, 'MM'), 'Myanmar (Burma)');

    const zh = Locale(language: 'zh', script: 'Hant');
    expect(regionNames(zh, '419'), '拉丁美洲');
    expect(regionNames(zh, 'BZ'), '貝里斯');
    expect(regionNames(zh, 'US'), '美國');
    expect(regionNames(zh, 'BA'), '波士尼亞與赫塞哥維納');
    expect(regionNames(zh, 'MM'), '緬甸');

    const es = Locale(language: 'es', region: '419');
    expect(regionNames(es, 'DE'), 'Alemania');
  });
}
