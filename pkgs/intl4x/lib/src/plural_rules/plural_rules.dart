// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license can be found in the LICENSE file.

import '../find_locale.dart';
import '../locale/locale.dart' show Locale;
import '../test_checker.dart';
import 'plural_rules_impl.dart';
import 'plural_rules_options.dart';

/// Determines the correct plural category for a number based on a locale.
///
/// This can be used to select the correct localized string (e.g., "1 cat" vs.
/// "2 cat**s**").
final class PluralRules {
  final PluralRulesImpl _pluralRulesImpl;

  /// Creates a new plural rules selector.
  ///
  /// * [locale]: The locale defining the pluralization rules. If `null`, uses
  ///   the system locale.
  /// * [type]: Specifies if the rules are for **cardinal** numbers (counting,
  ///   e.g., '1 dog') or **ordinal** numbers (ordering, e.g., '1st', '2nd').
  ///   Defaults to [PluralType.cardinal].
  /// * Number formatting parameters ([digits], [roundingMode], etc.) configure
  ///   how the number is handled before applying the pluralization logic.
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

  /// Returns the appropriate [PluralCategory] for the given [number].
  ///
  /// Example for English (`en-US`):
  /// ```dart
  /// PluralRules(locale: Locale.parse('en-US'))
  ///   .select(1) == PluralCategory.one
  /// PluralRules(locale: Locale.parse('en-US'))
  ///   .select(2) == PluralCategory.other
  /// ```
  /// Example for a language like Polish (`pl`), which has a 'few' category:
  /// ```dart
  /// PluralRules(locale: Locale.parse('pl')).select(3) == PluralCategory.few
  /// ```
  PluralCategory select(num number) {
    if (isInTest) {
      return PluralCategory.other;
    } else {
      return _pluralRulesImpl.selectImpl(number);
    }
  }
}

/// Defines the locale-specific grammatical categories for plural forms.
enum PluralCategory { zero, one, two, few, many, other }
