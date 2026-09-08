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

  _exampleInitialization();
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
  _exampleParsingVsFormatting();
  _exampleTestingBehavior();
}

/// 1. Zero Async Initialization
void _exampleInitialization() {
  print('--- 1. Zero Async Initialization ---');

  // BEFORE (intl): Requires asynchronous locale data initialization before
  // formatting dates or times in non-default locales:
  //   await initializeDateFormatting('de_DE', null);
  // Forgetting this throws `LocaleDataException`.
  print(
    'intl (before): Requires `await initializeDateFormatting(...)` '
    'before formatting dates in non-default locales.',
  );

  // NOW (intl4x): Fully synchronous out-of-the-box with no setup required.
  // Data is pre-bundled (native ICU4X) or provided by the browser (ECMA).
  final formatted = DateTimeFormat.yearMonthDay(
    locale: Locale.parse('de-DE'),
  ).format(DateTime(2026, 7, 9));
  print('intl4x (now):  Synchronous format with zero init: "$formatted"');
  print('');
}

/// 2. Locale Representation & Parsing
void _exampleLocaleHandling() {
  print('--- 2. Locale Handling ---');

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

/// 3. Standard Number Formatting
void _exampleNumberFormatting() {
  print('--- 3. Number Formatting ---');
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

/// 4. Currency Formatting
void _exampleCurrencyFormatting() {
  print('--- 4. Currency Formatting ---');
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

/// 5. Unit Formatting (e.g. 5 meters)
void _exampleUnitFormatting() {
  print('--- 5. Unit Formatting [NEW IN INTL4X] ---');
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
  final intl4xDate = DateTimeFormat.yearMonthDay(
    locale: Locale.parse('en-US'),
    length: DateTimeLength.long,
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
  final intl4xTime = DateTimeFormat.yearMonthDayTime(
    locale: Locale.parse('en-US'),
    length: DateTimeLength.long,
  ).withTimeZoneLong().format(dateTime, timeZone);
  // #enddocregion time_format
  print('intl4x (now):  $intl4xTime');
  print('');
}

/// 8. Plurals & Plural Selection
void _examplePlurals() {
  print(
    '--- 8. Plurals & Plural Selection '
    '[NEW IN INTL4X: Direct Plural Selection & Ordinals] ---',
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

  // NOW (intl4x): Direct plural selection with PluralRules.
  // #docregion plurals
  final intl4xPlural = PluralRules(
    locale: Locale.parse('en-US'),
  ).select(count, one: '1 item', other: '$count items');
  // #enddocregion plurals
  print('intl4x (now):  "$intl4xPlural"');

  // Ordinal plural rules (e.g. 1st, 2nd, 3rd, 4th)
  final ordinalSuffix = PluralRules(
    locale: Locale.parse('en-US'),
    type: PluralType.ordinal,
  ).select(2, one: 'st', two: 'nd', few: 'rd', other: 'th');
  print(
    'intl4x (now) [NEW]: "2$ordinalSuffix" '
    '(ordinal category for 2 -> 2nd)',
  );
  print('');
}

/// 9. List Formatting (joining with 'and' / 'or')
void _exampleListFormatting() {
  print('--- 9. List Formatting [NEW IN INTL4X] ---');
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

/// 10. Display Names (Language / Region Names)
void _exampleDisplayNames() {
  print('--- 10. Display Names [NEW IN INTL4X] ---');

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

/// 11. String Collation / Locale Sorting
void _exampleCollation() {
  print('--- 11. String Collation / Locale Sorting [NEW IN INTL4X] ---');

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

/// 12. Case Mapping
void _exampleCaseMapping() {
  print('--- 12. Case Mapping [NEW IN INTL4X] ---');
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

/// 13. Formatting vs. Parsing
void _exampleParsingVsFormatting() {
  print('--- 13. Formatting vs. Parsing ---');

  // BEFORE (intl): Supported parsing strings back into numbers and dates.
  final parsedNumber = intl.NumberFormat.decimalPattern(
    'en_US',
  ).parse('1,234.56');
  final parsedDate = intl.DateFormat('yyyy-MM-dd').parse('2026-07-09');
  print(
    'intl (before): Parsing supported '
    '(number: $parsedNumber, date: $parsedDate)',
  );

  // NOW (intl4x): Focuses strictly on locale-sensitive formatting.
  // The only parsing method provided is `Locale.parse()` for BCP-47 language
  // tags. String parsing for dates and numbers is not yet supported.
  print(
    'intl4x (now):  Formatting only (no DateFormat/NumberFormat.parse). '
    'Locale.parse() parses language tags.',
  );
  print('');
}

/// 14. Testing Behavior in `dart test`
void _exampleTestingBehavior() {
  print('--- 14. Testing in `dart test` ---');

  // BEFORE (intl): Tests run against real formatting, which can cause
  // brittle assertion failures when platform ICU or CLDR data changes
  // (e.g. non-breaking space vs ASCII space).
  print(
    'intl (before): Real formatting runs in tests, occasionally causing '
    'brittle assertions across platforms and CLDR versions.',
  );

  // NOW (intl4x): In `dart test`, intl4x stubs formatting output by default
  // to keep tests deterministic and prevent brittle failures.
  // To enable real formatting (e.g. for golden tests), pass the compile-time
  // flag:
  //   dart test -Dintl4x.brittle_i18n_testing=true
  print(
    'intl4x (now):  Formatting is stubbed in `dart test` by default. '
    'Pass `-Dintl4x.brittle_i18n_testing=true` to opt into real formatting.',
  );
  print('');
}
