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
/// {@example ../example/docs/plural_rules.dart#plural_rules}
/// @docImport 'src/plural_rules/plural_rules.dart';
library;

export 'src/locale/locale.dart' show Locale;
export 'src/plural_rules/plural_rules.dart' show PluralRules;
export 'src/plural_rules/plural_rules_options.dart'
    show Digits, PluralType, RoundingMode, TrailingZeroDisplay;
