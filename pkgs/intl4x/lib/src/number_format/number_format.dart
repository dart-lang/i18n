// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';

import 'number_format_4x.dart';
import 'number_format_stub.dart' if (dart.library.js) 'number_format_ecma.dart';
import 'number_formatter.dart';

class NumberFormat {
  final Intl intl;

  const NumberFormat(this.intl);

  NumberFormatter percent() {
    return custom(style: PercentStyle());
  }

  NumberFormatter unit(Unit unit) {
    return custom(style: UnitStyle(unit: unit));
  }

  NumberFormatter custom({
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    SignDisplay signDisplay = SignDisplay.auto,
    Style style = const DecimalStyle(),
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
      localeMatcher: localeMatcher,
      signDisplay: signDisplay,
      style: style,
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
