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

  DateFormatter d({DateFormatStyle? dateStyle}) =>
      _impl.d(dateStyle: dateStyle);

  DateFormatter m({DateFormatStyle? dateStyle}) =>
      _impl.m(dateStyle: dateStyle);

  DateFormatter y({DateFormatStyle? dateStyle}) =>
      _impl.y(dateStyle: dateStyle);

  DateFormatter md({DateFormatStyle? dateStyle}) =>
      _impl.md(dateStyle: dateStyle);

  DateFormatter ymd({DateFormatStyle? dateStyle}) =>
      _impl.ymd(dateStyle: dateStyle);

  DateFormatter ymde({DateFormatStyle? dateStyle}) =>
      _impl.ymde(dateStyle: dateStyle);

  DateTimeFormatter mdt({
    DateFormatStyle? dateStyle,
    TimeFormatStyle? timeStyle,
  }) => _impl.mdt(timeStyle: timeStyle, dateStyle: dateStyle);

  DateTimeFormatter ymdt({
    DateFormatStyle? dateStyle,
    TimeFormatStyle? timeStyle,
  }) => _impl.ymdt(timeStyle: timeStyle, dateStyle: dateStyle);

  DateTimeFormatter ymdet({
    DateFormatStyle? dateStyle,
    TimeFormatStyle? timeStyle,
  }) => _impl.ymdet(timeStyle: timeStyle, dateStyle: dateStyle);

  TimeFormatter t({TimeFormatStyle? style}) => _impl.t(style: style);
}

abstract class Formatter {
  String format(DateTime datetime);
}

abstract class FormatterWithTimeZones extends Formatter {
  ZonedFormatter withTimeZoneShort(TimeZone timeZone);
  ZonedFormatter withTimeZoneLong(TimeZone timeZone);
  ZonedFormatter withTimeZoneShortOffset(TimeZone timeZone);
  ZonedFormatter withTimeZoneLongOffset(TimeZone timeZone);
  ZonedFormatter withTimeZoneShortGeneric(TimeZone timeZone);
  ZonedFormatter withTimeZoneLongGeneric(TimeZone timeZone);
}

abstract class DateFormatter extends FormatterWithTimeZones {}

abstract class ZonedFormatter extends Formatter {}

abstract class DateTimeFormatter extends FormatterWithTimeZones {}

abstract class TimeFormatter extends FormatterWithTimeZones {}

DateTimeFormatBuilder buildDateTimeFormat(DateTimeFormatImpl impl) =>
    DateTimeFormatBuilder._(impl);
