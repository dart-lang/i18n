// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'src/list_format/list_format.dart';
import 'src/list_format/list_format_options.dart';
import 'src/locale/locale.dart' show Locale;

export 'src/list_format/list_format.dart' show ListFormat;
export 'src/list_format/list_format_options.dart' show ListStyle, ListType;
export 'src/locale/locale.dart' show Locale;

extension ListFormatIntl4x on List<String> {
  /// Join a list in a locale-dependent manner using `and`-based grouping.
  ///
  /// Example: "A, B, and C". See also [ListType.and].
  ///
  /// For more options, use [ListFormat] directly.
  String joinAnd({Locale? locale}) =>
      ListFormat(locale: locale, type: ListType.and).format(this);

  /// Join a list in a locale-dependent manner using `or`-based grouping.
  ///
  /// Example: "A, B, or C". See also [ListType.or].
  ///
  /// For more options, use [ListFormat] directly.
  String joinOr({Locale? locale}) =>
      ListFormat(locale: locale, type: ListType.or).format(this);

  /// Join a list in a locale-dependent manner using unit-based grouping.
  ///
  /// Example: "A, B, C". See also [ListType.unit].
  ///
  /// For more options, use [ListFormat] directly.
  String joinUnit({Locale? locale}) =>
      ListFormat(locale: locale, type: ListType.unit).format(this);
}
