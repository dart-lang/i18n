// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../number_format.dart';

typedef ListStyle = Style;

class PluralRulesOptions {
  final Type type;
  final Digits? digits;
  final RoundingMode roundingMode;
  final int minimumIntegerDigits;
  final TrailingZeroDisplay trailingZeroDisplay;

  final LocaleMatcher localeMatcher;

  PluralRulesOptions({
    this.type = Type.cardinal,
    Digits? digits,
    this.roundingMode = RoundingMode.halfExpand,
    this.minimumIntegerDigits = 1,
    this.trailingZeroDisplay = TrailingZeroDisplay.auto,
    this.localeMatcher = LocaleMatcher.bestfit,
  }) : digits = NumberFormatOptions.getDigits(const DecimalStyle(), digits);

  PluralRulesOptions copyWith({
    Type? type,
    Digits? digits,
    RoundingMode? roundingMode,
    int? minimumIntegerDigits,
    TrailingZeroDisplay? trailingZeroDisplay,
    LocaleMatcher? localeMatcher,
  }) {
    return PluralRulesOptions(
      type: type ?? this.type,
      digits: digits ?? this.digits,
      roundingMode: roundingMode ?? this.roundingMode,
      minimumIntegerDigits: minimumIntegerDigits ?? this.minimumIntegerDigits,
      trailingZeroDisplay: trailingZeroDisplay ?? this.trailingZeroDisplay,
      localeMatcher: localeMatcher ?? this.localeMatcher,
    );
  }
}

/// The number type to use.
enum Type {
  /// For cardinal numbers (referring to the quantity of things): One, two,
  /// three, four, five, etc.
  cardinal,

  /// For ordinal numbers (referring to the ordering or ranking of things):
  /// "1st", "2nd", "3rd", etc.
  ordinal,
}
