// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
          options.to4xOptions(),
        );

  @override
  String formatImpl(Object number) =>
      _formatter.format(_toFixedDecimal(number));

  icu.FixedDecimal _toFixedDecimal(Object number) {
    final icu.FixedDecimal fixedDecimal;
    fixedDecimal = switch (number) {
      final int i => icu.FixedDecimal.fromInt(i),
      final double d => icu.FixedDecimal.fromDoubleWithDoublePrecision(d),
      final String s => icu.FixedDecimal.fromString(s),
      Object() => icu.FixedDecimal.fromString(number.toString()),
    };
    return fixedDecimal;
  }
}

extension on NumberFormatOptions {
  icu.FixedDecimalGroupingStrategy to4xOptions() => switch (useGrouping) {
        Grouping.always => icu.FixedDecimalGroupingStrategy.always,
        Grouping.auto => icu.FixedDecimalGroupingStrategy.auto,
        Grouping.never => icu.FixedDecimalGroupingStrategy.never,
        Grouping.min2 => icu.FixedDecimalGroupingStrategy.min2,
      };
}
