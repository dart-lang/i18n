// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale.dart';
import '../options.dart';
import '../test_checker.dart';
import 'collation_options.dart';

class Collation {
  final CollationImpl _collationImpl;

  const Collation(this._collationImpl);

  /// Compare two strings in a locale-dependant manner.
  ///
  /// Given
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

abstract class CollationImpl {
  final Locale locale;
  final LocaleMatcher localeMatcher;

  CollationImpl(this.locale, this.localeMatcher);
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
