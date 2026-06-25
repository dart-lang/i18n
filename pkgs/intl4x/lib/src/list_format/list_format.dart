// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart' show findSystemLocale;
import '../locale/locale.dart' show Locale;
import '../test_checker.dart';
import 'list_format_impl.dart';
import 'list_format_options.dart';

/// Joins a list of strings according to locale-specific rules.
///
/// This is typically used for joining items with appropriate conjunctions (like
/// 'and' or 'or') or punctuation (like commas).
final class ListFormat {
  final ListFormatImpl _listFormatImpl;

  /// Creates a new list formatter.
  ///
  /// * [locale]: The locale defining the formatting rules (e.g., 'en-US',
  ///   'es'). If `null`, uses the system locale.
  /// * [type]: Specifies the type of list concatenation. Defaults to
  ///   [ListType.and] (for conjunction) or can be [ListType.or] (for
  ///   disjunction).
  /// * [style]: The formatting style, such as [ListStyle.long] (e.g., "A, B,
  ///   and C") or [ListStyle.short] (e.g., "A, B, & C"). Defaults to
  ///   [ListStyle.long].
  ListFormat({
    Locale? locale,
    ListType type = ListType.and,
    ListStyle style = ListStyle.long,
  }) : _listFormatImpl = ListFormatImpl.build(
         locale ?? findSystemLocale(),
         ListFormatOptions(type: type, style: style),
       );

  /// Locale-dependant concatenation of lists.
  ///
  /// ```dart
  /// import 'package:intl4x/list_format.dart';
  ///
  /// void main() {
  ///  print(
  ///   ListFormat(locale: Locale.parse('en-US')).format(['Dog', 'Cat']),
  ///  ); // Prints 'Dog and Cat'
  /// }
  /// ```
  String format(List<String> list) {
    if (isInTest) {
      return '${list.join(', ')}//${_listFormatImpl.locale}';
    } else {
      return _listFormatImpl.formatImpl(list);
    }
  }
}
