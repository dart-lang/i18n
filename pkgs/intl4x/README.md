[![package:intl4x](https://github.com/dart-lang/i18n/actions/workflows/intl4x.yml/badge.svg)](https://github.com/dart-lang/i18n/actions/workflows/intl4x.yml)
[![Pub](https://img.shields.io/pub/v/intl4x.svg)](https://pub.dev/packages/intl4x)
[![package publisher](https://img.shields.io/pub/publisher/intl4x.svg)](https://pub.dev/packages/intl4x/publisher)

A lightweight modular library for internationalization (i18n) functionality.

## Features

* Formatting for dates, numbers, and lists. 
* Collation.
* Display names.
* Plural rules.

## Status - experimental

We're actively iterating on the API for this package (please provide feedback
via our [issue tracker](https://github.com/dart-lang/i18n/issues)).

|   | Number format | List format | Date format | Collation | Display names | Plural rules | Case mapping |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **ECMA402 (web)** | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ |
| **ICU4X (web/native)**  | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ |

## Implementation and Goals

* Wraps around [ICU4X](https://github.com/unicode-org/icu4x) on native or web
  platforms.
* Wraps around the built-in browser functionalities on the web.
    * Select which locales you want to use the browser for through an ``.

## Example

The functionalities are called through getters on an `Intl` instance, i.e.

```dart
import 'package:intl4x/number_format.dart';

void main() {
  final numberFormat = NumberFormat.percent(locale: Locale.parse('en-US'));

  print(numberFormat.format(0.5)); // prints 50%
}
```

## Installation

The easiest setup is 
```
dart pub add intl4x
dart run ...
```
This will download the binaries from Github

## Limitations

There are still some features missing:

 * Compact, percent, unit, and currency formatting.
 * Display names for calendar, currency, date time fields, and scripts.
