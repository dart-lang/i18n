[![package:intl4x](https://github.com/dart-lang/i18n/actions/workflows/intl4x.yml/badge.svg)](https://github.com/dart-lang/i18n/actions/workflows/intl4x.yml)
[![Pub](https://img.shields.io/pub/v/intl4x.svg)](https://pub.dev/packages/intl4x)
[![package publisher](https://img.shields.io/pub/publisher/intl4x.svg)](https://pub.dev/packages/intl4x/publisher)

A lightweight modular library for internationalization (i18n) functionality.

## Features

* Formatting for dates, numbers, and lists. 
* Collation.
* Display names.

## Status - experimental

We're actively iterating on the API for this package (please provide feedback
via our [issue tracker](https://github.com/dart-lang/i18n/issues)).

|   | Number format  | List format  | Date format  | Collation  | Display names |
|---|:---:|:---:|:---:|:---:|:---:|
| **ECMA402 (web)** | :heavy_check_mark: | :heavy_check_mark: |   | :heavy_check_mark: |   |
| **ICU4X (web/native)**  |   |   |   |   |   | 

## Implementation and Goals

* Wraps around [ICU4X](https://github.com/unicode-org/icu4x) on native or web
  platforms.
* Wraps around the built-in browser functionalities on the web.
    * Select which locales you want to use the browser for through an `EcmaPolicy`.

## Example

The functionalities are called through getters on an `Intl` instance, i.e.

```dart
import 'package:intl4x/ecma_policy.dart';
import 'package:intl4x/intl4x.dart';
import 'package:intl4x/number_format.dart';

final numberFormat = Intl(
  ecmaPolicy: const AlwaysEcma(),
  defaultLocale: 'en_US',
).numberFormat(NumberFormatOptions.percent());

print(numberFormat.format(0.5)); // prints 50%
```
