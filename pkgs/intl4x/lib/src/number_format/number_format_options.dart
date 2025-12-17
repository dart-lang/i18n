// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import '../options.dart';

typedef UnitDisplay = Style;

/// Number formatting functionality of the browser.
final class NumberFormatOptions {
  final FormatStyle style;
  final String? currency;

  //General options
  final SignDisplay signDisplay;
  final Notation notation;
  final Grouping useGrouping;
  final NumberingSystem? numberingSystem;
  final RoundingMode roundingMode;
  final TrailingZeroDisplay trailingZeroDisplay;
  final int minimumIntegerDigits;
  final Digits? digits;

  NumberFormatOptions.custom({
    this.style = const DecimalStyle(),
    this.currency,
    this.signDisplay = SignDisplay.auto,
    this.notation = const StandardNotation(),
    this.useGrouping = Grouping.auto,
    this.numberingSystem,
    this.roundingMode = RoundingMode.halfExpand,
    this.trailingZeroDisplay = TrailingZeroDisplay.auto,
    this.minimumIntegerDigits = 1,
    Digits? digits,
  }) : digits = getDigits(style, digits);

  factory NumberFormatOptions.percent({
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    NumberingSystem? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  }) => NumberFormatOptions.custom(
    style: const PercentStyle(),
    signDisplay: signDisplay,
    notation: notation,
    useGrouping: useGrouping,
    numberingSystem: numberingSystem,
    roundingMode: roundingMode,
    trailingZeroDisplay: trailingZeroDisplay,
    minimumIntegerDigits: minimumIntegerDigits,
  );

  factory NumberFormatOptions.unit({
    required Unit unit,
    UnitDisplay unitDisplay = UnitDisplay.short,
    //General options
    SignDisplay signDisplay = SignDisplay.auto,
    Notation notation = const StandardNotation(),
    Grouping useGrouping = Grouping.auto,
    NumberingSystem? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  }) => NumberFormatOptions.custom(
    style: UnitStyle(unit: unit, unitDisplay: unitDisplay),
    signDisplay: signDisplay,
    notation: notation,
    useGrouping: useGrouping,
    numberingSystem: numberingSystem,
    roundingMode: roundingMode,
    trailingZeroDisplay: trailingZeroDisplay,
    minimumIntegerDigits: minimumIntegerDigits,
    digits: digits,
  );

  factory NumberFormatOptions.currency({
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
  }) => NumberFormatOptions.custom(
    currency: currency,
    style: CurrencyStyle(
      currency: currency,
      display: currencyDisplay,
      sign: currencySign,
    ),
    signDisplay: signDisplay,
    notation: notation,
    useGrouping: useGrouping,
    numberingSystem: numberingSystem,
    roundingMode: roundingMode,
    trailingZeroDisplay: trailingZeroDisplay,
    minimumIntegerDigits: minimumIntegerDigits,
    digits: digits,
  );

  factory NumberFormatOptions.compact({
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
  }) => NumberFormatOptions.custom(
    style: style,
    signDisplay: signDisplay,
    notation: CompactNotation(compactDisplay: compactDisplay),
    useGrouping: useGrouping,
    numberingSystem: numberingSystem,
    roundingMode: roundingMode,
    trailingZeroDisplay: trailingZeroDisplay,
    minimumIntegerDigits: minimumIntegerDigits,
    digits: digits,
  );

  static Digits? getDigits(FormatStyle style, Digits? digits) {
    final fractionDigits = digits?.fractionDigits;
    if (fractionDigits != null) {
      final int newMin;
      if (fractionDigits.$1 == null) {
        newMin = switch (style) {
          DecimalStyle() => 0,
          // TODO(mosum): get by ISO 4217 currency code list instead
          CurrencyStyle() => 2,
          PercentStyle() => 0,
          UnitStyle() => 0,
        };
      } else {
        newMin = fractionDigits.$1!;
      }
      final int newMax;
      if (fractionDigits.$2 == null) {
        newMax = switch (style) {
          DecimalStyle() => max(newMin, 3),
          // TODO(mosum): get by ISO 4217 currency code list instead
          CurrencyStyle() => max(newMin, 2),
          PercentStyle() => max(newMin, 0),
          UnitStyle() => max(newMin, 3),
        };
      } else {
        newMax = fractionDigits.$2!;
      }
      return Digits._(
        roundingIncrement: digits!.roundingIncrement,
        fractionDigits: (newMin, newMax),
        roundingPriority: digits.roundingPriority,
        significantDigits: digits.significantDigits,
      );
    }
    return digits;
  }
}

/// Control how many fraction digits to use in number formatting.
final class FractionDigits {
  /// The minimum number of fraction digits to use.
  final int? minimum;

  /// The maximum number of fraction digits to use.
  final int? maximum;

  //TODO: add checks dependent on style
  /// Creates a [FractionDigits] instance with optional minimum and maximum
  /// fraction digits.
  ///
  /// Both [minimum] and [maximum] must be between 0 and 20, inclusive.
  /// If both are provided, [minimum] must be less than or equal to [maximum].
  const FractionDigits({this.minimum, this.maximum})
    : assert(minimum != null ? 0 <= minimum && minimum <= 20 : true),
      assert(minimum != null && maximum != null ? minimum <= maximum : true);
}

final class SignificantDigits {
  /// The minimum number of significant digits to use.
  final int minimum;

  /// The maximum number of significant digits to use.
  final int maximum;

  /// Creates a [SignificantDigits] instance with optional minimum and maximum
  /// significant digits.
  ///
  /// Both [minimum] and [maximum] must be between 1 and 21, inclusive.
  /// [minimum] must be less than or equal to [maximum].
  SignificantDigits({this.minimum = 1, this.maximum = 21})
    : assert(1 <= minimum && minimum <= 21),
      assert(1 <= maximum && maximum <= 21),
      assert(minimum <= maximum);
}

enum TrailingZeroDisplay {
  /// Auto trailing zero display.
  auto,

  /// Strip trailing zeros if the number is an integer.
  stripIfInteger,
}

enum RoundingPriority {
  /// Auto rounding priority.
  auto,

  /// Prioritize more precision.
  morePrecision,

  /// Prioritize less precision.
  lessPrecision,
}

final class Digits {
  final (int? min, int? max) fractionDigits;

  final (int? min, int? max) significantDigits;

  final RoundingPriority? roundingPriority;

  final int? roundingIncrement;

  const Digits._({
    required this.fractionDigits,
    required this.significantDigits,
    required this.roundingPriority,
    required this.roundingIncrement,
  });

  const Digits.withFractionDigits({
    int? minimum,
    int? maximum,
    this.roundingIncrement,
  }) : fractionDigits = (minimum, maximum),
       significantDigits = (null, null),
       roundingPriority = null,
       assert(
         roundingIncrement == null ||
             ((minimum != null || maximum != null) || minimum == maximum),
       ),
       assert((minimum == null || maximum == null) || minimum <= maximum);

  const Digits.withSignificantDigits({int? minimum = 1, int? maximum = 21})
    : fractionDigits = (null, null),
      significantDigits = (minimum, maximum),
      roundingPriority = null,
      roundingIncrement = null;

  const Digits.withSignificantAndFractionDigits({
    int? minimumSignificantDigits = 1,
    int? maximumSignificantDigits = 21,
    int? minimumFractionDigits,
    int? maximumFractionDigits,
    this.roundingPriority = RoundingPriority.auto,
  }) : fractionDigits = (minimumFractionDigits, maximumFractionDigits),
       significantDigits = (minimumSignificantDigits, maximumSignificantDigits),
       roundingIncrement = null;
}

enum RoundingMode {
  /// Round toward **positive infinity** (equivalent to Math.ceil()).
  ///
  /// Example: 2.1 -> 3, -2.1 -> -2.
  ceil,

  /// Round toward **negative infinity** (equivalent to Math.floor()).
  ///
  /// Example: 2.1 -> 2, -2.1 -> -3.
  floor,

  /// Round **away from zero** (increases magnitude).
  /// Equivalent to rounding up for positive numbers and rounding down
  /// for negative numbers.
  ///
  /// Example: 2.1 -> 3, -2.1 -> -3.
  expand,

  /// Round **toward zero** (decreases magnitude, equivalent to truncation).
  /// Equivalent to rounding down for positive numbers and rounding up for
  /// negative numbers.
  ///
  /// Example: 2.1 -> 2, -2.1 -> -2.
  trunc,

  /// Round to the nearest neighbor. If equidistant (e.g., fractional part is
  /// .5), round toward **positive infinity** (standard "round half up" for
  /// positive numbers).
  ///
  /// Example: 2.5 -> 3, -2.5 -> -2.
  halfCeil,

  /// Round to the nearest neighbor. If equidistant,
  /// round toward **negative infinity**.
  ///
  /// Example: 2.5 -> 2, -2.5 -> -3.
  halfFloor,

  /// Round to the nearest neighbor. If equidistant,
  /// round **away from zero** (increases magnitude). This is the "commercial"
  /// rounding rule.
  ///
  /// Example: 2.5 -> 3, -2.5 -> -3.
  halfExpand,

  /// Round to the nearest neighbor. If equidistant,
  /// round **toward zero** (decreases magnitude).
  ///
  /// Example: 2.5 -> 2, -2.5 -> -2.
  halfTrunc,

  /// Round to the nearest neighbor. If equidistant,
  /// round to the **even** neighbor (IEEE 754 "Round Half to Even"). This
  /// prevents statistical bias.
  ///
  /// Example: 2.5 -> 2, 3.5 -> 4.
  halfEven,
}

enum Grouping {
  /// Always use grouping separators.
  always(true),

  /// Use grouping separators automatically based on the locale.
  auto,

  /// Never use grouping separators.
  never(false),

  /// Use grouping separators if there are at least 2 digits in a group.
  min2;

  Object get jsName => _jsName ?? name;

  final bool? _jsName;

  const Grouping([this._jsName]);
}

enum CompactDisplay {
  /// Use short compact notation (e.g., "1.2K").
  short,

  /// Use long compact notation (e.g., "1.2 thousand").
  long,
}

enum CurrencyDisplay {
  /// Use the currency symbol (e.g., "$").
  symbol,

  /// Use the narrow currency symbol (e.g., "$").
  narrowSymbol,

  /// Use the ISO currency code (e.g., "USD").
  code,

  /// Use the long currency name (e.g., "US dollars").
  name,
}

enum CurrencySign {
  /// Display the currency sign according to standard practice.
  standard,

  /// Display the currency sign using accounting conventions (e.g., parentheses
  /// for negative values).
  accounting,
}

enum SignDisplay {
  /// Display the sign only when required.
  auto,

  /// Always display the sign.
  always,

  /// Display the sign except for zero.
  exceptZero,

  /// Display the sign only for negative numbers.
  negative,

  /// Never display the sign.
  never,
}

/// Represents various measurement units.
enum Unit {
  acre,
  bit,
  byte,
  celsius,
  centimeter,
  day,
  degree,
  fahrenheit,
  fluidOunce,
  foot,
  gallon,
  gigabit,
  gigabyte,
  gram,
  hectare,
  hour,
  inch,
  kilobit,
  kilobyte,
  kilogram,
  kilometer,
  liter,
  megabit,
  megabyte,
  meter,
  mile,
  scandinavianMile,
  milliliter,
  millimeter,
  millisecond,
  minute,
  month,
  ounce,
  percent,
  petabyte,
  pound,
  second,
  stone,
  terabit,
  terabyte,
  week,
  yard,
  year,
}

/// Base class for different notation styles.
sealed class Notation {
  const Notation();

  String get name;
}

/// Compact notation, used for formatting large numbers in a shorter form
/// (e.g., 1,000,000 as "1M").
final class CompactNotation extends Notation {
  final CompactDisplay compactDisplay;

  CompactNotation({this.compactDisplay = CompactDisplay.short});
  @override
  String get name => 'compact';
}

/// Standard notation (e.g., 1,000,000).
final class StandardNotation extends Notation {
  const StandardNotation();
  @override
  String get name => 'standard';
}

/// Scientific notation (e.g., 1.23E6).
final class ScientificNotation extends Notation {
  @override
  String get name => 'scientific';
}

/// Engineering notation (e.g., 1.23e+006).
final class EngineeringNotation extends Notation {
  @override
  String get name => 'engineering';
}

/// Base class for different formatting styles.
sealed class FormatStyle {
  String get name;

  const FormatStyle();
}

/// Formats a number as a decimal.
final class DecimalStyle extends FormatStyle {
  const DecimalStyle();

  @override
  String get name => 'decimal';
}

/// Formats a number as a currency.
final class CurrencyStyle extends FormatStyle {
  /// The currency code (e.g., 'USD').
  final String currency;

  final CurrencySign sign;

  final CurrencyDisplay display;

  CurrencyStyle({
    required this.currency,
    this.sign = CurrencySign.standard,
    this.display = CurrencyDisplay.symbol,
  });
  @override
  String get name => 'currency';
}

/// Formats a number as a percentage.
final class PercentStyle extends FormatStyle {
  const PercentStyle();
  @override
  String get name => 'percent';
}

/// Formats a number with a unit.
final class UnitStyle extends FormatStyle {
  final Unit unit;

  final UnitDisplay unitDisplay;

  const UnitStyle({required this.unit, this.unitDisplay = UnitDisplay.short});
  @override
  String get name => 'unit';
}
