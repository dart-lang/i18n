// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../intl4x_test_checker.dart';
import '../options.dart';
import 'number_format_options.dart';

/// Number formatting functionality of the browser.
abstract class NumberFormat {
  final String locale;

  const NumberFormat(this.locale);

  String percent(
    Object number, {
    //General options
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    String? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  }) {
    return formatImpl(
      number,
      style: const PercentStyle(),
      localeMatcher: localeMatcher,
      signDisplay: signDisplay,
      notation: notation,
      useGrouping: useGrouping,
      numberingSystem: numberingSystem,
      roundingMode: roundingMode,
      trailingZeroDisplay: trailingZeroDisplay,
      minimumIntegerDigits: minimumIntegerDigits,
    );
  }

  String unit(
    Object number, {
    required Unit unit,
    UnitDisplay unitDisplay = UnitDisplay.short,
    //General options
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    String? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  }) {
    return formatImpl(
      number,
      unit: unit,
      unitDisplay: unitDisplay,
      style: UnitStyle(unit: unit),
      localeMatcher: localeMatcher,
      signDisplay: signDisplay,
      notation: notation,
      useGrouping: useGrouping,
      numberingSystem: numberingSystem,
      roundingMode: roundingMode,
      trailingZeroDisplay: trailingZeroDisplay,
      minimumIntegerDigits: minimumIntegerDigits,
      digits: digits,
    );
  }

  String currency(
    Object number, {
    required String currency,
    CurrencyDisplay currencyDisplay = CurrencyDisplay.symbol,
    CurrencySign currencySign = CurrencySign.standard,
    //General options
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    String? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  }) {
    return formatImpl(
      number,
      currency: currency,
      currencyDisplay: currencyDisplay,
      style: CurrencyStyle(currency: currency),
      localeMatcher: localeMatcher,
      signDisplay: signDisplay,
      notation: notation,
      useGrouping: useGrouping,
      numberingSystem: numberingSystem,
      roundingMode: roundingMode,
      trailingZeroDisplay: trailingZeroDisplay,
      minimumIntegerDigits: minimumIntegerDigits,
      digits: digits,
    );
  }

  String compact(
    Object number, {
    CompactDisplay compactDisplay = CompactDisplay.short,
    //General options
    Style style = const DecimalStyle(),
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    SignDisplay signDisplay = SignDisplay.auto,
    Grouping useGrouping = Grouping.auto,
    String? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  }) {
    return formatImpl(
      number,
      style: style,
      localeMatcher: localeMatcher,
      signDisplay: signDisplay,
      notation: CompactNotation(compactDisplay: compactDisplay),
      useGrouping: useGrouping,
      numberingSystem: numberingSystem,
      roundingMode: roundingMode,
      trailingZeroDisplay: trailingZeroDisplay,
      minimumIntegerDigits: minimumIntegerDigits,
      digits: digits,
    );
  }

  String format(
    Object number, {
    Style style = const DecimalStyle(),
    //General options
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    String? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  }) {
    if (isInTest) {
      return '$number//$locale';
    } else {
      return formatImpl(
        number,
        unitDisplay: UnitDisplay.short,
        style: style,
        currencyDisplay: CurrencyDisplay.symbol,
        localeMatcher: localeMatcher,
        signDisplay: signDisplay,
        notation: notation,
        useGrouping: useGrouping,
        numberingSystem: numberingSystem,
        roundingMode: roundingMode,
        trailingZeroDisplay: trailingZeroDisplay,
        minimumIntegerDigits: minimumIntegerDigits,
        digits: digits,
      );
    }
  }

  // TODO: make this not part of the API somehow, maybe by encapsulating in
  // another class?
  String formatImpl(
    Object number, {
    Style style = const DecimalStyle(),
    String? currency,
    CurrencyDisplay currencyDisplay = CurrencyDisplay.symbol,
    Unit? unit,
    UnitDisplay unitDisplay = UnitDisplay.short,
    //General options
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    String? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  });
}
