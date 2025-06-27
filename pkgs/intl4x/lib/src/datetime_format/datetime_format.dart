// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart';

import '../../datetime_format.dart';
import '../test_checker.dart';
import 'datetime_format_impl.dart';

/// `DateTime` formatting, for example:
///
/// ```dart
/// final date = DateTime.utc(2021, 12, 17, 4, 0, 42);
/// Intl(locale: Locale.parse('fr'))
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

  DateTimeFormat._(this._impl);

  String d(DateTime datetime) => _format(_impl.d, datetime, _impl);
  String m(DateTime datetime) => _format(_impl.m, datetime, _impl);
  String y(DateTime datetime) => _format(_impl.y, datetime, _impl);
  String md(DateTime datetime) => _format(_impl.md, datetime, _impl);

  String ymde(DateTime datetime) => _format(_impl.ymde, datetime, _impl);

  String ymdet(DateTime datetime) => _format(_impl.ymdet, datetime, _impl);

  static String _format(
    String Function(DateTime datetime) format,
    DateTime datetime,
    DateTimeFormatImpl impl,
  ) {
    if (isInTest) {
      return '$datetime//${impl.locale}';
    } else {
      return format(datetime);
    }
  }
}

extension DatetimeFormatExt on DateTimeFormat {
  @RecordUse()
  String ymdt(DateTime datetime, {@mustBeConst TimeZone? timeZone}) =>
      DateTimeFormat._format(
        (datetime) => _impl.ymdt(datetime, timeZone: timeZone),
        datetime,
        _impl,
      );

  @RecordUse()
  String ymd(DateTime datetime, {@mustBeConst TimeZone? timeZone}) =>
      DateTimeFormat._format(
        (datetime) => _impl.ymd(datetime, timeZone: timeZone),
        datetime,
        _impl,
      );

  @RecordUse()
  String time(DateTime datetime, {@mustBeConst TimeZone? timeZone}) =>
      DateTimeFormat._format(
        (datetime) => _impl.time(datetime, timeZone: timeZone),
        datetime,
        _impl,
      );
}

DateTimeFormat buildDateTimeFormat(DateTimeFormatImpl impl) =>
    DateTimeFormat._(impl);
