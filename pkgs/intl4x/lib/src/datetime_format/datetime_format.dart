// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart';
import '../locale/locale.dart' show Locale;
import 'datetime_format_impl.dart' show DateTimeFormatImpl, DateTimeFormatter, DateTimeFormatterUnzoneable, DateTimeFormatterZoneable;
import 'datetime_format_options.dart';

/// `DateTime` formatting.
///
/// This class provides static methods to create [DateTimeFormatter] instances
/// for various common date and time formats.
///
/// Example:
///
/// ```dart
/// import 'package:intl4x/datetime_format.dart';
///
/// void main() {
///   final date = DateTime(2021, 12, 17, 4, 0, 42);
///   print(DateTimeFormat.time(locale: Locale.parse('fr')).format(date));
///   // Output: '04:00'
/// }
/// ```
sealed class DateTimeFormat {
  /// Formatting just the day.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.day().format(date)); // Output: '17'
  /// }
  /// ```
  static DateTimeFormatterZoneable day({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).d(alignment: alignment, length: length);

  /// Formatting just the month.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.month().format(date)); // Output: 'Dec'
  /// }
  /// ```
  static DateTimeFormatterUnzoneable month({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).m(alignment: alignment, length: length);

  /// Formatting the month and day.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.monthDay().format(date)); // Output: 'Dec 17'
  /// }
  /// ```
  static DateTimeFormatterZoneable monthDay({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).md(alignment: alignment, length: length);

  /// Formatting just the year.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.year().format(date)); // Output: '2021'
  /// }
  /// ```
  static DateTimeFormatterUnzoneable year({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).y(alignment: alignment, length: length, yearStyle: yearStyle);

  /// Formatting the year, month, and day.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.yearMonthDay().format(date)); // Output: 'Dec 17, 2021'
  /// }
  /// ```
  static DateTimeFormatterZoneable yearMonthDay({
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
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.yearMonthDayWeekday().format(date)); // Output: 'Fri, Dec 17, 2021'
  /// }
  /// ```
  static DateTimeFormatterZoneable yearMonthDayWeekday({
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
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.monthDayTime().format(date)); // Output: 'Dec 17, 4:00 AM'
  /// }
  /// ```
  static DateTimeFormatterZoneable monthDayTime({
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
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.yearMonthDayTime().format(date)); // Output: 'Dec 17, 2021, 4:00 AM'
  /// }
  /// ```
  static DateTimeFormatterZoneable yearMonthDayTime({
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
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.yearMonthDayWeekdayTime().format(date)); // Output: 'Fri, Dec 17, 2021, 4:00 AM'
  /// }
  /// ```
  static DateTimeFormatterZoneable yearMonthDayWeekdayTime({
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
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.time().format(date)); // Output: '4:00 AM'
  /// }
  /// ```
  static DateTimeFormatterZoneable time({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).t(alignment: alignment, length: length, timePrecision: timePrecision);
}
