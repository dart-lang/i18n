// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Side-by-side migration guide comparing:
/// 1. `package:intl` (legacy formatting APIs)
/// 2. `package:intl4x` (modular ICU4X / browser ECMA-402 formatting APIs)
/// 3. `package:convert` (`FixedDateTimeFormatter` for non-localized wire/fixed
///    date patterns)
///
/// Run with an optional BCP-47 locale tag (defaults to `en-US`):
///   dart run example/intl_to_intl4x.dart
///   dart run example/intl_to_intl4x.dart de-DE
library;

import 'package:convert/convert.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;

import 'package:intl4x/calendar.dart';
import 'package:intl4x/case_mapping.dart';
import 'package:intl4x/collation.dart';
import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/display_names.dart';
import 'package:intl4x/list_format.dart';
import 'package:intl4x/number_format.dart';
import 'package:intl4x/plural_rules.dart';

Future<void> main(List<String> args) async {
  final rawLocale = args.isNotEmpty ? args.first : 'en-US';
  final locale = Locale.parse(rawLocale.replaceAll('_', '-'));
  final intlLocale = intl.Intl.canonicalizedLocale(rawLocale);

  print('====================================================');
  print('  Migrating from package:intl to package:intl4x');
  print('  Locale: ${locale.toLanguageTag()} (intl: $intlLocale)');
  print('====================================================\n');

  // Initialize `package:intl` date formatting for the selected locale.
  await initializeDateFormatting(intlLocale, null);

  // Part 1: Migrating existing `package:intl` formatting APIs
  _exampleInitialization(locale);
  _exampleLocaleHandling(locale, rawLocale);
  _exampleNumberFormatting(locale, intlLocale);
  _exampleWebOnlyNumberStyles(locale, intlLocale);
  _exampleDateFormatting(locale, intlLocale);
  _exampleTimeAndTimeZoneFormatting(locale, intlLocale);

  // Part 2: What stays on `package:intl` or moves to `package:convert`
  _exampleMessagesStayOnIntl(intlLocale);
  _exampleFixedPatternsAndParsing(intlLocale);

  // Part 3: New capabilities in `package:intl4x` (not in `package:intl`)
  _examplePluralRules(locale);
  _exampleListFormatting(locale);
  _exampleDisplayNames(locale);
  _exampleCollation(locale);
  _exampleCaseMapping();
  _exampleCalendar(locale);

  // Part 4: Testing behavior
  _exampleTestingBehavior();
}

/// 1. Zero Async Initialization
void _exampleInitialization(Locale locale) {
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
    locale: locale,
  ).format(DateTime(2026, 7, 9));
  print('intl4x (now):  Synchronous format with zero init: "$formatted"');
  print('');
}

/// 2. Locale Representation & Parsing
void _exampleLocaleHandling(Locale locale, String rawLocale) {
  print('--- 2. Locale Handling ---');

  // BEFORE (intl): Locales are represented by String tags (e.g. 'en_US',
  // 'de_DE').
  final canonicalized = intl.Intl.canonicalizedLocale(rawLocale);
  print(
    'intl (before): String locale tag = "$rawLocale", '
    'canonicalized = "$canonicalized"',
  );

  // NOW (intl4x): Strongly-typed Locale instances with BCP-47 tag parsing.
  // Omit `locale:` in formatters to follow `Locale.system` (OS/browser locale)
  // rather than hardcoding `'en-US'`.
  final parsedLocale = Locale.parse(locale.toLanguageTag());
  print(
    'intl4x (now):  Locale object = $parsedLocale '
    '(language: ${parsedLocale.language}, region: ${parsedLocale.region})',
  );

  // Unicode extensions (e.g. calendar, numbering system).
  final localeWithCalendar = parsedLocale.withCalendar(Calendar.buddhist);
  print(
    'intl4x (now):  Locale with Unicode extension (ca=buddhist): '
    '$localeWithCalendar',
  );
  print('');
}

/// 3. Decimal Number Formatting (Native + Web)
void _exampleNumberFormatting(Locale locale, String intlLocale) {
  print('--- 3. Decimal Number Formatting (Native + Web) ---');
  const number = 1234567.89;

  // BEFORE (intl):
  final intlFormatted = intl.NumberFormat.decimalPattern(
    intlLocale,
  ).format(number);
  print('intl (before): $intlFormatted');

  // NOW (intl4x):
  final intl4xFormatter = NumberFormat(locale: locale);
  final intl4xFormatted = intl4xFormatter.format(number);
  print('intl4x (now):  $intl4xFormatted');
  print('');
}

/// 4. Currency, Compact, Percent & Unit Formatting (Web / ECMA-only for now)
void _exampleWebOnlyNumberStyles(Locale locale, String intlLocale) {
  print('--- 4. Currency, Compact, Percent & Unit Formatting (Web-only) ---');
  const amount = 1234.56;
  const bigNumber = 1234567;
  const ratio = 0.875;
  const meters = 5;

  // BEFORE (intl):
  final intlCurrency = intl.NumberFormat.simpleCurrency(
    locale: intlLocale,
    name: 'USD',
  ).format(amount);
  final intlCompact = intl.NumberFormat.compact(
    locale: intlLocale,
  ).format(bigNumber);
  final intlPercent = intl.NumberFormat.decimalPercentPattern(
    locale: intlLocale,
    decimalDigits: 1,
  ).format(ratio);
  print(
    'intl (before): currency="$intlCurrency", compact="$intlCompact", '
    'percent="$intlPercent" (no built-in unit formatting)',
  );

  // NOW (intl4x):
  // NOTE: Currency, compact, percent, and unit styles are implemented on the
  // web (ECMA) backend. On native platforms (ICU4X), `NumberFormat` currently
  // falls back to plain decimal formatting until ICU4X stabilizes these APIs.
  final currencyFmt = NumberFormat.currency(locale: locale, currency: 'USD');
  final compactFmt = NumberFormat.compact(locale: locale);
  final percentFmt = NumberFormat.percent(
    locale: locale,
    digits: const Digits.withFractionDigits(minimum: 1, maximum: 1),
  );
  final unitFmt = NumberFormat(
    locale: locale,
    style: const UnitStyle(unit: Unit.meter, unitDisplay: UnitDisplay.long),
  );
  print(
    'intl4x (web/ECMA): currency="\$1,234.56", compact="1.2M", '
    'percent="87.5%", unit="5 meters" (for en-US)',
  );
  print(
    'intl4x (this runtime): '
    'currency="${currencyFmt.format(amount)}", '
    'compact="${compactFmt.format(bigNumber)}", '
    'percent="${percentFmt.format(ratio)}", '
    'unit="${unitFmt.format(meters)}"',
  );
  print('');
}

/// 5. Date Formatting
void _exampleDateFormatting(Locale locale, String intlLocale) {
  print('--- 5. Date Formatting ---');
  final dateTime = DateTime(2026, 7, 9);

  // BEFORE (intl): Relied on date pattern strings or skeleton factory methods
  // + async `initializeDateFormatting`.
  final intlDate = intl.DateFormat.yMMMMd(intlLocale).format(dateTime);
  print('intl (before): $intlDate');

  // NOW (intl4x): Typed date formatter API without pattern string magic.
  // Pass `yearStyle: YearStyle.full` when 4-digit years are required.
  // Always use a whole `intl4x` skeleton for localized dates rather than
  // combining localized pieces into a hand-built layout.
  final intl4xDate = DateTimeFormat.yearMonthDay(
    locale: locale,
    length: DateTimeLength.long,
    yearStyle: YearStyle.full,
  ).format(dateTime);
  print('intl4x (now):  $intl4xDate');
  print('');
}

/// 6. Time & TimeZone Formatting
void _exampleTimeAndTimeZoneFormatting(Locale locale, String intlLocale) {
  print('--- 6. Time & TimeZone Formatting ---');
  // Start from a UTC instant so both examples represent the same moment:
  // 2026-07-09T08:45:00Z == 2026-07-09T14:30:00+05:45 (Asia/Kathmandu).
  final instantUtc = DateTime.utc(2026, 7, 9, 8, 45);
  const timeZone = 'Asia/Kathmandu'; // UTC+5:45
  final kathmanduWallTime = instantUtc.add(
    const Duration(hours: 5, minutes: 45),
  );

  // BEFORE (intl): `package:intl` formats a DateTime in its own UTC/local
  // wall clock and cannot format localized IANA time zone names.
  final intlDateTime = intl.DateFormat.yMMMMd(
    intlLocale,
  ).add_jms().format(instantUtc);
  print('intl (before): $intlDateTime (UTC; no localized time zone names)');

  // NOW (intl4x): Supports explicit IANA time zones (passing the wall-clock
  // DateTime in that zone) and typed time precision (`TimePrecision.minute`,
  // `TimePrecision.minuteOptional`, `TimePrecision.second`).
  final intl4xDateTime = DateTimeFormat.yearMonthDayTime(
    locale: locale,
    length: DateTimeLength.long,
    timePrecision: TimePrecision.second,
  ).withTimeZoneLong().format(kathmanduWallTime, timeZone);
  print('intl4x (now):  $intl4xDateTime ($timeZone)');
  print('');
}

/// 7. Translatable Messages Stay on `package:intl` (or `package:messages`)
void _exampleMessagesStayOnIntl(String intlLocale) {
  print('--- 7. Translatable Messages (DO NOT Migrate to intl4x) ---');
  const count = 3;

  // KEEP ON `package:intl` (or migrate to `package:messages`):
  // `Intl.message`, `Intl.plural`, `Intl.select`, and `Intl.gender` are
  // translatable message definitions wired into translation pipelines.
  // Do NOT rewrite them to `PluralRules.select(...)`, which removes strings
  // from translation extraction.
  final message = intl.Intl.plural(
    count,
    one: '1 item',
    other: '$count items',
    locale: intlLocale,
  );
  print(
    'intl (keep):   "$message" '
    '(Intl.message/plural/select/gender stay on package:intl or '
    'package:messages)',
  );
  print('');
}

/// 8. Non-Localized Fixed Patterns & Parsing (`package:convert` / dart:core)
void _exampleFixedPatternsAndParsing(String intlLocale) {
  print('--- 8. Fixed Patterns & Parsing ---');
  final date = DateTime.utc(2026, 7, 9);

  // BEFORE (intl): `DateFormat` was often used for fixed, non-localized wire
  // formats (API payloads, database keys, logs) and parsing.
  final intlWireDate = intl.DateFormat('yyyy-MM-dd').format(date);
  final intlParsedDate = intl.DateFormat('yyyy-MM-dd').parse('2026-07-09');
  final intlParsedNumber = intl.NumberFormat.decimalPattern(
    intlLocale,
  ).parse('1234');
  print(
    'intl (before): wire="$intlWireDate", parsedDate=$intlParsedDate, '
    'parsedNumber=$intlParsedNumber',
  );

  // NOW: `intl4x` focuses strictly on locale-sensitive display formatting
  // (the only parser it provides is `Locale.parse()` for BCP-47 tags).
  //
  // 1. Fixed/wire date patterns -> `FixedDateTimeFormatter` (package:convert):
  final wireFormatter = FixedDateTimeFormatter('YYYY-MM-DD');
  final encodedDate = wireFormatter.encode(date);
  final decodedDate = wireFormatter.tryDecode(encodedDate);
  // 2. ISO-8601 strings -> `DateTime.tryParse(...)`
  final isoDate = DateTime.tryParse('2026-07-09T08:45:00Z');
  // 3. Plain numeric strings -> `num.tryParse(...)` / `int.tryParse(...)`
  final parsedNum = num.tryParse('1234.56');
  print(
    'convert/core:  wire="$encodedDate", decoded=$decodedDate, '
    'iso=$isoDate, num=$parsedNum',
  );
  print(
    'note:          Localized user-input parsing, BidiFormatter, and '
    'currencySymbol/dateSymbols currently stay on package:intl.',
  );
  print('');
}

/// 9. Plural Rules & Ordinals [NEW IN INTL4X]
void _examplePluralRules(Locale locale) {
  print('--- 9. Plural Rules & Ordinals [NEW IN INTL4X] ---');

  // Use `PluralRules` for non-message plural category selection (for example,
  // ordinal suffixes or implementing a message formatting library).
  const ordinalCount = 152;
  final category = PluralRules(locale: locale, type: PluralType.ordinal).select(
    ordinalCount,
    zero: 'zero',
    one: 'one',
    two: 'two',
    few: 'few',
    many: 'many',
    other: 'other',
  );
  print(
    'intl4x [NEW]:  Ordinal category for $ordinalCount in '
    '${locale.toLanguageTag()} -> "$category"',
  );

  final englishOrdinal =
      PluralRules(
        locale: Locale.parse('en-US'),
        type: PluralType.ordinal,
      ).select(
        ordinalCount,
        one: '${ordinalCount}st',
        two: '${ordinalCount}nd',
        few: '${ordinalCount}rd',
        other: '${ordinalCount}th',
      );
  print(
    'intl4x [NEW]:  English ordinal for $ordinalCount -> "$englishOrdinal"',
  );
  print('');
}

/// 10. List Formatting [NEW IN INTL4X]
void _exampleListFormatting(Locale locale) {
  print('--- 10. List Formatting [NEW IN INTL4X] ---');
  final items = ['Apples', 'Oranges', 'Bananas'];

  // `package:intl` has no list formatting API (`items.join(', ')` is not
  // localized and lacks proper conjunctions, punctuation, and RTL handling).
  final intl4xList = ListFormat(
    locale: locale,
    type: ListType.and,
  ).format(items);
  final intl4xJoined = items.joinAnd(locale: locale);
  print('intl4x [NEW]:  ListFormat -> "$intl4xList"');
  print('intl4x [NEW]:  items.joinAnd() -> "$intl4xJoined"');
  print('');
}

/// 11. Display Names [NEW IN INTL4X — @experimental]
void _exampleDisplayNames(Locale locale) {
  print('--- 11. Display Names [NEW IN INTL4X, @experimental] ---');

  final displayNames = DisplayNames(locale: locale);
  final germanName = displayNames.ofLocale(Locale.parse('de-DE'));
  final regionName = displayNames.ofRegion('419');
  print(
    'intl4x [NEW]:  Locale "de-DE" in ${locale.toLanguageTag()} -> '
    '"$germanName"',
  );
  print(
    'intl4x [NEW]:  Region "419" in ${locale.toLanguageTag()}   -> '
    '"$regionName"',
  );
  print('');
}

/// 12. String Collation / Locale Sorting [NEW IN INTL4X]
void _exampleCollation(Locale locale) {
  print('--- 12. String Collation [NEW IN INTL4X] ---');

  // Standard `String.compareTo` sorts by UTF-16 code units (not locale-aware).
  final utf16Sorted = ['a', 'ä', 'z', 'b']..sort((x, y) => x.compareTo(y));
  print('dart:core:     UTF-16 sort -> $utf16Sorted');

  // Locale-sensitive collation (e.g. in German 'ä' sorts near 'a', in Swedish
  // after 'z').
  final localeSorted = ['a', 'ä', 'z', 'b']
    ..sort(Collation(locale: locale).compare);
  print(
    'intl4x [NEW]:  Collation(${locale.toLanguageTag()}) sort -> '
    '$localeSorted',
  );
  print('');
}

/// 13. Case Mapping [NEW IN INTL4X]
void _exampleCaseMapping() {
  print('--- 13. Case Mapping [NEW IN INTL4X] ---');
  const upper = 'TICKET';
  const word = 'istanbul';

  // `package:intl` only provided `toBeginningOfSentenceCase()` for Turkish.
  final intlSentenceCase = intl.toBeginningOfSentenceCase(word, 'tr');
  print(
    'intl (before): toBeginningOfSentenceCase("istanbul", "tr") -> '
    '"$intlSentenceCase"',
  );

  // `intl4x` provides full locale-sensitive lower/uppercase mapping.
  final trLocale = Locale.parse('tr');
  final lowerTr = CaseMapping(locale: trLocale).toLowerCase(upper);
  final upperTr = CaseMapping(locale: trLocale).toUpperCase(word);
  print(
    'intl4x [NEW]:  CaseMapping(tr).toLowerCase("TICKET") -> "$lowerTr" '
    '(dotless i)',
  );
  print(
    'intl4x [NEW]:  CaseMapping(tr).toUpperCase("istanbul") -> "$upperTr" '
    '(dotted İ)',
  );
  print('');
}

/// 14. Calendar & First Day of Week [NEW IN INTL4X]
void _exampleCalendar(Locale locale) {
  print('--- 14. Calendar & First Day of Week [NEW IN INTL4X] ---');

  final firstDay = Weekday.firstDayOfWeek(locale);
  print(
    'intl4x [NEW]:  Weekday.firstDayOfWeek(${locale.toLanguageTag()}) -> '
    '$firstDay (ISO index ${firstDay.isoIndex})',
  );
  print('');
}

/// 15. Testing Behavior in `dart test`
void _exampleTestingBehavior() {
  print('--- 15. Testing in `dart test` ---');

  // BEFORE (intl): Tests run against real formatting, which can cause
  // brittle assertion failures when platform ICU or CLDR data changes
  // (e.g. narrow no-break space U+202F vs ASCII space).
  //
  // NOW (intl4x): In `dart test` (when `#test.declarer` is present), intl4x
  // disables real formatting by default and produces deterministic placeholder
  // strings such as `'$datetime//$locale'` and `'$number//$locale'` (and
  // `PluralRules.select()` always returns `other`).
  //
  // To opt into real formatting (e.g. for golden or screenshot tests), pass:
  //   dart test -Dintl4x.brittle_i18n_testing=true
  // or wrap specific test execution in a Zone with `#test.allowFormatting`:
  //   runZoned(() => ..., zoneValues: {#test.allowFormatting: true});
  //
  // IMPORTANT: Never use `runZoned` with `#test.allowFormatting` outside of
  // tests (e.g. in application or library production code).
  print(
    'intl4x (now):  Formatting returns deterministic placeholders '
    '(`\$datetime//\$locale`, `\$number//\$locale`) in `dart test` by default, '
    'and `PluralRules.select()` returns `other`. Opt in with '
    '`-Dintl4x.brittle_i18n_testing=true` or `#test.allowFormatting` inside '
    'tests only.',
  );
  print('');
}
