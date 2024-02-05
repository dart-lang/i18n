// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import '../bindings/lib.g.dart' as icu;
import '../data.dart';
import '../data_4x.dart';
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'number_format_impl.dart';
import 'number_format_options.dart';

NumberFormatImpl getNumberFormatter4X(
        Locale locale, Data data, NumberFormatOptions options) =>
    NumberFormat4X(locale, data, options);

class NumberFormat4X extends NumberFormatImpl {
  final icu.FixedDecimalFormatter _formatter;
  NumberFormat4X(super.locale, Data data, super.options)
      : _formatter = icu.FixedDecimalFormatter.withGroupingStrategy(
          data.to4X(),
          locale.to4X(),
          options.groupingStrategy4X(),
        );

  @override
  String formatImpl(Object number) {
    final fixedDecimal = _toFixedDecimal(number);
    final format = _formatter.format(fixedDecimal);
    return format;
  }

  icu.FixedDecimal _toFixedDecimal(Object number) {
    final icu.FixedDecimal fixedDecimal;
    fixedDecimal = switch (number) {
      final int i => icu.FixedDecimal.fromInt(i),
      final double d => icu.FixedDecimal.fromDoubleWithDoublePrecision(d),
      final String s => icu.FixedDecimal.fromString(s),
      Object() => icu.FixedDecimal.fromString(number.toString()),
    };
    return _constructDouble(fixedDecimal);
  }

  icu.FixedDecimal _constructDouble(icu.FixedDecimal fixedDecimal) {
    fixedDecimal.padStart(options.minimumIntegerDigits);
    final minFractionDigits = options.digits?.fractionDigits.$1;
    final maxFractionDigits = options.digits?.fractionDigits.$2;
    final minSignificantDigits = options.digits?.significantDigits.$1;
    final maxSignificantDigits = options.digits?.significantDigits.$2;

    final overhead = fixedDecimal.length - (maxSignificantDigits ?? 0);
    final maxSignificantPosition = fixedDecimal.magnitudeStart + overhead;
    final maxFractionPosition =
        max(fixedDecimal.magnitudeStart, -(maxFractionDigits ?? 0));

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
      _roundDecimal(fixedDecimal, maxFractionPosition);
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

  void _roundDecimal(
      icu.FixedDecimal fixedDecimal, int maxSignificantPosition) {
    final roundingFunction = switch (options.roundingMode) {
      RoundingMode.ceil => fixedDecimal.ceil,
      RoundingMode.floor => fixedDecimal.floor,
      RoundingMode.expand => fixedDecimal.expand,
      RoundingMode.trunc => fixedDecimal.trunc,
      RoundingMode.halfCeil => fixedDecimal.halfCeil,
      RoundingMode.halfFloor => fixedDecimal.halfFloor,
      RoundingMode.halfExpand => fixedDecimal.halfExpand,
      RoundingMode.halfTrunc => fixedDecimal.halfTrunc,
      RoundingMode.halfEven => fixedDecimal.halfEven,
    };
    roundingFunction(maxSignificantPosition);
  }
}

extension on NumberFormatOptions {
  icu.FixedDecimalGroupingStrategy groupingStrategy4X() =>
      switch (useGrouping) {
        Grouping.always => icu.FixedDecimalGroupingStrategy.always,
        Grouping.auto => icu.FixedDecimalGroupingStrategy.auto,
        Grouping.never => icu.FixedDecimalGroupingStrategy.never,
        Grouping.min2 => icu.FixedDecimalGroupingStrategy.min2,
      };
}

extension on icu.FixedDecimal {
  int get length => fractionLength + integerLength;
  int get fractionLength => max(0, -magnitudeStart);
  int get integerLength => max(0, magnitudeEnd + 1);
}
