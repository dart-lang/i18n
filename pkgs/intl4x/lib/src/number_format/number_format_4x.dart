// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';
import 'number_format.dart';
import 'number_format_options.dart';

NumberFormat getNumberFormatter4X(List<String> locale) => NumberFormat(
      locale,
      NumberFormat4X(locale),
    );

class NumberFormat4X extends NumberFormatImpl {
  NumberFormat4X(super.locale);

  @override
  String formatImpl(Object number,
      {Style style = const DecimalStyle(),
      String? currency,
      CurrencyDisplay currencyDisplay = CurrencyDisplay.symbol,
      Unit? unit,
      UnitDisplay unitDisplay = UnitDisplay.short,
      LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
      SignDisplay signDisplay = SignDisplay.auto,
      Notation notation = const StandardNotation(),
      Grouping useGrouping = Grouping.auto,
      String? numberingSystem,
      RoundingMode roundingMode = RoundingMode.halfExpand,
      TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
      int minimumIntegerDigits = 1,
      Digits? digits}) {
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
