// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Comparison example showing how to perform internationalization tasks in:
/// 1. package:intl (the legacy / previous approach)
/// 2. package:intl4x (the modular / ICU4X-backed approach)
library;

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;

import 'package:intl4x/case_mapping.dart' as intl4x;
import 'package:intl4x/collation.dart' as intl4x;
import 'package:intl4x/datetime_format.dart' as intl4x;
import 'package:intl4x/display_names.dart' as intl4x;
import 'package:intl4x/list_format.dart' as intl4x;
import 'package:intl4x/number_format.dart' as intl4x;
import 'package:intl4x/plural_rules.dart' as intl4x;

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
  _exampleCompactNumberFormatting();
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
  final intl4xLocale = intl4x.Locale.parse('de-DE');
  // #enddocregion locale_handling
  print(
    'intl4x (now): Locale object = $intl4xLocale '
    '(language tag: ${intl4xLocale.toLanguageTag()})',
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
  final intl4xFormatter = intl4x.NumberFormat(
    locale: intl4x.Locale.parse('en-US'),
  );
  print(intl4xFormatter.format(1234567.89));
  // #enddocregion number_format
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
  final intl4xCurrency = intl4x.NumberFormat.currency(
    locale: intl4x.Locale.parse('en-US'),
    currency: 'USD',
  ).format(amount);
  // #enddocregion currency_format
  print('intl4x (now):  $intl4xCurrency');
  print('');
}

/// 4. Compact Number Formatting (e.g. 1.2M, 5K)
void _exampleCompactNumberFormatting() {
  print('--- 4. Compact Number Formatting ---');
  const largeNumber = 1234567;

  // BEFORE (intl):
  final intlCompact = intl.NumberFormat.compact(
    locale: 'en_US',
  ).format(largeNumber);
  print('intl (before): $intlCompact');

  // NOW (intl4x):
  // #docregion compact_number_format
  final intl4xCompact = intl4x.NumberFormat.compact(
    locale: intl4x.Locale.parse('en-US'),
  ).format(largeNumber);
  // #enddocregion compact_number_format
  print('intl4x (now):  $intl4xCompact');
  print('');
}

/// 5. Unit Formatting (e.g. 5 meters)
void _exampleUnitFormatting() {
  print('--- 5. Unit Formatting ---');
  const value = 5;

  // BEFORE (intl): No direct unit formatting API; required custom string
  // formatting.
  final intlUnit = '$value meters';
  print('intl (before): $intlUnit (manual concatenation)');

  // NOW (intl4x): Built-in Unit formatting with CLDR unit rules.
  // #docregion unit_format
  final intl4xUnit = intl4x.NumberFormat(
    locale: intl4x.Locale.parse('en-US'),
    style: const intl4x.UnitStyle(
      unit: intl4x.Unit.meter,
      unitDisplay: intl4x.UnitDisplay.long,
    ),
  ).format(value);
  // #enddocregion unit_format
  print('intl4x (now):  $intl4xUnit (using Unit.meter)');
  print('');
}

/// 6. Date Formatting
void _exampleDateFormatting() {
  print('--- 6. Date Formatting ---');
  final dateTime = DateTime(2026, 7, 9);

  // BEFORE (intl): Requires date pattern string or factory method + date
  // symbol initialization.
  final intlDate = intl.DateFormat.yMMMMd('en_US').format(dateTime);
  print('intl (before): $intlDate');

  // NOW (intl4x): Clean, typed date formatter API without pattern string
  // magic.
  // #docregion date_format
  final intl4xDate = intl4x.DateTimeFormat.yearMonthDay(
    locale: intl4x.Locale.parse('en-US'),
    length: intl4x.DateTimeLength.long,
  ).format(dateTime);
  // #enddocregion date_format
  print('intl4x (now):  $intl4xDate');
  print('');
}

/// 7. Time Formatting & TimeZones
void _exampleTimeFormatting() {
  print('--- 7. Time & TimeZone Formatting ---');
  final dateTime = DateTime.parse('2026-07-09T14:30:00');
  const timeZone = 'Europe/Paris';

  // BEFORE (intl):
  final intlTime = intl.DateFormat.jm('en_US').format(dateTime);
  print('intl (before): $intlTime');

  // NOW (intl4x):
  // #docregion time_format
  final intl4xTime = intl4x.DateTimeFormat.yearMonthDayTime(
    locale: intl4x.Locale.parse('en-US'),
    length: intl4x.DateTimeLength.long,
  ).withTimeZoneLong().format(dateTime, timeZone);
  // #enddocregion time_format
  print('intl4x (now):  $intl4xTime');
  print('');
}

/// 8. Plurals & Plural Rules
void _examplePlurals() {
  print('--- 8. Plurals & Plural Categories ---');
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
  final category = intl4x.PluralRules(
    locale: intl4x.Locale.parse('en-US'),
  ).select(count);
  // #enddocregion plurals
  print(
    'intl4x (now):  PluralCategory = $category '
    '(category selection for count=$count)',
  );
  print('');
}

/// 9. List Formatting (joining with 'and' / 'or')
void _exampleListFormatting() {
  print('--- 9. List Formatting ---');
  final items = ['Apples', 'Oranges', 'Bananas'];

  // BEFORE (intl): No built-in list formatting API in intl; required custom
  // code or join.
  final intlList = items.join(', ');
  print('intl (before): "$intlList" (standard join)');

  // NOW (intl4x): Built-in locale-aware list formatting (conjunctions,
  // disjunctions, etc.).
  // #docregion list_format
  final intl4xList = intl4x.ListFormat(
    locale: intl4x.Locale.parse('en-US'),
    type: intl4x.ListType.and,
  ).format(items);
  // #enddocregion list_format

  // Or extension method: items.joinAnd(locale: intl4x.Locale.parse('en-US'))
  print('intl4x (now):  "$intl4xList" (or via items.joinAnd())');
  print('');
}

/// 10. Display Names (Language / Region Names)
void _exampleDisplayNames() {
  print('--- 10. Display Names ---');

  // BEFORE (intl): No built-in display names API in intl package.
  print('intl (before): Not supported in package:intl');

  // NOW (intl4x): DisplayNames for localized language and region names.
  // #docregion display_names
  final displayNames = intl4x.DisplayNames(
    locale: intl4x.Locale.parse('en-US'),
  );
  final germanName = displayNames.ofLocale(intl4x.Locale.parse('de-DE'));
  final regionName = displayNames.ofRegion('419');
  // #enddocregion display_names
  print('intl4x (now):  Locale "de-DE" in en-US -> "$germanName"');
  print('intl4x (now):  Region "419" in en-US   -> "$regionName"');
  print('');
}

/// 11. String Collation / Locale Sorting
void _exampleCollation() {
  print('--- 11. String Collation / Locale Sorting ---');

  // BEFORE (intl): Standard String.compareTo (UTF-16 code unit ordering).
  final listIntl = ['a', 'ä', 'b']..sort((x, y) => x.compareTo(y));
  print('intl (before): Standard String.sort() -> $listIntl');

  // NOW (intl4x): Locale-sensitive collation (e.g. in German 'ä' is sorted
  // near 'a', in Swedish after 'z').
  // #docregion collation
  final listIntl4x = ['a', 'ä', 'b'];
  final collationDe = intl4x.Collation(locale: intl4x.Locale.parse('de'));
  listIntl4x.sort(collationDe.compare);
  // #enddocregion collation
  print('intl4x (now):  Locale-aware sort (de) -> $listIntl4x');
  print('');
}

/// 12. Case Mapping
void _exampleCaseMapping() {
  print('--- 12. Case Mapping ---');
  const upper = 'TICKET';

  // BEFORE (intl): Standard String.toLowerCase() (not locale-aware for Turkish
  // dotless i, etc.).
  print('intl (before): String.toLowerCase() -> "${upper.toLowerCase()}"');

  // NOW (intl4x): Locale-sensitive case mapping.
  // #docregion case_mapping
  final trLocale = intl4x.Locale.parse('tr');
  final lowerTr = intl4x.CaseMapping(locale: trLocale).toLowerCase(upper);
  // #enddocregion case_mapping
  print('intl4x (now):  CaseMapping (tr)    -> "$lowerTr" (Turkish dotless i)');
  print('');
}
