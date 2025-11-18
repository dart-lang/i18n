// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart' show findSystemLocale;
import '../locale/locale.dart' show Locale;
import '../test_checker.dart';
import 'collation_impl.dart';
import 'collation_options.dart';

class Collation {
  final CollationImpl _collationImpl;

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
  /// alphbetically, but by their value. The
  /// [CollationOptions.caseFirst] parameter sets if upper or lowercase letters
  /// should take preference.
  ///
  /// The return value is according to the [Comparable] interface.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'ä', 'à'].sort(Collation().compare);
  /// ```
  int compare(String a, String b) {
    if (isInTest) {
      return a.compareTo(b);
    } else {
      return _collationImpl.compareImpl(a, b);
    }
  }
}
