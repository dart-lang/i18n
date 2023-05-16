[![package:intl4x](https://github.com/dart-lang/i18n/actions/workflows/intl4x.yml/badge.svg)](https://github.com/dart-lang/i18n/actions/workflows/intl4x.yml)

A lightweight modular library for internationalization (i18n) functionality.

## Features
* Formatting for dates, numbers, and lists. (TODO)
* Collation. (TODO)

## Implementation
* Wraps around [ICU4X](https://github.com/unicode-org/icu4x) on native or web platforms. (TODO)
* Wraps around the built-in browser functionalities on the web.
    * Select which locales you want to use the browser for through an `EcmaPolicy`.

## Example
The functionalities are called through getters on an `Intl` instance, i.e.
```dart
final numberFormat = Intl(
  ecmaPolicy: const AlwaysEcma(),
  locale: 'en_US',
).numberFormat;
print(numberFormat.percent().format(0.5)); //prints 50%
```
