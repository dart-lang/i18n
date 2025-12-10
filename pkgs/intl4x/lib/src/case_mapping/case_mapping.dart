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
/// ```dart
/// import 'package:intl4x/case_mapping.dart';
///
/// void main() {
///   final caseMapping = CaseMapping(locale: Locale('tr'));
///   print(caseMapping.toUpperCase('i')); // Prints 'İ'
/// }
/// ```
///
/// Caution: During testing, the input is returned unchanged.
class CaseMapping {
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
  /// ```dart
  /// import 'package:intl4x/case_mapping.dart';
  ///
  /// void main() {
  ///   final caseMapping = CaseMapping(locale: Locale('en', 'US'));
  ///   print(caseMapping.toLowerCase('İ')); // Prints 'i̇'
  /// }
  /// ```
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
  /// ```dart
  /// import 'package:intl4x/case_mapping.dart';
  ///
  /// void main() {
  ///   final caseMapping = CaseMapping(locale: Locale('tr'));
  ///   print(caseMapping.toUpperCase('i')); // Prints 'İ'
  /// }
  /// ```
  String toUpperCase(String input) {
    if (isInTest) {
      return input;
    } else {
      return _caseMappingImpl.toUpperCase(input);
    }
  }
}
