// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

export 'src/locale/locale.dart';
export 'src/plural_rules/plural_rules.dart' show PluralCategory, PluralRules;

/// The main class for all i18n calls, containing references to other
/// functions such as
/// * [numberFormat]
///
/// The functionalities are called through getters on an `Intl` instance, i.e.
/// ```dart
/// final numberFormat = Intl(
///   locale: Locale(language: 'en', country: 'US'),
/// ).numberFormat;
/// print(numberFormat.percent().format(0.5)); //prints 50%
/// ```
