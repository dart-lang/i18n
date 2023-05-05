// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';

import '../options.dart';
import 'number_format_4x.dart';
import 'number_format_stub.dart' if (dart.library.js) 'number_format_ecma.dart';
import 'number_formatter.dart';

/// Number formatting functionality of the browser.
class NumberFormat {
  final Intl _intl;

  const NumberFormat(this._intl);

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
    return _custom(
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
    return _custom(
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
    return _custom(
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
    return _custom(
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
    return _custom(
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

  String _custom(
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
  }) {
    var options = NumberFormatOptions(
      unit: unit,
      unitDisplay: unitDisplay,
      style: style,
      currency: currency,
      currencyDisplay: currencyDisplay,
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
    final NumberFormatter nf;
    if (_intl.ecmaPolicy.useFor(_intl.locale)) {
      nf = getNumberFormatter(_intl, options);
    } else {
      nf = getNumberFormatter4X(_intl, options);
    }
    return nf.format(number);
  }
}
