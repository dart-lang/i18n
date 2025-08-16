// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../datetime_format.dart';
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
class DateTimeFormatBuilder {
  final DateTimeFormatImpl _impl;

  DateTimeFormatBuilder._(this._impl);

  DateFormatter d() => _impl.d();
  DateFormatter m() => _impl.m();
  DateFormatter y() => _impl.y();
  DateFormatter md() => _impl.md();
  DateFormatter ymd() => _impl.ymd();
  DateFormatter ymde() => _impl.ymde();
  DateTimeFormatter ymdt() => _impl.ymdt();
  DateTimeFormatter ymdet() => _impl.ymdet();
  TimeFormatter time() => _impl.time();
}

abstract class Formatter {
  String format(DateTime datetime);
}

abstract class DateFormatter extends Formatter {
  DateFormatterZoned withTimezoneShort(TimeZone timeZone);
  DateFormatterZoned withTimezoneLong(TimeZone timeZone);
  DateFormatterZoned withTimeZoneShortOffset(TimeZone timeZone);
  DateFormatterZoned withTimeZoneLongOffset(TimeZone timeZone);
  DateFormatterZoned withTimeZoneShortGeneric(TimeZone timeZone);
  DateFormatterZoned withTimeZoneLongGeneric(TimeZone timeZone);
}

abstract class DateFormatterZoned extends Formatter {}

abstract class DateTimeFormatter extends Formatter {
  DateTimeFormatterZoned withTimezoneShort(TimeZone timeZone);
  DateTimeFormatterZoned withTimezoneLong(TimeZone timeZone);
  DateTimeFormatterZoned withTimeZoneShortOffset(TimeZone timeZone);
  DateTimeFormatterZoned withTimeZoneLongOffset(TimeZone timeZone);
  DateTimeFormatterZoned withTimeZoneShortGeneric(TimeZone timeZone);
  DateTimeFormatterZoned withTimeZoneLongGeneric(TimeZone timeZone);
}

abstract class DateTimeFormatterZoned extends Formatter {}

abstract class TimeFormatter extends Formatter {
  TimeFormatterZoned withTimezoneShort(TimeZone timeZone);
  TimeFormatterZoned withTimezoneLong(TimeZone timeZone);
  TimeFormatterZoned withTimeZoneShortOffset(TimeZone timeZone);
  TimeFormatterZoned withTimeZoneLongOffset(TimeZone timeZone);
  TimeFormatterZoned withTimeZoneShortGeneric(TimeZone timeZone);
  TimeFormatterZoned withTimeZoneLongGeneric(TimeZone timeZone);
}

abstract class TimeFormatterZoned extends Formatter {}

DateTimeFormatBuilder buildDateTimeFormat(DateTimeFormatImpl impl) =>
    DateTimeFormatBuilder._(impl);
