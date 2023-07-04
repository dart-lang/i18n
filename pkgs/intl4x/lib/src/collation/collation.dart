// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../test_checker.dart';
import 'collation_impl.dart';
import 'collation_options.dart';

class Collation {
  final CollationOptions _options;
  final CollationImpl _collationImpl;

  const Collation(this._options, this._collationImpl);

  /// Compare two strings in a locale-dependant manner.
  ///
  /// The [usage] can specify whether to use this for searching for a string,
  /// or sorting a list of strings. The [sensitivity] regulates how exact the
  /// comparison should be. Setting [numeric] means that numbers are not sorted
  /// alphbetically, but by their value. The [caseFirst] parameter sets if upper
  /// or lowercase letters should take preference.
  int compare(String a, String b) {
    if (isInTest) {
      return a.compareTo(b);
    } else {
      return _collationImpl.compareImpl(a, b, _options);
    }
  }
}
