[![package:intl4x](https://github.com/dart-lang/i18n/actions/workflows/intl4x.yml/badge.svg)](https://github.com/dart-lang/i18n/actions/workflows/intl4x.yml)
[![Pub](https://img.shields.io/pub/v/intl4x.svg)](https://pub.dev/packages/intl4x)
[![package publisher](https://img.shields.io/pub/publisher/intl4x.svg)](https://pub.dev/packages/intl4x/publisher)

# `intl4x`

A lightweight, modular library for internationalization (i18n) in Dart, providing locale-sensitive formatting, featuring:

* Formatting for dates, numbers, and lists. 
* Collation.
* Display names.
* Plural rules.

## Status - experimental

We're actively iterating on the API for this package. Please provide feedback via our [issue tracker](https://github.com/dart-lang/i18n/issues).

This package currently increases binary size in non-web builds significantly. To remedy, compile your app the experimental flag `record-use`
```bash
dart --enable-experiment=record-use build cli --target my-binary-name.dart
```


## Backends

This library uses different backends on different platforms:

*   **ICU4X**: Wraps [ICU4X](https://github.com/unicode-org/icu4x) to provide i18n functionality on both native platforms.
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
          localPath: path/to/libicu4x.so
    ```

*   **`checkout`**: Builds a fresh native library from a local git checkout of ICU4X, allowing custom locale data or component selection.
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

For a comprehensive side-by-side comparison of `package:intl` and `package:intl4x` APIs, see [`example/intl_vs_intl4x.dart`](example/intl_vs_intl4x.dart).

It demonstrates how to perform common internationalization tasks in `intl` vs. `intl4x`:
* **Locale Handling**: `String` tags (`de_DE`) vs. strongly-typed `Locale.parse('de-DE')`.
* **Number & Currency Formatting**: `NumberFormat.decimalPattern()` / `currency()` vs. `NumberFormat(...)` / `currency()`.
* **Compact Number & Unit Formatting**: `NumberFormat.compact()` and `UnitStyle` (e.g. `Unit.meter`).
* **Date & Time Formatting**: `DateFormat.yMMMMd()` vs. typed `DateTimeFormat.yearMonthDay()`.
* **Plural Rules**: Message-based `Intl.plural()` vs. CLDR category selection via `PluralRules.select()`.
* **List Formatting**: Manual `String` joining vs. `ListFormat` / `joinAnd()`.
* **Display Names**: Localized language/region names with `DisplayNames`.
* **Locale-Aware Collation**: `String.compareTo()` vs. `Collation`.
* **Locale-Aware Case Mapping**: `String.toLowerCase()` vs. `CaseMapping` (e.g. Turkish dotless `i`).

Run the example locally with:
```shell
dart run example/intl_vs_intl4x.dart
```


## Limitations

There are still some features missing:

 * Compact, percent, unit, and currency formatting.
 * Display names for calendar, currency, date time fields, and scripts.

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
  // prints "1. Juli 2024 um 10:50:07 Mitteleuropäische Sommerzeit"
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

Select the correct plural category for a given number based on locale rules (e.g., `one`, `few`, `many`).

```dart
import 'package:intl4x/plural_rules.dart';

void main() {
  final rules = PluralRules(
    locale: Locale.parse('en-US'),
    type: PluralType.ordinal,
  );

  print(rules.select(1)); // PluralCategory.one (st)
  print(rules.select(2)); // PluralCategory.two (nd)
  print(rules.select(3)); // PluralCategory.few (rd)
  print(rules.select(4)); // PluralCategory.other (th)
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