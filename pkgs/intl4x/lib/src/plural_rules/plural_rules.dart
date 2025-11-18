// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart';
import '../locale/locale.dart' show Locale;
import '../test_checker.dart';
import 'plural_rules_impl.dart';
import 'plural_rules_options.dart';

class PluralRules {
  final PluralRulesImpl _pluralRulesImpl;

  PluralRules({
    Locale? locale,
    PluralType type = PluralType.cardinal,
    Digits? digits,
    RoundingMode roundingMode = RoundingMode.halfExpand,
    int minimumIntegerDigits = 1,
    TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
  }) : _pluralRulesImpl = PluralRulesImpl.build(
         locale ?? findSystemLocale(),
         PluralRulesOptions(
           digits: digits,
           minimumIntegerDigits: minimumIntegerDigits,
           roundingMode: roundingMode,
           trailingZeroDisplay: trailingZeroDisplay,
           type: type,
         ),
       );

  /// Locale-dependant pluralization, for example in English:
  ///
  /// select(2) == PluralCategory.other
  PluralCategory select(num number) {
    if (isInTest) {
      return PluralCategory.other;
    } else {
      return _pluralRulesImpl.selectImpl(number);
    }
  }
}

enum PluralCategory { zero, one, two, few, many, other }
