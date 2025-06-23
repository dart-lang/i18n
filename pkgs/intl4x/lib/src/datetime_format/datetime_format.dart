// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../test_checker.dart';
import 'datetime_format_impl.dart';

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
  final DateTimeFormatImpl _impl;

  DateTimeFormat(this._impl);

  String d(DateTime datetime) => _format(_impl.d, datetime);
  String m(DateTime datetime) => _format(_impl.m, datetime);
  String y(DateTime datetime) => _format(_impl.y, datetime);
  String md(DateTime datetime) => _format(_impl.md, datetime);
  String ymd(DateTime datetime) => _format(_impl.ymd, datetime);
  String ymde(DateTime datetime) => _format(_impl.ymde, datetime);
  String ymdt(DateTime datetime) => _format(_impl.ymdt, datetime);
  String ymdet(DateTime datetime) => _format(_impl.ymdet, datetime);

  String time(DateTime datetime) => _format(_impl.time, datetime);

  String _format(String Function(DateTime datetime) format, DateTime datetime) {
    if (isInTest) {
      return '$datetime//${_impl.locale}';
    } else {
      return format(datetime.toUtc());
    }
  }
}
