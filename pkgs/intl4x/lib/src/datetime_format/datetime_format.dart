// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart';
import '../locale/locale.dart' show Locale;
import 'datetime_format_impl.dart'
    show DateTimeFormatImpl, DateTimeFormatter, DateTimeFormatterStandalone;
import 'datetime_format_options.dart';

/// `DateTime` formatting.
///
/// This class provides static methods to create [DateTimeFormatter] instances
/// for various common date and time formats.
///
/// Example:
/// {@example ../../../example/docs/datetime_format.dart#time_fr}
sealed class DateTimeFormat {
  /// Formatting just the day.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#day}
  static DateTimeFormatter day({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).d(alignment: alignment, length: length);

  /// Formatting just the weekday.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#weekday}
  static DateTimeFormatter weekday({Locale? locale, DateTimeLength? length}) =>
      DateTimeFormatImpl.build(locale ?? findSystemLocale()).e(length: length);

  /// Formatting just the month.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#month}
  static DateTimeFormatterStandalone month({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).m(alignment: alignment, length: length);

  /// Formatting the month and day.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#month_day}
  static DateTimeFormatter monthDay({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).md(alignment: alignment, length: length);

  /// Formatting the month, day, and weekday.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#month_day_weekday}
  static DateTimeFormatter monthDayWeekday({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).mde(alignment: alignment, length: length);

  /// Formatting just the year.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#year}
  static DateTimeFormatterStandalone year({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).y(alignment: alignment, length: length, yearStyle: yearStyle);

  /// Formatting the year and month.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#year_month}
  static DateTimeFormatter yearMonth({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).ym(alignment: alignment, length: length, yearStyle: yearStyle);

  /// Formatting the year, month, and day.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#year_month_day}
  static DateTimeFormatter yearMonthDay({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).ymd(alignment: alignment, length: length, yearStyle: yearStyle);

  /// Formatting the year, month, day, and weekday.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#year_month_day_weekday}
  static DateTimeFormatter yearMonthDayWeekday({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).ymde(alignment: alignment, length: length, yearStyle: yearStyle);

  /// Formatting the month, day, and time.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#month_day_time}
  static DateTimeFormatter monthDayTime({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).mdt(alignment: alignment, length: length, timePrecision: timePrecision);

  /// Formatting the year, month, day, and time.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#year_month_day_time}
  static DateTimeFormatter yearMonthDayTime({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  }) => DateTimeFormatImpl.build(locale ?? findSystemLocale()).ymdt(
    alignment: alignment,
    length: length,
    timePrecision: timePrecision,
    yearStyle: yearStyle,
  );

  /// Formatting the year, month, day, weekday, and time.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#year_month_day_weekday_time}
  static DateTimeFormatter yearMonthDayWeekdayTime({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  }) => DateTimeFormatImpl.build(locale ?? findSystemLocale()).ymdet(
    alignment: alignment,
    length: length,
    timePrecision: timePrecision,
    yearStyle: yearStyle,
  );

  /// Formatting just the time.
  ///
  /// Example:
  /// {@example ../../../example/docs/datetime_format.dart#time}
  static DateTimeFormatter time({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).t(alignment: alignment, length: length, timePrecision: timePrecision);
}
