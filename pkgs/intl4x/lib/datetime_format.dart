// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'intl4x.dart';

export 'src/datetime_format/datetime_format.dart';
export 'src/datetime_format/datetime_format_options.dart';
export 'src/options.dart';

extension DateTimeFormatIntl4x on DateTime {
  /// Format a date in a locale-dependent manner.
  ///
  /// For more options, use [Intl.datetimeFormat] directly.
  String toLocaleDateString([Locale? locale]) =>
      Intl(locale: locale).datetimeFormat().format(this);
}
