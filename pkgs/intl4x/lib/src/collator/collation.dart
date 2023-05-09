// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../ecma/ecma_policy.dart';
import '../locale.dart';
import '../options.dart';
import '../test_checker.dart';
import '../utils.dart';
import 'collation_4x.dart';
import 'collation_options.dart';
import 'collation_stub.dart' if (dart.library.js) 'collation_ecma.dart';

class Collation {
  final CollationImpl _collationImpl;

  const Collation(this._collationImpl);

  /// Factory to get the correct implementation, either calling on ICU4X or the
  /// in-built browser implementation.
  factory Collation.build(
    List<Locale> locales,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locales,
        localeMatcher,
        ecmaPolicy,
        getCollatorECMA,
        getCollator4X,
      );

  /// Compare two strings in a locale-dependant manner.
  ///
  /// The [usage] can specify whether to use this for searching for a string,
  /// or sorting a list of strings. The [sensitivity] regulates how exact the
  /// comparison should be. Setting [numeric] means that numbers are not sorted
  /// alphbetically, but by their value. The [caseFirst] parameter sets if upper
  /// or lowercase letters should take preference.
  int compare(
    String a,
    String b, {
    Usage usage = Usage.sort,
    Sensitivity? sensitivity,
    bool ignorePunctuation = false,
    bool numeric = false,
    CaseFirst? caseFirst,
    String? collation,
  }) {
    if (isInTest) {
      return a.compareTo(b);
    } else {
      return _collationImpl.compareImpl(
        a,
        b,
        usage: usage,
        sensitivity: sensitivity,
        ignorePunctuation: ignorePunctuation,
        numeric: numeric,
        caseFirst: caseFirst,
        collation: collation,
      );
    }
  }
}

/// Separated into a class to not clutter the public API with implementation
/// details.
abstract class CollationImpl {
  /// The current locale, selected by the localematcher
  final List<Locale> locales;

  /// The
  final LocaleMatcher localeMatcher;

  CollationImpl(this.locales, this.localeMatcher);

  /// Actual implementation of the [compare] method.
  int compareImpl(
    String a,
    String b, {
    Usage usage = Usage.sort,
    Sensitivity? sensitivity,
    bool ignorePunctuation = false,
    bool numeric = false,
    CaseFirst? caseFirst,
    String? collation,
  });
}
