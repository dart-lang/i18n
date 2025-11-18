// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart';
import '../locale/locale.dart' show Locale;
import '../options.dart' show NumberingSystem;
import '../test_checker.dart';
import 'number_format_impl.dart';
import 'number_format_options.dart';

class NumberFormat {
  final NumberFormatImpl _impl;

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
