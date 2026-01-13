// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart' show findSystemLocale;
import '../locale/locale.dart' show Locale;
import '../test_checker.dart';
import 'collation_impl.dart';
import 'collation_options.dart';

/// Provides locale-sensitive string comparison.
final class Collation {
  final CollationImpl _collationImpl;

  /// Creates a new locale-sensitive string comparator.
  ///
  /// The comparison rules are configured using the provided parameters:
  ///
  /// * [locale]: The specific locale to use for comparison. If `null`, the
  ///   system's current locale is used.
  /// * [usage]: Specifies the primary intent for the comparison, either for
  ///   sorting a list or for searching within text (e.g., ignoring accents).
  ///   Defaults to [Usage.sort].
  /// * [sensitivity]: Determines the level of difference required for strings
  ///   to be considered unequal. For example, controlling whether only
  ///   base letters, accents, or case are considered. If `null`, the default
  ///   for the locale is used.
  /// * [ignorePunctuation]: If `true`, punctuation characters are ignored
  ///   during comparison. Defaults to `false`.
  /// * [numeric]: If `true`, treats sequences of digits as numerical values
  ///   for comparison (e.g., '10' comes after '2'). If `null`, the default
  ///   for the locale is used.
  /// * [caseFirst]: Specifies if upper- or lowercase letters should be
  ///   sorted first. If `null`, the default for the locale is used.
  /// * [collation]: A specific collation algorithm to use (e.g., 'phonebook'
  ///   or 'dictionary'). If `null`, the default collation for the locale is
  ///   used.
  Collation({
    Locale? locale,
    Usage usage = Usage.sort,
    Sensitivity? sensitivity,
    bool ignorePunctuation = false,
    bool? numeric,
    CaseFirst? caseFirst,
    String? collation,
  }) : _collationImpl = CollationImpl.build(
         locale ?? findSystemLocale(),
         CollationOptions(
           usage: usage,
           sensitivity: sensitivity,
           ignorePunctuation: ignorePunctuation,
           numeric: numeric,
           caseFirst: caseFirst,
           collation: collation,
         ),
       );

  /// Compare two strings in a locale-dependant manner.
  ///
  /// The [CollationOptions.usage] can specify whether to use this for searching
  /// for a string, or sorting a list of strings. The
  /// [CollationOptions.sensitivity] regulates how exact the comparison should
  /// be. Setting [CollationOptions.numeric] means that numbers are not sorted
  /// alphabetically, but by their value. The
  /// [CollationOptions.caseFirst] parameter sets if upper or lowercase letters
  /// should take preference.
  ///
  /// The return value is according to the [Comparable] interface.
  ///
  /// ```dart
  /// import 'package:intl4x/collation.dart';
  ///
  /// void main() {
  ///   final collation = Collation(locale: Locale.parse('de'));
  ///   final list = ['a', 'ä', 'b'];
  ///   list.sort(collation.compare);
  ///   print(list); // Prints [a, b, ä]
  /// }
  /// ```
  int compare(String a, String b) {
    if (isInTest) {
      return a.compareTo(b);
    } else {
      return _collationImpl.compareImpl(a, b);
    }
  }
}
