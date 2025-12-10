// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart';
import '../locale/locale.dart' show Locale;
import '../options.dart' show NumberingSystem;
import '../test_checker.dart';
import 'number_format_impl.dart';
import 'number_format_options.dart';

/// Formats numbers according to locale-specific rules.
///
/// This class provides methods to format numbers, currencies, and percentages
/// based on the current locale and various formatting options.
///
/// Example:
///
/// ```dart
/// import 'package:intl4x/number_format.dart';
///
/// void main() {
///   print(NumberFormat.format(123456.789)); // Prints '123,456.789'
/// }
/// ```
class NumberFormat {
  final NumberFormatImpl _impl;

  /// Creates a [NumberFormat] instance with custom formatting options.
  ///
  /// * [locale]: The locale to use for formatting. Defaults to the system
  ///   locale.
  /// * [style]: The overall formatting style. Defaults to [DecimalStyle].
  /// * [currency]: The 3-letter ISO 4217 currency code (e.g., 'USD') for
  ///   currency formatting.
  /// * [signDisplay]: When to display the sign for the number. Defaults to
  ///   [SignDisplay.auto].
  /// * [notation]: The notation system to use. Defaults to [StandardNotation].
  /// * [useGrouping]: Whether to use grouping separators. Defaults to
  ///   [Grouping.auto].
  /// * [numberingSystem]: The numbering system to use (e.g., 'latn', 'arab').
  /// * [roundingMode]: The rounding strategy to use. Defaults to
  ///   [RoundingMode.halfExpand].
  /// * [trailingZeroDisplay]: When to display trailing zeros. Defaults to
  ///   [TrailingZeroDisplay.auto].
  /// * [minimumIntegerDigits]: The minimum number of integer digits to use.
  ///   Defaults to 1.
  /// * [digits]: Specifies the minimum and maximum number of fraction or
  ///   significant digits.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/number_format.dart';
  ///
  /// void main() {
  ///   print(NumberFormat(locale: Locale('de'), style: DecimalStyle(digits: FractionDigits(2, 2))).format(1234.567)); // Prints '1.234,57'
  /// }
  /// ```
  NumberFormat({
    Locale? locale,
    FormatStyle style = const DecimalStyle(),
    String? currency,
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    NumberingSystem? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  }) : _impl = NumberFormatImpl.build(
         locale ?? findSystemLocale(),
         NumberFormatOptions.custom(
           currency: currency,
           digits: digits,
           minimumIntegerDigits: minimumIntegerDigits,
           notation: notation,
           numberingSystem: numberingSystem,
           roundingMode: roundingMode,
           signDisplay: signDisplay,
           style: style,
           trailingZeroDisplay: trailingZeroDisplay,
           useGrouping: useGrouping,
         ),
       );

  /// Creates a [NumberFormat] instance for compact number formatting.
  ///
  /// Compact notation is a way to format numbers that are very large or very
  /// small in a more human-readable way, e.g., "1.2M" instead of "1,200,000".
  ///
  /// * [locale]: The locale to use for formatting. Defaults to the system
  ///   locale.
  /// * [compactDisplay]: The display style for compact notation. Defaults to
  ///   [CompactDisplay.short].
  /// * [style]: The overall formatting style. Defaults to [DecimalStyle].
  /// * [signDisplay]: When to display the sign for the number. Defaults to
  ///   [SignDisplay.auto].
  /// * [useGrouping]: Whether to use grouping separators. Defaults to
  ///   [Grouping.auto].
  /// * [numberingSystem]: The numbering system to use (e.g., 'latn', 'arab').
  /// * [roundingMode]: The rounding strategy to use. Defaults to
  ///   [RoundingMode.halfExpand].
  /// * [trailingZeroDisplay]: When to display trailing zeros. Defaults to
  ///   [TrailingZeroDisplay.auto].
  /// * [minimumIntegerDigits]: The minimum number of integer digits to use.
  ///   Defaults to 1.
  /// * [digits]: Specifies the minimum and maximum number of fraction or
  ///   significant digits.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/number_format.dart';
  ///
  /// void main() {
  ///   print(NumberFormat.compact().format(1234567)); // Prints '1.2M'
  /// }
  /// ```
  NumberFormat.compact({
    Locale? locale,
    CompactDisplay compactDisplay = CompactDisplay.short,
    //General options
    FormatStyle style = const DecimalStyle(),
    SignDisplay signDisplay = SignDisplay.auto,
    Grouping useGrouping = Grouping.auto,
    NumberingSystem? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  }) : _impl = NumberFormatImpl.build(
         locale ?? findSystemLocale(),
         NumberFormatOptions.compact(
           compactDisplay: compactDisplay,
           digits: digits,
           minimumIntegerDigits: minimumIntegerDigits,
           numberingSystem: numberingSystem,
           roundingMode: roundingMode,
           signDisplay: signDisplay,
           style: style,
           trailingZeroDisplay: trailingZeroDisplay,
           useGrouping: useGrouping,
         ),
       );

  /// Creates a [NumberFormat] instance for percent formatting.
  ///
  /// * [locale]: The locale to use for formatting. Defaults to the system
  ///   locale.
  /// * [signDisplay]: When to display the sign for the number. Defaults to
  ///   [SignDisplay.auto].
  /// * [notation]: The notation system to use. Defaults to [StandardNotation].
  /// * [useGrouping]: Whether to use grouping separators. Defaults to
  ///   [Grouping.auto].
  /// * [numberingSystem]: The numbering system to use (e.g., 'latn', 'arab').
  /// * [roundingMode]: The rounding strategy to use. Defaults to
  ///   [RoundingMode.halfExpand].
  /// * [trailingZeroDisplay]: When to display trailing zeros. Defaults to
  ///   [TrailingZeroDisplay.auto].
  /// * [minimumIntegerDigits]: The minimum number of integer digits to use.
  ///   Defaults to 1.
  /// * [digits]: Specifies the minimum and maximum number of fraction or
  ///   significant digits.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/number_format.dart';
  ///
  /// void main() {
  ///   print(NumberFormat.percent().format(0.5)); // Prints '50%'
  /// }
  /// ```
  NumberFormat.percent({
    Locale? locale,
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    NumberingSystem? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  }) : _impl = NumberFormatImpl.build(
         locale ?? findSystemLocale(),
         NumberFormatOptions.percent(
           digits: digits,
           minimumIntegerDigits: minimumIntegerDigits,
           numberingSystem: numberingSystem,
           roundingMode: roundingMode,
           signDisplay: signDisplay,
           trailingZeroDisplay: trailingZeroDisplay,
           useGrouping: useGrouping,
           notation: notation,
         ),
       );

  /// Creates a [NumberFormat] instance for currency formatting.
  ///
  /// * [locale]: The locale to use for formatting. Defaults to the system
  ///   locale.
  /// * [currency]: The 3-letter ISO 4217 currency code (e.g., 'USD') to use.
  ///   This is a required parameter.
  /// * [currencyDisplay]: How to display the currency. Defaults to
  ///   [CurrencyDisplay.symbol].
  /// * [currencySign]: When to display the currency sign. Defaults to
  ///   [CurrencySign.standard].
  /// * [signDisplay]: When to display the sign for the number. Defaults to
  ///   [SignDisplay.auto].
  /// * [notation]: The notation system to use. Defaults to [StandardNotation].
  /// * [useGrouping]: Whether to use grouping separators. Defaults to
  ///   [Grouping.auto].
  /// * [numberingSystem]: The numbering system to use (e.g., 'latn', 'arab').
  /// * [roundingMode]: The rounding strategy to use. Defaults to
  ///   [RoundingMode.halfExpand].
  /// * [trailingZeroDisplay]: When to display trailing zeros. Defaults to
  ///   [TrailingZeroDisplay.auto].
  /// * [minimumIntegerDigits]: The minimum number of integer digits to use.
  ///   Defaults to 1.
  /// * [digits]: Specifies the minimum and maximum number of fraction or
  ///   significant digits.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/number_format.dart';
  ///
  /// void main() {
  ///   print(NumberFormat.currency(currency: 'USD').format(123.45)); // Prints '$123.45'
  /// }
  /// ```
  NumberFormat.currency({
    Locale? locale,
    required String currency,
    CurrencyDisplay currencyDisplay = CurrencyDisplay.symbol,
    CurrencySign currencySign = CurrencySign.standard,
    //General options
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    NumberingSystem? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  }) : _impl = NumberFormatImpl.build(
         locale ?? findSystemLocale(),
         NumberFormatOptions.currency(
           currency: currency,
           currencyDisplay: currencyDisplay,
           currencySign: currencySign,
           digits: digits,
           minimumIntegerDigits: minimumIntegerDigits,
           notation: notation,
           numberingSystem: numberingSystem,
           roundingMode: roundingMode,
           signDisplay: signDisplay,
           trailingZeroDisplay: trailingZeroDisplay,
           useGrouping: useGrouping,
         ),
       );

  String format(Object number) {
    if (isInTest) {
      return '$number//${_impl.locale}';
    } else {
      return _impl.formatImpl(number);
    }
  }
}
