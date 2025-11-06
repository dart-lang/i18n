// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/display_names.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  testWithFormatting('basic', () {
    expect(
      DisplayNames(
        locale: Locale.parse('en-US'),
      ).ofLanguage(Locale.parse('de-DE')),
      'German (Germany)',
    );
  });

  testWithFormatting('languageDisplay', () {
    String of(DisplayNamesOptions options) => DisplayNames(
      locale: Locale.parse('en'),
      options: options,
    ).ofLanguage(Locale.parse('en-GB'));

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
    final displayNames = DisplayNames(locale: Locale.parse('en'));

    expect(displayNames.ofCalendar(Calendar.roc), 'Minguo Calendar');
    expect(displayNames.ofCalendar(Calendar.gregorian), 'Gregorian Calendar');
    expect(displayNames.ofCalendar(Calendar.chinese), 'Chinese Calendar');
  });

  testWithFormatting('dateTimeField', () {
    final displayNames = DisplayNames(locale: Locale.parse('pt'));
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
      DisplayNames(locale: Locale.parse('pt')).ofCurrency('USD'),
      'Dólar americano',
    );
  });

  testWithFormatting('script', () {
    expect(
      DisplayNames(locale: Locale.parse('fr')).ofScript('Egyp'),
      'hiéroglyphes égyptiens',
    );
  });

  testWithFormatting('region', () {
    expect(
      DisplayNames(locale: Locale.parse('es-419')).ofRegion('DE'),
      'Alemania',
    );
  });
}
