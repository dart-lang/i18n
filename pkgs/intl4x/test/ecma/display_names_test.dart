// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/display_names.dart';
import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  testWithFormatting('basic', () {
    expect(
        Intl(defaultLocale: const Locale(language: 'en', region: 'US'))
            .displayNames()
            .ofLanguage(const Locale(language: 'de', region: 'DE')),
        'German (Germany)');
  });

  testWithFormatting('languageDisplay', () {
    String of(DisplayNamesOptions options) =>
        Intl(defaultLocale: const Locale(language: 'en'))
            .displayNames(options)
            .ofLanguage(const Locale(language: 'en', region: 'GB'));

    expect(
      of(const DisplayNamesOptions(languageDisplay: LanguageDisplay.dialect)),
      'British English',
    );
    expect(
      of(const DisplayNamesOptions(languageDisplay: LanguageDisplay.standard)),
      'English (United Kingdom)',
    );
  });

  testWithFormatting('calendar', () {
    final displayNames =
        Intl(defaultLocale: const Locale(language: 'en')).displayNames();

    expect(displayNames.ofCalendar(Calendar.roc), 'Minguo Calendar');
    expect(displayNames.ofCalendar(Calendar.gregory), 'Gregorian Calendar');
    expect(displayNames.ofCalendar(Calendar.chinese), 'Chinese Calendar');
  });

  testWithFormatting('dateTimeField', () {
    final displayNames =
        Intl(defaultLocale: const Locale(language: 'pt')).displayNames();
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
  });

  testWithFormatting('currency', () {
    expect(
      Intl(defaultLocale: const Locale(language: 'pt'))
          .displayNames()
          .ofCurrency('USD'),
      'Dólar americano',
    );
  });

  testWithFormatting('script', () {
    expect(
      Intl(defaultLocale: const Locale(language: 'fr'))
          .displayNames()
          .ofScript('Egyp'),
      'hiéroglyphes égyptiens',
    );
  });

  testWithFormatting('region', () {
    expect(
      Intl(defaultLocale: const Locale(language: 'es', region: '419'))
          .displayNames()
          .ofRegion('DE'),
      'Alemania',
    );
  });
}
