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

## Backends

This library uses different backends on different platforms:

*   **ICU4X**: Wraps [ICU4X](https://github.com/unicode-org/icu4x) to provide i18n functionality on both native platforms.
*   **ECMA / Browser**: Wraps the browser's built-in [`Intl`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl) functionalities for web-only applications, reducing bundle size.

## Installation

Add `intl4x` to your `pubspec.yaml`:

```shell
dart pub add intl4x
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