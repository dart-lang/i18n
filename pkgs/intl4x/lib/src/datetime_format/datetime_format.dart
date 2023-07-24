// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../test_checker.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

/// `DateTime` formatting, for example:
///
/// ```dart
/// final date = DateTime.utc(2021, 12, 17, 4, 0, 42);
/// Intl(locale: const Locale(language: 'fr'))
///     .datetimeFormat(const DateTimeFormatOptions(
///       hour: TimeRepresentation.numeric,
///       hourCycle: HourCycle.h12,
///       dayPeriod: DayPeriod.narrow,
///       timeZone: 'UTC',
///     ))
///     .format(date); // Output: '4 mat.'
/// ```
class DateTimeFormat {
  final DateTimeFormatOptions _options;
  final DateTimeFormatImpl impl;

  DateTimeFormat(this._options, this.impl);

  String format(DateTime datetime) {
    if (isInTest) {
      return '$datetime//${impl.locale}';
    } else {
      return impl.formatImpl(datetime, _options);
    }
  }
}
