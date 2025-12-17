// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A locale-sensitive case mapper for transforming strings.
///
/// This class provides methods to convert strings to lowercase or uppercase
/// based on the current locale.
///
/// ```dart
///import 'package:intl4x/case_mapping.dart';
///
///void main() {
///  final tr = Locale.parse('tr');
///  final en = Locale.parse('en');
///
///  final upper = 'TICKET';
///  print(upper.toLocaleLowerCase(en)); // ticket
///  print(upper.toLocaleLowerCase(tr)); // tıcket
///
///  final lower = 'i';
///  print(lower.toLocaleUpperCase(en)); // I
///  print(lower.toLocaleUpperCase(tr)); // İ
///}
/// ```
/// Available either as an extension on [String], or through the
/// [CaseMapping] class.
library;

import 'src/case_mapping/case_mapping.dart';
import 'src/locale/locale.dart' show Locale;

export 'src/case_mapping/case_mapping.dart' show CaseMapping;
export 'src/locale/locale.dart' show Locale;

/// Extension methods on [String] for locale-sensitive case mapping.
///
/// See [CaseMapping] for more details. This provides convenient methods
/// directly on [String] instances.
extension CaseMappingExt on String {
  /// Returns the string converted to lower case, taking the given [locale] into
  /// account.
  ///
  /// ```dart
  /// import 'package:intl4x/case_mapping.dart';
  ///
  /// void main() {
  ///   print('İ'.toLocaleLowerCase(Locale('en', 'US'))); // Prints 'i̇'
  /// }
  /// ```
  String toLocaleLowerCase(Locale locale) =>
      CaseMapping(locale: locale).toLowerCase(this);

  /// Returns the string converted to upper case, taking the given [locale] into
  /// account.
  ///
  /// ```dart
  /// import 'package:intl4x/case_mapping.dart';
  ///
  /// void main() {
  ///   print('i'.toLocaleUpperCase(Locale('tr'))); // Prints 'İ'
  /// }
  /// ```
  String toLocaleUpperCase(Locale locale) =>
      CaseMapping(locale: locale).toUpperCase(this);
}
