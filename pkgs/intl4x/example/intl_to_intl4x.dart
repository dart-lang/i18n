// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Comparison example showing how to perform internationalization tasks in:
/// 1. package:intl (the legacy / previous approach)
/// 2. package:intl4x (the modular / ICU4X-backed approach)
library;

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;

import 'package:intl4x/case_mapping.dart';
import 'package:intl4x/collation.dart';
import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/display_names.dart';
import 'package:intl4x/list_format.dart';
import 'package:intl4x/number_format.dart';
import 'package:intl4x/plural_rules.dart';

Future<void> main() async {
  print('====================================================');
  print('  Comparing package:intl vs package:intl4x APIs');
  print('====================================================\n');

  // Initialize intl date formatting for test locales
  await initializeDateFormatting('en_US', null);
  await initializeDateFormatting('de_DE', null);

  _exampleLocaleHandling();
  _exampleNumberFormatting();
  _exampleCurrencyFormatting();
  _exampleUnitFormatting();
  _exampleDateFormatting();
  _exampleTimeFormatting();
  _examplePlurals();
  _exampleListFormatting();
  _exampleDisplayNames();
  _exampleCollation();
  _exampleCaseMapping();
}

/// 1. Locale Representation & Parsing
void _exampleLocaleHandling() {
  print('--- 1. Locale Handling ---');

  // BEFORE (intl): Locales are represented by String tags (e.g. 'en_US',
  // 'de_DE').
  const intlLocaleStr = 'de_DE';
  final canonicalized = intl.Intl.canonicalizedLocale(intlLocaleStr);
  print(
    'intl (before): String locale tag = "$intlLocaleStr", '
    'canonicalized = "$canonicalized"',
  );

  // NOW (intl4x): Strongly-typed Locale instances with BCP-47 tag parsing.
  // #docregion locale_handling
  final intl4xLocale = Locale.parse('de-DE');
  // #enddocregion locale_handling
  print(
    'intl4x (now): Locale object = $intl4xLocale '
    '(language tag: ${intl4xLocale.toLanguageTag()})',
  );

  // Unicode extensions / options (e.g. calendar, numbering system)
  final localeWithCalendar = intl4xLocale.withCalendar(Calendar.buddhist);
  print(
    'intl4x (now) [NEW]: Locale with Unicode Extension (ca=buddhist): '
    '$localeWithCalendar',
  );
  print('');
}

/// 2. Standard Number Formatting
void _exampleNumberFormatting() {
  print('--- 2. Number Formatting ---');
  const number = 1234567.89;

  // BEFORE (intl):
  final intlFormatted = intl.NumberFormat.decimalPattern(
    'en_US',
  ).format(number);
  print('intl (before): $intlFormatted');

  // NOW (intl4x):
  // #docregion number_format
  final intl4xFormatter = NumberFormat(locale: Locale.parse('en-US'));
  final intl4xFormatted = intl4xFormatter.format(number);
  // #enddocregion number_format
  print('intl4x (now):  $intl4xFormatted');
  print('');
}

/// 3. Currency Formatting
void _exampleCurrencyFormatting() {
  print('--- 3. Currency Formatting ---');
  const amount = 1234.56;

  // BEFORE (intl):
  final intlCurrency = intl.NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
  ).format(amount);
  print('intl (before): $intlCurrency');

  // NOW (intl4x):
  // #docregion currency_format
  final intl4xCurrency = NumberFormat.currency(
    locale: Locale.parse('en-US'),
    currency: 'USD',
  ).format(amount);
  // #enddocregion currency_format
  print('intl4x (now):  $intl4xCurrency');
  print('');
}

/// 4. Unit Formatting (e.g. 5 meters)
void _exampleUnitFormatting() {
  print('--- 4. Unit Formatting [NEW IN INTL4X] ---');
  const value = 5;

  // BEFORE (intl): No direct unit formatting API; required custom string
  // formatting.
  final intlUnit = '$value meters';
  print('intl (before): Not supported ($intlUnit via manual concatenation)');

  // NOW (intl4x): Built-in Unit formatting with CLDR unit rules.
  // #docregion unit_format
  final intl4xUnit = NumberFormat(
    locale: Locale.parse('en-US'),
    style: const UnitStyle(unit: Unit.meter, unitDisplay: UnitDisplay.long),
  ).format(value);
  // #enddocregion unit_format
  print('intl4x (now) [NEW]: $intl4xUnit (using Unit.meter)');
  print('');
}

/// 5. Date Formatting
void _exampleDateFormatting() {
  print('--- 5. Date Formatting ---');
  final dateTime = DateTime(2026, 7, 9);

  // BEFORE (intl): Requires date pattern string or factory method + date
  // symbol initialization.
  final intlDate = intl.DateFormat.yMMMMd('en_US').format(dateTime);
  print('intl (before): $intlDate');

  // NOW (intl4x): Clean, typed date formatter API without pattern string
  // magic.
  // #docregion date_format
  final intl4xDate = DateTimeFormat.yearMonthDay(
    locale: Locale.parse('en-US'),
    length: DateTimeLength.long,
  ).format(dateTime);
  // #enddocregion date_format
  print('intl4x (now):  $intl4xDate');
  print('');
}

/// 6. Time Formatting & TimeZones
void _exampleTimeFormatting() {
  print('--- 6. Time & TimeZone Formatting ---');
  final dateTime = DateTime.parse('2026-07-09T14:30:00');
  const timeZone = 'Europe/Paris';

  // BEFORE (intl):
  final intlTime = intl.DateFormat.jm('en_US').format(dateTime);
  print('intl (before): $intlTime');

  // NOW (intl4x):
  // #docregion time_format
  final intl4xTime = DateTimeFormat.yearMonthDayTime(
    locale: Locale.parse('en-US'),
    length: DateTimeLength.long,
  ).withTimeZoneLong().format(dateTime, timeZone);
  // #enddocregion time_format
  print('intl4x (now):  $intl4xTime');
  print('');
}

/// 7. Plurals & Plural Rules
void _examplePlurals() {
  print(
    '--- 7. Plurals & Plural Categories '
    '[NEW IN INTL4X: Direct CLDR Categories & Ordinals] ---',
  );
  const count = 3;

  // BEFORE (intl): Message-based plural resolution.
  final intlPluralMessage = intl.Intl.plural(
    count,
    one: '1 item',
    other: '$count items',
    locale: 'en_US',
  );
  print('intl (before): "$intlPluralMessage" (string message template)');

  // NOW (intl4x): Direct CLDR PluralCategory selection.
  // #docregion plurals
  final category = PluralRules(locale: Locale.parse('en-US')).select(count);
  // #enddocregion plurals
  print(
    'intl4x (now):  PluralCategory = $category '
    '(cardinal category for count=$count)',
  );

  // Ordinal plural rules (e.g. 1st, 2nd, 3rd, 4th)
  final ordinalCategory = PluralRules(
    locale: Locale.parse('en-US'),
    type: PluralType.ordinal,
  ).select(2);
  print(
    'intl4x (now) [NEW]: PluralCategory = $ordinalCategory '
    '(ordinal category for 2 -> 2nd)',
  );
  print('');
}

/// 8. List Formatting (joining with 'and' / 'or')
void _exampleListFormatting() {
  print('--- 8. List Formatting [NEW IN INTL4X] ---');
  final items = ['Apples', 'Oranges', 'Bananas'];

  // BEFORE (intl): No built-in list formatting API in intl; required custom
  // code or join.
  final intlList = items.join(', ');
  print('intl (before): Not supported ("$intlList" via standard join)');

  // NOW (intl4x): Built-in locale-aware list formatting (conjunctions,
  // disjunctions, etc.).
  // #docregion list_format
  final intl4xList = ListFormat(
    locale: Locale.parse('en-US'),
    type: ListType.and,
  ).format(items);
  // #enddocregion list_format

  // Or extension method: items.joinAnd(locale: Locale.parse('en-US'))
  print(
    'intl4x (now) [NEW]: "$intl4xList" (using ListType.and / items.joinAnd())',
  );
  print('');
}

/// 9. Display Names (Language / Region Names)
void _exampleDisplayNames() {
  print('--- 9. Display Names [NEW IN INTL4X] ---');

  // BEFORE (intl): No built-in display names API in intl package.
  print('intl (before): Not supported in package:intl');

  // NOW (intl4x): DisplayNames for localized language and region names.
  // #docregion display_names
  final displayNames = DisplayNames(locale: Locale.parse('en-US'));
  final germanName = displayNames.ofLocale(Locale.parse('de-DE'));
  final regionName = displayNames.ofRegion('419');
  // #enddocregion display_names
  print('intl4x (now) [NEW]: Locale "de-DE" in en-US -> "$germanName"');
  print('intl4x (now) [NEW]: Region "419" in en-US   -> "$regionName"');
  print('');
}

/// 10. String Collation / Locale Sorting
void _exampleCollation() {
  print('--- 10. String Collation / Locale Sorting [NEW IN INTL4X] ---');

  // BEFORE (intl): Standard String.compareTo (UTF-16 code unit ordering).
  final listIntl = ['a', 'ä', 'b']..sort((x, y) => x.compareTo(y));
  print('intl (before): Not supported (Standard String.sort() -> $listIntl)');

  // NOW (intl4x): Locale-sensitive collation (e.g. in German 'ä' is sorted
  // near 'a', in Swedish after 'z').
  // #docregion collation
  final listIntl4x = ['a', 'ä', 'b'];
  final collationDe = Collation(locale: Locale.parse('de'));
  listIntl4x.sort(collationDe.compare);
  // #enddocregion collation
  print('intl4x (now) [NEW]: Locale-aware sort (de) -> $listIntl4x');
  print('');
}

/// 11. Case Mapping
void _exampleCaseMapping() {
  print('--- 11. Case Mapping [NEW IN INTL4X] ---');
  const upper = 'TICKET';
  const word = 'istanbul';

  // BEFORE (intl): Limited to toBeginningOfSentenceCase() for Turkish.
  final intlSentenceCase = intl.toBeginningOfSentenceCase(word, 'tr');
  print(
    'intl (before): toBeginningOfSentenceCase("istanbul", "tr") -> '
    '"$intlSentenceCase"',
  );

  // NOW (intl4x): Comprehensive locale-sensitive lower/uppercase mapping.
  // #docregion case_mapping
  final trLocale = Locale.parse('tr');
  final lowerTr = CaseMapping(locale: trLocale).toLowerCase(upper);
  final upperTr = CaseMapping(locale: trLocale).toUpperCase(word);
  // #enddocregion case_mapping
  print(
    'intl4x (now) [NEW]: CaseMapping(tr).toLowerCase("TICKET") -> '
    '"$lowerTr" (dotless i)',
  );
  print(
    'intl4x (now) [NEW]: CaseMapping(tr).toUpperCase("istanbul") -> '
    '"$upperTr" (dotted İ)',
  );
  print('');
}
