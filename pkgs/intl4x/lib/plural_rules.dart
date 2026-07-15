// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The appropriate locale-dependent plural form.
///
/// The [PluralRules] object selects a localized value based on input [num]
/// using [PluralRules.select]. While English only uses 'one' and 'other', other
/// languages have more plural forms. For example, Arabic uses 'zero', 'one',
/// 'two', 'few', 'many', and 'other'.
///
/// Example:
/// ```dart
/// import 'package:intl4x/plural_rules.dart';
///
/// void main() {
///   final rules = PluralRules(locale: Locale.parse('en-US'));
///   print(rules.select(3, one: 'item', other: 'items')); // prints 'items'
/// }
/// ```
///@docImport 'src/plural_rules/plural_rules.dart';
library;

export 'src/locale/locale.dart' show Locale;
export 'src/plural_rules/plural_rules.dart' show PluralRules;
export 'src/plural_rules/plural_rules_options.dart'
    show Digits, PluralType, RoundingMode, TrailingZeroDisplay;
