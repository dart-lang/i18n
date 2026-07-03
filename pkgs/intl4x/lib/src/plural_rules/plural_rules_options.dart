// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../number_format/number_format_options.dart';
import 'plural_rules.dart' show PluralRules;

export '../../number_format.dart'
    show Digits, RoundingMode, TrailingZeroDisplay;

/// Options for plural rules selection and number formatting in plural rules.
///
/// See [PluralRules] for more details.
class PluralRulesOptions {
  final PluralType type;
  final Digits? digits;
  final RoundingMode roundingMode;
  final int minimumIntegerDigits;
  final TrailingZeroDisplay trailingZeroDisplay;

  PluralRulesOptions({
    this.type = PluralType.cardinal,
    Digits? digits,
    this.roundingMode = RoundingMode.halfExpand,
    this.minimumIntegerDigits = 1,
    this.trailingZeroDisplay = TrailingZeroDisplay.auto,
  }) : digits = NumberFormatOptions.getDigits(const DecimalStyle(), digits);
}

/// The number type to use.
enum PluralType {
  /// For cardinal numbers (referring to the quantity of things): One, two,
  /// three, four, five, etc.
  cardinal,

  /// For ordinal numbers (referring to the ordering or ranking of things):
  /// "1st", "2nd", "3rd", etc.
  ordinal,
}
