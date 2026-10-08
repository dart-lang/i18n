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
/// based on the current locale.
///
/// {@example ../../../example/docs/case_mapping.dart#to_upper_case}
///
/// Caution: During testing, the input is returned unchanged.
final class CaseMapping {
  final CaseMappingImpl _caseMappingImpl;

  /// Constructs a [CaseMapping] instance for the given [locale].
  ///
  /// If [locale] is not provided, the system's locale is used.
  CaseMapping({Locale? locale})
    : _caseMappingImpl = CaseMappingImpl.build(locale ?? findSystemLocale());

  /// Lowercases the given [input].
  ///
  /// This is done using the locale from the constructor.
  ///
  /// {@example ../../../example/docs/case_mapping.dart#to_lower_case}
  String toLowerCase(String input) {
    if (isInTest) {
      return input;
    } else {
      return _caseMappingImpl.toLowerCase(input);
    }
  }

  /// Uppercases the given [input].
  ///
  /// This is done using the locale from the constructor.
  ///
  /// {@example ../../../example/docs/case_mapping.dart#to_upper_case}
  String toUpperCase(String input) {
    if (isInTest) {
      return input;
    } else {
      return _caseMappingImpl.toUpperCase(input);
    }
  }
}
