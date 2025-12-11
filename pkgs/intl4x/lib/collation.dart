// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Provides locale-sensitive string comparison.
///
/// Available either as an extension on [String], or through the
/// [Collation] class.
///
/// ```dart
/// import 'package:intl4x/collation.dart';
///
/// void main() {
///   print('a'.compareLocale('b')); // Prints -1
///   print('ä'.compareLocale('z', locale: Locale('de'))); // Prints -1
///   print('ä'.compareLocale('z', locale: Locale('sv'))); // Prints 1
///
///   final collation = Collation(locale: Locale('de'));
///   final list = ['a', 'ä', 'b'];
///   list.sort(collation.compare);
///   print(list); // Prints [a, b, ä]
/// }
/// ```
library;

import 'src/collation/collation.dart' show Collation;
import 'src/locale/locale.dart' show Locale;

export 'src/collation/collation.dart' show Collation;
export 'src/collation/collation_options.dart'
    show CaseFirst, Sensitivity, Usage;
export 'src/locale/locale.dart' show Locale;

extension CollationExt on String {
  /// Compares this string to [other] in a locale-dependent manner,
  /// following the conventions of a [Comparator].
  ///
  /// The result is negative if this string is ordered before [other],
  /// positive if this string is ordered after [other], and zero if
  /// this string and [other] are ordered equally.
  ///
  /// ```dart
  /// import 'package:intl4x/collation.dart';
  ///
  /// void main() {
  ///   print('a'.compareLocale('b')); // Prints -1
  ///   print('ä'.compareLocale('z', locale: Locale('de'))); // Prints -1
  ///   print('ä'.compareLocale('z', locale: Locale('sv'))); // Prints 1
  /// }
  /// ```
  ///
  /// For more options, use [Collation] directly.
  int compareLocale(String other, {Locale? locale}) =>
      Collation(locale: locale).compare(this, other);
}
