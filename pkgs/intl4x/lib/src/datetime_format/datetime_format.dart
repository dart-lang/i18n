// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart';
import '../locale/locale.dart' show Locale;
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

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

  DateTimeFormat({Locale? locale})
    : _impl = DateTimeFormatImpl.build(locale ?? findSystemLocale());

  DateTimeFormatter d({DateTimeAlignment? alignment, DateTimeLength? length}) =>
      _impl.d(alignment: alignment, length: length);

  DateTimeFormatter m({DateTimeAlignment? alignment, DateTimeLength? length}) =>
      _impl.m(alignment: alignment, length: length);

  DateTimeFormatter md({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) => _impl.md(alignment: alignment, length: length);

  DateTimeFormatter y({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => _impl.y(alignment: alignment, length: length, yearStyle: yearStyle);

  DateTimeFormatter ymd({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => _impl.ymd(alignment: alignment, length: length, yearStyle: yearStyle);

  DateTimeFormatter ymde({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => _impl.ymde(alignment: alignment, length: length, yearStyle: yearStyle);

  DateTimeFormatter mdt({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) => _impl.mdt(
    alignment: alignment,
    length: length,
    timePrecision: timePrecision,
  );

  DateTimeFormatter ymdt({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  }) => _impl.ymdt(
    alignment: alignment,
    length: length,
    timePrecision: timePrecision,
    yearStyle: yearStyle,
  );

  DateTimeFormatter ymdet({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  }) => _impl.ymdet(
    alignment: alignment,
    length: length,
    timePrecision: timePrecision,
    yearStyle: yearStyle,
  );

  DateTimeFormatter t({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) => _impl.t(
    alignment: alignment,
    length: length,
    timePrecision: timePrecision,
  );
}
