// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart' show findSystemLocale;
import '../locale/locale.dart' show Locale;
import '../test_checker.dart';
import 'case_mapping_impl.dart';

/// A locale-sensitive case mapper for transforming strings.
///
/// This class provides methods to convert strings to lowercase or uppercase
/// based on the current locale. During testing, the input is returned
/// unchanged.
class CaseMapping {
  final CaseMappingImpl _caseMappingImpl;

  const CaseMapping._(this._caseMappingImpl);

  CaseMapping({Locale? locale})
    : _caseMappingImpl = CaseMappingImpl.build(locale ?? findSystemLocale());

  String toLowerCase(String input) {
    if (isInTest) {
      return input;
    } else {
      return _caseMappingImpl.toLowerCase(input);
    }
  }

  String toUpperCase(String input) {
    if (isInTest) {
      return input;
    } else {
      return _caseMappingImpl.toUpperCase(input);
    }
  }
}

CaseMapping buildCaseMapping(CaseMappingImpl collationImpl) =>
    CaseMapping._(collationImpl);
