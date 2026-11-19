[![package:intl4x](https://github.com/dart-lang/i18n/actions/workflows/intl4x.yml/badge.svg)](https://github.com/dart-lang/i18n/actions/workflows/intl4x.yml)
[![Pub](https://img.shields.io/pub/v/intl4x.svg)](https://pub.dev/packages/intl4x)
[![package publisher](https://img.shields.io/pub/publisher/intl4x.svg)](https://pub.dev/packages/intl4x/publisher)

# `intl4x`

A lightweight, modular library for internationalization (i18n) in Dart, providing locale-sensitive formatting, featuring:

* Formatting for dates, numbers, and lists. 
* Collation.
* Display names.
* Plural rules.

## Status - preview

This package has now moved from experimental to preview. We will not ship any breaking changes, but are still iterating on some components.
Please provide feedback via our [issue tracker](https://github.com/dart-lang/i18n/issues)!


## Backends

This library uses different backends on different platforms:

*   **ICU4X**: Wraps [ICU4X](https://github.com/unicode-org/icu4x) to provide i18n functionality on native platforms.
*   **ECMA / Browser**: Wraps the browser's built-in [`Intl`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl) functionalities for web-only applications, reducing bundle size.

### ICU4X Build Modes

When using the native ICU4X backend, `package:icu4x` uses `package:hooks` to locate or compile the native library. You can configure the build mode in your `pubspec.yaml` under `hooks.user_defines.icu4x`:

*   **`fetch` (default)**: Downloads a pre-built static or dynamic binary from ICU4X GitHub releases.
    ```yaml
    hooks:
      user_defines:
        icu4x:
          buildMode: fetch
    ```

*   **`local`**: Uses a locally available pre-built binary.
    ```yaml
    hooks:
      user_defines:
        icu4x:
          buildMode: local
          localPath: path/to/libicu_capi.so
    ```

*   **`checkout`**: Builds a fresh native library from a local git checkout of ICU4X, allowing custom locale data or component selection. This requires a Rust toolchain.
    ```yaml
    hooks:
      user_defines:
        icu4x:
          buildMode: checkout
          checkoutPath: path/to/icu4x
    ```

## Supported Locales

By default (in `fetch` mode), the precompiled ICU4X native backend includes CLDR data for 174 base locales (Modern, Moderate, and Basic coverage levels), expanding to ~570 regional and script variants (e.g. `en-US`, `de-DE`, `zh-Hans`, `ar-EG`, `pt-BR`). Locales not explicitly compiled into the dataset automatically fall back to parent locales, likely subtags, or root (`und`).

To include custom or additional locales, build ICU4X from source using [`buildMode: checkout`](#icu4x-build-modes). For details on generating custom data, see the [package:icu4x documentation](https://github.com/unicode-org/icu4x/tree/main/ffi/dart) and the [ICU4X Data Management Tutorial](https://github.com/unicode-org/icu4x/blob/main/tutorials/data-management.md).

## Installation

Add `intl4x` to your `pubspec.yaml`:

```shell
dart pub add intl4x
```

## Migration Guide from `package:intl`

For a runnable side-by-side comparison of `package:intl` and `package:intl4x` APIs, see [`example/intl_to_intl4x.dart`](example/intl_to_intl4x.dart).

Run the example locally (optionally passing a BCP-47 locale tag, defaulting to `en-US`):

```shell
dart run example/intl_to_intl4x.dart
dart run example/intl_to_intl4x.dart de-DE
```

### Migrating existing `package:intl` formatting APIs

* **Zero Async Initialization**: No `await initializeDateFormatting(...)` needed; formatting works synchronously out of the box with pre-bundled ICU4X data (native) or browser `Intl` (web).
* **Locale Handling**: Replace `String` tags (`'de_DE'`) with strongly-typed `Locale.parse('de-DE')`. Omit `locale:` to follow `Locale.system` (the OS or browser locale) rather than hardcoding `'en-US'`.
* **Number Formatting**: Replace `NumberFormat.decimalPattern()` with `NumberFormat(...)` (supported on both native and web). `NumberFormat.compact()`, `NumberFormat.percent()`, `NumberFormat.currency()`, and `UnitStyle` are supported on **web (ECMA)**; on native (ICU4X) they currently fall back to plain decimal formatting.
* **Date, Time & TimeZone Formatting**: Replace string patterns and skeleton factories (`DateFormat.yMMMMd()`, `DateFormat.yMMMd().add_jm()`) with typed constructors such as `DateTimeFormat.yearMonthDay(length: DateTimeLength.long, yearStyle: YearStyle.full)` and `DateTimeFormat.yearMonthDayTime(timePrecision: TimePrecision.minute)` (plus `.withTimeZoneLong()` / `.withTimeZoneShort()` for explicit IANA time zones). Use a full `intl4x` skeleton for localized output rather than combining localized pieces with manual layouts, and expect minor CLDR formatting updates (such as narrow no-break spaces `U+202F` before AM/PM, `" at "` connectors, or commas) compared to `package:intl`.

### What stays on `package:intl` (or moves to `package:convert`)

* **Translatable Messages (`Intl.message`, `Intl.plural`, `Intl.select`, `Intl.gender`)**: **Do not migrate messages to `intl4x` or `PluralRules`.** Message localization belongs to a translation pipeline (`package:intl` or `package:messages`). Rewriting `Intl.plural` into `PluralRules.select` removes strings from translation extraction and applies runtime plural rules to untranslated text.
* **Non-Localized / Fixed-Pattern Formatting & Parsing**: `intl4x` focuses strictly on locale-sensitive display formatting (the only parser it provides is `Locale.parse()`). For fixed machine-readable patterns (e.g. `yyyy-MM-dd`, `yyyyMMdd`, wire/log/API timestamps), use [`FixedDateTimeFormatter`](https://pub.dev/documentation/convert/latest/convert/FixedDateTimeFormatter-class.html) from `package:convert` (`encode`, `decode`, `tryDecode`). Use `DateTime.parse()` / `DateTime.tryParse()` for ISO-8601 strings and `num.tryParse()` / `int.tryParse()` / `double.tryParse()` for numbers.
* **Localized User-Input Parsing, BiDi, and Symbol Accessors**: `DateFormat.parse()` / `NumberFormat.parse()` on localized user input, `Bidi` / `BidiFormatter`, and low-level symbol tables (`currencySymbol`, `dateSymbols`) are not yet in `intl4x`; keep those on `package:intl`.

### New capabilities in `package:intl4x` (not in `package:intl`)

* **Plural Rules & Ordinals**: `PluralRules.select()` for low-level cardinal and ordinal plural category selection (non-message use cases, e.g. `1st`/`2nd`/`3rd`).
* **List Formatting**: Locale-aware conjunctions and disjunctions with `ListFormat` / `Iterable<String>.joinAnd()` / `joinOr()`.
* **Display Names (`@experimental`)**: Localized language/locale and region names with `DisplayNames`.
* **Locale-Aware Collation**: `Collation.compare` instead of UTF-16 `String.compareTo()`.
* **Locale-Aware Case Mapping**: `CaseMapping` / `toLocaleLowerCase()` / `toLocaleUpperCase()` (e.g. Turkish dotted `İ` and dotless `ı`).
* **Calendar & First Day of Week**: `package:intl4x/calendar.dart` (`Calendar`, `Weekday.firstDayOfWeek`).

### Testing in `dart test`

* Real formatting is disabled by default in `dart test` (detecting `#test.declarer`) to prevent brittle tests across CLDR and browser updates. Formatters return deterministic placeholder strings such as `'$datetime//$locale'` and `'$number//$locale'`, and `PluralRules.select()` always returns `other`.
* To opt into real formatting (e.g. for golden or screenshot tests), pass `-Dintl4x.brittle_i18n_testing=true` or wrap specific test execution in `runZoned(..., zoneValues: {#test.allowFormatting: true})`. Never use `runZoned` with `#test.allowFormatting` outside of tests (e.g. in production code).

## Limitations

There are still some features missing:

 * Compact, percent, unit, and currency formatting on native (ICU4X) — these work on web (ECMA).
 * Display names for calendar, currency, date time fields, and scripts (`DisplayNames` is currently `@experimental`).
 * Localized date/number parsing, message translation, and bidirectional text (`Bidi` / `BidiFormatter`).

## Features

### Date & Time Formatting

Format `DateTime` objects into locale-sensitive strings for dates, times, and time zones.

```dart
import 'package:intl4x/datetime_format.dart';

void main() {
  final dateTime = DateTime(2024, 7, 1, 8, 50, 07);
  final germanLocale = Locale.parse('de-DE');

  final formatter = DateTimeFormat.yearMonthDayTime(
    locale: germanLocale,
    length: DateTimeLength.long,
  ).withTimeZoneLong();

  // Format with a specific timezone
  print(formatter.format(dateTime, 'Europe/Berlin')); 
  // prints "1. Juli 2024 um 08:50:07 Mitteleuropäische Sommerzeit"
}
```

### Number Formatting

Format numbers as decimals, percentages, or in compact form with locale-specific rules.

```dart
import 'package:intl4x/number_format.dart';

void main() {
  final locale = Locale.parse('en-US');

  final compactFormat = NumberFormat.compact(locale: locale);
  print(compactFormat.format(12345)); // "12K"

  final percentFormat = NumberFormat.percent(locale: locale);
  print(percentFormat.format(0.987)); // "99%"
}
```

### Collation (String Sorting)

Sort lists of strings with locale-aware collation.

```dart
import 'package:intl4x/collation.dart';

void main() {
  final list = ['Z', 'a', 'z', 'ä'];
  final german = Collation(locale: Locale.parse('de-DE'));

  list.sort(german.compare);

  print(list); // prints "[a, ä, z, Z]"
}
```

### Display Names

Get localized display names for locales, regions, scripts, and currencies.

```dart
import 'package:intl4x/display_names.dart';

void main() {
  final displayNames = DisplayNames(locale: Locale.parse('en'));

  print(displayNames.ofLocale(Locale.parse('fr-CA'))); // "Canadian French"
  print(displayNames.ofRegion('419')); // "Latin America"
}
```

### List Formatting

Join lists of items into a grammatically correct, locale-sensitive string.

```dart
import 'package:intl4x/list_format.dart';

void main() {
  final list = ['apples', 'bananas', 'oranges'];
  final english = Locale.parse('en');
  
  print(list.joinAnd(locale: english)); // "apples, bananas, and oranges"
  print(list.joinOr(locale: english));  // "apples, bananas, or oranges"
}
```

### Plural Rules

Select the correct plural form for a given number based on locale rules.

```dart
import 'package:intl4x/plural_rules.dart';

void main() {
  final rules = PluralRules(
    locale: Locale.parse('en-US'),
    type: PluralType.ordinal,
  );

  String numberPlural(int i) => rules.select(i, one: 'st', two: 'nd', few: 'rd', other: 'th');

  print(numberPlural(1)); // 'st'
  print(numberPlural(2)); // 'nd'
  print(numberPlural(3)); // 'rd'
  print(numberPlural(4)); // 'th'
}
```

### Case Mapping

Change the case of strings according to locale-specific rules.

```dart
import 'package:intl4x/case_mapping.dart';

void main() {
  final tr = Locale.parse('tr');
  final en = Locale.parse('en');

  final upper = 'TICKET';
  print(upper.toLocaleLowerCase(en)); // ticket
  print(upper.toLocaleLowerCase(tr)); // tıcket
  
  final lower = 'i';
  print(lower.toLocaleUpperCase(en)); // I
  print(lower.toLocaleUpperCase(tr)); // İ
}
```