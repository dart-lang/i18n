// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';

import 'number_format_4x.dart';
import 'number_format_stub.dart' if (dart.library.js) 'number_format_ecma.dart';
import 'number_formatter.dart';

/// Number formatting functionality of the browser.
class NumberFormat {
  final Intl intl;

  const NumberFormat(this.intl);

  NumberFormatter percent({
    //General options
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    String? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    RoundingPriority? roundingPriority,
    int? roundingIncrement,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    FractionDigits? fractionDigits,
    SignificantDigits? significantDigits,
  }) {
    return custom(
      style: const PercentStyle(),
      localeMatcher: localeMatcher,
      signDisplay: signDisplay,
      notation: notation,
      useGrouping: useGrouping,
      numberingSystem: numberingSystem,
      roundingMode: roundingMode,
      roundingPriority: roundingPriority,
      roundingIncrement: roundingIncrement,
      trailingZeroDisplay: trailingZeroDisplay,
      minimumIntegerDigits: minimumIntegerDigits,
      fractionDigits: fractionDigits,
      significantDigits: significantDigits,
    );
  }

  NumberFormatter unit({
    required Unit unit,
    UnitDisplay unitDisplay = UnitDisplay.short,
    //General options
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    String? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    RoundingPriority? roundingPriority,
    int? roundingIncrement,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    FractionDigits? fractionDigits,
    SignificantDigits? significantDigits,
  }) {
    return custom(
      unit: unit,
      unitDisplay: unitDisplay,
      style: UnitStyle(unit: unit),
      localeMatcher: localeMatcher,
      signDisplay: signDisplay,
      notation: notation,
      useGrouping: useGrouping,
      numberingSystem: numberingSystem,
      roundingMode: roundingMode,
      roundingPriority: roundingPriority,
      roundingIncrement: roundingIncrement,
      trailingZeroDisplay: trailingZeroDisplay,
      minimumIntegerDigits: minimumIntegerDigits,
      fractionDigits: fractionDigits,
      significantDigits: significantDigits,
    );
  }

  NumberFormatter currency({
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
    RoundingPriority? roundingPriority,
    int? roundingIncrement,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    FractionDigits? fractionDigits,
    SignificantDigits? significantDigits,
  }) {
    return custom(
      currency: currency,
      currencyDisplay: currencyDisplay,
      style: CurrencyStyle(currency: currency),
      localeMatcher: localeMatcher,
      signDisplay: signDisplay,
      notation: notation,
      useGrouping: useGrouping,
      numberingSystem: numberingSystem,
      roundingMode: roundingMode,
      roundingPriority: roundingPriority,
      roundingIncrement: roundingIncrement,
      trailingZeroDisplay: trailingZeroDisplay,
      minimumIntegerDigits: minimumIntegerDigits,
      fractionDigits: fractionDigits,
      significantDigits: significantDigits,
    );
  }

  NumberFormatter compact({
    CompactDisplay compactDisplay = CompactDisplay.short,
    //General options
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    String? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    RoundingPriority? roundingPriority,
    int? roundingIncrement,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    FractionDigits? fractionDigits,
    SignificantDigits? significantDigits,
  }) {
    return custom(
      compactDisplay: compactDisplay,
      localeMatcher: localeMatcher,
      signDisplay: signDisplay,
      notation: notation,
      useGrouping: useGrouping,
      numberingSystem: numberingSystem,
      roundingMode: roundingMode,
      roundingPriority: roundingPriority,
      roundingIncrement: roundingIncrement,
      trailingZeroDisplay: trailingZeroDisplay,
      minimumIntegerDigits: minimumIntegerDigits,
      fractionDigits: fractionDigits,
      significantDigits: significantDigits,
    );
  }

  NumberFormatter custom({
    CompactDisplay? compactDisplay,
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
    RoundingPriority? roundingPriority,
    int? roundingIncrement,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    FractionDigits? fractionDigits,
    SignificantDigits? significantDigits,
  }) {
    var options = NumberFormatOptions(
      unit: unit,
      unitDisplay: unitDisplay,
      style: style,
      currency: currency,
      currencyDisplay: currencyDisplay,
      compactDisplay: compactDisplay,
      localeMatcher: localeMatcher,
      signDisplay: signDisplay,
      notation: notation,
      useGrouping: useGrouping,
      numberingSystem: numberingSystem,
      roundingMode: roundingMode,
      roundingPriority: roundingPriority,
      roundingIncrement: roundingIncrement,
      trailingZeroDisplay: trailingZeroDisplay,
      minimumIntegerDigits: minimumIntegerDigits,
      fractionDigits: fractionDigits,
      significantDigits: significantDigits,
    );
    if (intl.ecmaPolicy.useFor(intl.locale)) {
      return getNumberFormatter(intl, options);
    } else {
      return getNumberFormatter4X(intl, options);
    }
  }
}
