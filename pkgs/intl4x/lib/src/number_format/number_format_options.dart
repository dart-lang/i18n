// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'number_formatter.dart';

class NumberFormatOptions {
  // Specific Options
  final CompactDisplay? compactDisplay;
  final Style style;
  final String? currency;
  final CurrencyDisplay currencyDisplay;
  final Unit? unit;
  final UnitDisplay unitDisplay;
  // General options
  final LocaleMatcher localeMatcher;
  final SignDisplay signDisplay;
  final Notation notation;
  final Grouping useGrouping;
  final String? numberingSystem;
  final RoundingMode roundingMode;
  final RoundingPriority? roundingPriority;
  final int? roundingIncrement;
  final TrailingZeroDisplay trailingZeroDisplay;
  final int minimumIntegerDigits;
  final FractionDigits? fractionDigits;
  final SignificantDigits? significantDigits;

  const NumberFormatOptions({
    this.unit,
    required this.unitDisplay,
    this.compactDisplay,
    required this.style,
    this.currency,
    required this.currencyDisplay,
    required this.localeMatcher,
    required this.notation,
    this.numberingSystem,
    required this.signDisplay,
    required this.useGrouping,
    required this.roundingMode,
    this.roundingPriority,
    this.roundingIncrement,
    required this.trailingZeroDisplay,
    required this.minimumIntegerDigits,
    this.fractionDigits,
    this.significantDigits,
  });
}

class FractionDigits {
  final int? minimum;
  final int? maximum;

  //TODO: add checks dependent on style
  const FractionDigits({this.minimum, this.maximum})
      : assert(minimum != null ? 0 <= minimum && minimum <= 20 : true);
}

class SignificantDigits {
  final int minimum;
  final int maximum;

  const SignificantDigits({this.minimum = 1, this.maximum = 21});
  //  {
  //   assert(1 <= minimum && minimum <= 21);
  //   assert(1 <= maximum && maximum <= 21);
  // }
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

enum UnitDisplay {
  long,
  short,
  narrow;
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

abstract class Notation {
  const Notation();
  String get name;
}

class CompactNotation extends Notation {
  final CompactDisplay compactDisplay;

  CompactNotation({this.compactDisplay = CompactDisplay.short});
  @override
  String get name => 'compact';
}

class StandardNotation extends Notation {
  const StandardNotation();
  @override
  String get name => 'standard';
}

class ScientificNotation extends Notation {
  @override
  String get name => 'scientific';
}

class EngineeringNotation extends Notation {
  @override
  String get name => 'engineering';
}

abstract class Style {
  String get name;

  const Style();
}

class DecimalStyle extends Style {
  const DecimalStyle();

  @override
  String get name => 'decimal';
}

class CurrencyStyle extends Style {
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

class PercentStyle extends Style {
  const PercentStyle();
  @override
  String get name => 'percent';
}

class UnitStyle extends Style {
  final Unit unit;
  final UnitDisplay unitDisplay;

  const UnitStyle({
    required this.unit,
    this.unitDisplay = UnitDisplay.short,
  });
  @override
  String get name => 'unit';
}
