// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:icu4x/icu4x.dart' as icu;
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'number_format_impl.dart';
import 'number_format_options.dart';

NumberFormatImpl getNumberFormatter4X(
  Locale locale,
  NumberFormatOptions options,
) => NumberFormat4X(locale as Locale4x, options);

class NumberFormat4X extends NumberFormatImpl {
  final icu.DecimalFormatter _formatter;
  NumberFormat4X(Locale4x super.locale, super.options)
    : _formatter = icu.DecimalFormatter.withGroupingStrategy(
        locale.get4X,
        options.toX,
      );

  @override
  String formatImpl(Object number) {
    final fixedDecimal = _toDecimal(number);
    final format = _formatter.format(fixedDecimal);
    return format;
  }

  icu.Decimal _toDecimal(Object number) {
    final icu.Decimal fixedDecimal;
    fixedDecimal = switch (number) {
      final int i => icu.Decimal.fromInt(i),
      final double d => icu.Decimal.fromDoubleWithRoundTripPrecision(d),
      final String s => icu.Decimal.fromString(s),
      Object() => icu.Decimal.fromString(number.toString()),
    };
    fixedDecimal.applySignDisplay(options.signDisplay.toX);
    return _constructDouble(fixedDecimal);
  }

  icu.Decimal _constructDouble(icu.Decimal fixedDecimal) {
    fixedDecimal.padStart(options.minimumIntegerDigits);
    final minFractionDigits = options.digits?.fractionDigits.$1;
    final maxFractionDigits = options.digits?.fractionDigits.$2;
    final minSignificantDigits = options.digits?.significantDigits.$1;
    final maxSignificantDigits = options.digits?.significantDigits.$2;

    final overhead = fixedDecimal.length - (maxSignificantDigits ?? 0);
    final maxSignificantPosition = fixedDecimal.magnitudeStart + overhead;
    final maxFractionPosition = max(
      fixedDecimal.magnitudeStart,
      -(maxFractionDigits ?? 0),
    );

    final roundingPriority = options.digits?.roundingPriority;
    final bool? useSignificant;
    if (maxFractionDigits != null &&
        maxSignificantDigits != null &&
        roundingPriority != null) {
      useSignificant = switch (roundingPriority) {
        RoundingPriority.auto => true,
        RoundingPriority.morePrecision =>
          maxSignificantPosition < maxFractionPosition,
        RoundingPriority.lessPrecision =>
          maxSignificantPosition > maxFractionPosition,
      };
    } else {
      useSignificant = null;
    }

    if (minFractionDigits != null) {
      fixedDecimal.padEnd(-minFractionDigits);
    }
    if (maxFractionDigits != null && !(useSignificant ?? false)) {
      final int position;
      if (minFractionDigits != null) {
        position = min(maxFractionPosition, -minFractionDigits);
      } else {
        position = maxFractionPosition;
      }
      _roundDecimal(fixedDecimal, position);
    }
    if (minSignificantDigits != null &&
        fixedDecimal.length < minSignificantDigits) {
      final missingZeroes = minSignificantDigits - fixedDecimal.length;
      fixedDecimal.padEnd(fixedDecimal.magnitudeStart - missingZeroes);
    }
    if (maxSignificantDigits != null &&
        fixedDecimal.length > maxSignificantDigits &&
        (useSignificant ?? true)) {
      _roundDecimal(fixedDecimal, maxSignificantPosition);
    }
    return fixedDecimal;
  }

  void _roundDecimal(icu.Decimal fixedDecimal, int maxSignificantPosition) {
    final mode = switch (options.roundingMode) {
      RoundingMode.ceil => icu.DecimalSignedRoundingMode.ceil,
      RoundingMode.floor => icu.DecimalSignedRoundingMode.floor,
      RoundingMode.expand => icu.DecimalSignedRoundingMode.expand,
      RoundingMode.trunc => icu.DecimalSignedRoundingMode.trunc,
      RoundingMode.halfCeil => icu.DecimalSignedRoundingMode.halfCeil,
      RoundingMode.halfFloor => icu.DecimalSignedRoundingMode.halfFloor,
      RoundingMode.halfExpand => icu.DecimalSignedRoundingMode.halfExpand,
      RoundingMode.halfTrunc => icu.DecimalSignedRoundingMode.halfTrunc,
      RoundingMode.halfEven => icu.DecimalSignedRoundingMode.halfEven,
    };
    fixedDecimal.roundWithMode(maxSignificantPosition, mode);
  }
}

extension on SignDisplay {
  icu.DecimalSignDisplay get toX => switch (this) {
    SignDisplay.always => icu.DecimalSignDisplay.always,
    SignDisplay.never => icu.DecimalSignDisplay.never,
    SignDisplay.auto => icu.DecimalSignDisplay.auto,
    SignDisplay.exceptZero => icu.DecimalSignDisplay.exceptZero,
    SignDisplay.negative => icu.DecimalSignDisplay.negative,
  };
}

extension on NumberFormatOptions {
  icu.DecimalGroupingStrategy get toX => switch (useGrouping) {
    Grouping.always => icu.DecimalGroupingStrategy.always,
    Grouping.auto => icu.DecimalGroupingStrategy.auto,
    Grouping.never => icu.DecimalGroupingStrategy.never,
    Grouping.min2 => icu.DecimalGroupingStrategy.min2,
  };
}

extension on icu.Decimal {
  int get length => fractionLength + integerLength;
  int get fractionLength => max(0, -magnitudeStart);
  int get integerLength => max(0, magnitudeEnd + 1);
}
