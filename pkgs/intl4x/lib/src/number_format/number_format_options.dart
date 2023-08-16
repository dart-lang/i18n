// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import '../options.dart';

typedef UnitDisplay = Style;

/// Number formatting functionality of the browser.
class NumberFormatOptions {
  final FormatStyle style;
  final String? currency;
  final CurrencyDisplay? currencyDisplay;
  final Unit? unit;
  final UnitDisplay? unitDisplay;
  //General options
  final LocaleMatcher localeMatcher;
  final SignDisplay signDisplay;
  final Notation notation;
  final Grouping useGrouping;
  final String? numberingSystem;
  final RoundingMode roundingMode;
  final TrailingZeroDisplay trailingZeroDisplay;
  final int minimumIntegerDigits;
  final Digits? digits;

  NumberFormatOptions.custom(
      //General options
      {this.style = const DecimalStyle(),
      this.currency,
      this.currencyDisplay,
      this.unit,
      this.unitDisplay,
      this.localeMatcher = LocaleMatcher.bestfit,
      this.signDisplay = SignDisplay.auto,
      this.notation = const StandardNotation(),
      this.useGrouping = Grouping.auto,
      this.numberingSystem,
      this.roundingMode = RoundingMode.halfExpand,
      this.trailingZeroDisplay = TrailingZeroDisplay.auto,
      this.minimumIntegerDigits = 1,
      Digits? digits})
      : digits = getDigits(style, digits);

  factory NumberFormatOptions.percent({
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
    return NumberFormatOptions.custom(
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

  factory NumberFormatOptions.unit({
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
    return NumberFormatOptions.custom(
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

  factory NumberFormatOptions.currency({
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
    return NumberFormatOptions.custom(
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

  factory NumberFormatOptions.compact({
    CompactDisplay compactDisplay = CompactDisplay.short,
    //General options
    FormatStyle style = const DecimalStyle(),
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    SignDisplay signDisplay = SignDisplay.auto,
    Grouping useGrouping = Grouping.auto,
    String? numberingSystem,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
    int minimumIntegerDigits = 1,
    Digits? digits,
  }) {
    return NumberFormatOptions.custom(
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

  NumberFormatOptions copyWith({
    FormatStyle? style,
    String? currency,
    CurrencyDisplay? currencyDisplay,
    Unit? unit,
    UnitDisplay? unitDisplay,
    LocaleMatcher? localeMatcher,
    SignDisplay? signDisplay,
    Notation? notation,
    Grouping? useGrouping,
    String? numberingSystem,
    RoundingMode? roundingMode,
    TrailingZeroDisplay? trailingZeroDisplay,
    int? minimumIntegerDigits,
    Digits? digits,
  }) {
    return NumberFormatOptions.custom(
      style: style ?? this.style,
      currency: currency ?? this.currency,
      currencyDisplay: currencyDisplay ?? this.currencyDisplay,
      unit: unit ?? this.unit,
      unitDisplay: unitDisplay ?? this.unitDisplay,
      localeMatcher: localeMatcher ?? this.localeMatcher,
      signDisplay: signDisplay ?? this.signDisplay,
      notation: notation ?? this.notation,
      useGrouping: useGrouping ?? this.useGrouping,
      numberingSystem: numberingSystem ?? this.numberingSystem,
      roundingMode: roundingMode ?? this.roundingMode,
      trailingZeroDisplay: trailingZeroDisplay ?? this.trailingZeroDisplay,
      minimumIntegerDigits: minimumIntegerDigits ?? this.minimumIntegerDigits,
      digits: digits ?? this.digits,
    );
  }
}

/// Control how many fraction digits to use in number formatting.
final class FractionDigits {
  final int? minimum;
  final int? maximum;

  //TODO: add checks dependent on style
  const FractionDigits({this.minimum, this.maximum})
      : assert(minimum != null ? 0 <= minimum && minimum <= 20 : true),
        assert(minimum != null && maximum != null ? minimum <= maximum : true);
}

final class SignificantDigits {
  final int minimum;
  final int maximum;

  SignificantDigits({this.minimum = 1, this.maximum = 21})
      : assert(1 <= minimum && minimum <= 21),
        assert(1 <= maximum && maximum <= 21),
        assert(minimum <= maximum);
}

enum TrailingZeroDisplay {
  auto,
  stripIfInteger;
}

enum RoundingPriority {
  auto,
  morePrecision,
  lessPrecision;
}

final class Digits {
  final (int? min, int? max)? fractionDigits;
  final (int? min, int? max)? significantDigits;
  final RoundingPriority? roundingPriority;
  final int? roundingIncrement;

  Digits._(
      {this.fractionDigits,
      this.significantDigits,
      this.roundingPriority,
      this.roundingIncrement});

  Digits.withIncrement(
    this.roundingIncrement, [
    int? fractionDigit,
  ])  : fractionDigits =
            fractionDigit != null ? (fractionDigit, fractionDigit) : null,
        significantDigits = null,
        roundingPriority = null;

  Digits.withFractionDigits({int? minimum, int? maximum})
      : fractionDigits = (minimum, maximum),
        significantDigits = null,
        roundingPriority = null,
        roundingIncrement = null;

  Digits.withSignificantDigits({
    int minimum = 1,
    int maximum = 21,
    this.roundingIncrement,
  })  : significantDigits = (minimum, maximum),
        fractionDigits = null,
        roundingPriority = null;

  Digits.withSignificantAndFractionDigits({
    int minimumSignificantDigits = 1,
    int maximumSignificantDigits = 21,
    int? minimumFractionDigits,
    int? maximumFractionDigits,
    this.roundingPriority = RoundingPriority.auto,
  })  : fractionDigits = (minimumFractionDigits, maximumFractionDigits),
        significantDigits =
            (minimumSignificantDigits, maximumSignificantDigits),
        roundingIncrement = null;

  Digits.all({
    required this.roundingIncrement,
    int minimumSignificantDigits = 1,
    int maximumSignificantDigits = 21,
    int? fractionDigit,
    this.roundingPriority = RoundingPriority.auto,
  })  : significantDigits =
            (minimumSignificantDigits, maximumSignificantDigits),
        fractionDigits =
            fractionDigit != null ? (fractionDigit, fractionDigit) : null;
}

enum RoundingMode {
  ceil,
  floor,
  expand,
  trunc,
  halfCeil,
  halfFloor,
  halfExpand,
  halfTrunc,
  halfEven;
}

enum Grouping {
  always,
  auto,
  never('false'),
  min2;

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Grouping([this._jsName]);
}

enum CompactDisplay {
  short,
  long;
}

enum CurrencyDisplay {
  symbol,
  narrowSymbol,
  code,
  name;
}

enum CurrencySign {
  standard,
  accounting;
}

enum SignDisplay {
  auto,
  always,
  exceptZero,
  negative,
  never;
}

enum Unit {
  acre,
  bit,
  byte,
  celsius,
  centimeter,
  day,
  degree,
  fahrenheit,
  fluidounce('fluid-ounce'),
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
  milescandinavian('mile-scandinavian'),
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
  year;

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Unit([this._jsName]);
}

sealed class Notation with HasName {
  const Notation();

  @override
  String get name;
}

final class CompactNotation extends Notation {
  final CompactDisplay compactDisplay;

  CompactNotation({this.compactDisplay = CompactDisplay.short});
  @override
  String get name => 'compact';
}

final class StandardNotation extends Notation {
  const StandardNotation();
  @override
  String get name => 'standard';
}

final class ScientificNotation extends Notation {
  @override
  String get name => 'scientific';
}

final class EngineeringNotation extends Notation {
  @override
  String get name => 'engineering';
}

sealed class FormatStyle with HasName {
  @override
  String get name;

  const FormatStyle();
}

final class DecimalStyle extends FormatStyle {
  const DecimalStyle();

  @override
  String get name => 'decimal';
}

final class CurrencyStyle extends FormatStyle {
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

final class PercentStyle extends FormatStyle {
  const PercentStyle();
  @override
  String get name => 'percent';
}

final class UnitStyle extends FormatStyle {
  final Unit unit;
  final UnitDisplay unitDisplay;

  const UnitStyle({
    required this.unit,
    this.unitDisplay = UnitDisplay.short,
  });
  @override
  String get name => 'unit';
}
