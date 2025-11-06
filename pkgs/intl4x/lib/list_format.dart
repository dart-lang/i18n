// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'intl4x.dart';
import 'list_format.dart';

export 'src/list_format/list_format.dart' show ListFormat;
export 'src/list_format/list_format_options.dart';
export 'src/options.dart';

extension ListFormatIntl4x on List<String> {
  /// Join a list in a locale-dependent manner using `and`-based grouping.
  ///
  /// Example: "A, B, and C". See also [Type.and].
  ///
  /// For more options, use [ListFormat] directly.
  String joinAnd({Locale? locale}) => ListFormat(
    locale: locale,
    options: const ListFormatOptions(type: Type.and),
  ).format(this);

  /// Join a list in a locale-dependent manner using `or`-based grouping.
  ///
  /// Example: "A, B, or C". See also [Type.or].
  ///
  /// For more options, use [ListFormat] directly.
  String joinOr({Locale? locale}) => ListFormat(
    locale: locale,
    options: const ListFormatOptions(type: Type.or),
  ).format(this);

  /// Join a list in a locale-dependent manner using unit-based grouping.
  ///
  /// Example: "A, B, C". See also [Type.unit].
  ///
  /// For more options, use [ListFormat] directly.
  String joinUnit({Locale? locale}) => ListFormat(
    locale: locale,
    options: const ListFormatOptions(type: Type.unit),
  ).format(this);
}
