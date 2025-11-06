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

  DateTimeFormat({
    Locale? locale,
    DateTimeFormatOptions options = const DateTimeFormatOptions(),
  }) : _impl = DateTimeFormatImpl.build(locale ?? findSystemLocale(), options);

  DateTimeFormatter d({DateFormatStyle? dateStyle}) =>
      _impl.d(dateStyle: dateStyle);

  DateTimeFormatter m({DateFormatStyle? dateStyle}) =>
      _impl.m(dateStyle: dateStyle);

  DateTimeFormatter y({DateFormatStyle? dateStyle, bool withEra = false}) =>
      _impl.y(dateStyle: dateStyle, withEra: withEra);

  DateTimeFormatter md({DateFormatStyle? dateStyle}) =>
      _impl.md(dateStyle: dateStyle);

  DateTimeFormatter ymd({DateFormatStyle? dateStyle, bool withEra = false}) =>
      _impl.ymd(dateStyle: dateStyle, withEra: withEra);

  DateTimeFormatter ymde({DateFormatStyle? dateStyle, bool withEra = false}) =>
      _impl.ymde(dateStyle: dateStyle, withEra: withEra);

  DateTimeFormatter mdt({
    DateFormatStyle? dateStyle,
    TimeFormatStyle? timeStyle,
  }) => _impl.mdt(timeStyle: timeStyle, dateStyle: dateStyle);

  DateTimeFormatter ymdt({
    DateFormatStyle? dateStyle,
    TimeFormatStyle? timeStyle,
    bool withEra = false,
  }) =>
      _impl.ymdt(timeStyle: timeStyle, dateStyle: dateStyle, withEra: withEra);

  DateTimeFormatter ymdet({
    DateFormatStyle? dateStyle,
    TimeFormatStyle? timeStyle,
    bool withEra = false,
  }) =>
      _impl.ymdet(timeStyle: timeStyle, dateStyle: dateStyle, withEra: withEra);

  DateTimeFormatter t({TimeFormatStyle? style}) => _impl.t(style: style);
}
