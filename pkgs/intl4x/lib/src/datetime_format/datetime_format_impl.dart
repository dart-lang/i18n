// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart';
import '../locale/locale.dart';
import '../test_checker.dart' show isInTest;
import '../utils.dart';
import 'datetime_format_options.dart';
import 'datetime_format_stub.dart'
    if (dart.library.js_interop) 'datetime_format_ecma.dart';
import 'datetime_format_stub_4x.dart'
    if (dart.library.ffi) 'icu4x/datetime_format_4x.dart';

/// This is an intermediate to defer to the actual implementations of
/// datetime formatting.
abstract class DateTimeFormatImpl {
  final Locale locale;

  DateTimeFormatImpl(this.locale);

  static DateTimeFormatImpl build(Locale locale) => buildFormatter(
    locale,
    null,
    getDateTimeFormatterECMA,
    getDateTimeFormatter4X,
  );

  FormatterImpl d({DateTimeAlignment? alignment, DateTimeLength? length});

  FormatterImpl e({DateTimeLength? length});

  FormatImpl m({DateTimeAlignment? alignment, DateTimeLength? length});

  FormatterImpl md({DateTimeAlignment? alignment, DateTimeLength? length});

  FormatterImpl mde({DateTimeAlignment? alignment, DateTimeLength? length});

  FormatImpl y({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  });

  FormatterImpl ym({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  });

  FormatterImpl ymd({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  });

  FormatterImpl ymde({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  });

  FormatterImpl mdt({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  });

  FormatterImpl ymdt({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  });

  FormatterImpl ymdet({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  });

  FormatterImpl t({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  });
}

abstract class FormatImpl extends DateTimeFormat {
  final DateTimeFormatImpl _impl;

  FormatImpl(this._impl);

  String formatInternal(DateTime datetime);

  @override
  String format(DateTime datetime) {
    if (isInTest) {
      return '$datetime//${_impl.locale}';
    } else {
      return formatInternal(datetime);
    }
  }
}

abstract class FormatterImpl extends FormatImpl
    implements ZoneableDateTimeFormat {
  FormatterImpl(super.impl);
}

abstract class FormatterZonedImpl extends ZonedDateTimeFormat {
  final DateTimeFormatImpl _impl;
  final TimeZoneType timeZoneType;

  String formatInternal(DateTime datetime, String timeZone);

  FormatterZonedImpl(this._impl, this.timeZoneType);

  @override
  String format(DateTime datetime, String timeZone) {
    if (isInTest) {
      return '$datetime//${_impl.locale}';
    } else {
      return formatInternal(datetime, timeZone);
    }
  }
}

/// A base class for formatters that can format a [DateTime] into a string.
///
/// Most formatters are [ZoneableDateTimeFormat]s that can also format with time
/// zone information. Only the formatters for year and month are standalone and
/// do not support time zones, returning [DateTimeFormat].
///
/// Example:
/// ```dart
/// import 'package:intl4x/datetime_format.dart';
/// void main() {
///   final date = DateTime(2021, 12, 17, 4, 0, 42);
///   print(DateTimeFormat.year().format(date)); // Output: '2021'
/// }
/// ```
sealed class DateTimeFormat {
  /// Formats the given [datetime] into a string according to the formatter's
  /// configured locale and options.
  String format(DateTime datetime);

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
  static ZoneableDateTimeFormat day({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).d(alignment: alignment, length: length);

  /// Formatting just the weekday.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.weekday().format(date)); // Output: 'Friday'
  /// }
  /// ```
  static ZoneableDateTimeFormat weekday({
    Locale? locale,
    DateTimeLength? length,
  }) =>
      DateTimeFormatImpl.build(locale ?? findSystemLocale()).e(length: length);

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
  static DateTimeFormat month({
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
  static ZoneableDateTimeFormat monthDay({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).md(alignment: alignment, length: length);

  /// Formatting the month, day, and weekday.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.monthDayWeekday().format(date)); // Output: 'Fri, Dec 17'
  /// }
  /// ```
  static ZoneableDateTimeFormat monthDayWeekday({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).mde(alignment: alignment, length: length);

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
  static DateTimeFormat year({
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
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.yearMonth().format(date)); // Output: 'Dec 2021'
  /// }
  /// ```
  static ZoneableDateTimeFormat yearMonth({
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
  /// ```dart
  /// import 'package:intl4x/datetime_format.dart';
  ///
  /// void main() {
  ///   final date = DateTime(2021, 12, 17, 4, 0, 42);
  ///   print(DateTimeFormat.yearMonthDay().format(date)); // Output: 'Dec 17, 2021'
  /// }
  /// ```
  static ZoneableDateTimeFormat yearMonthDay({
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
  static ZoneableDateTimeFormat yearMonthDayWeekday({
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
  static ZoneableDateTimeFormat monthDayTime({
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
  static ZoneableDateTimeFormat yearMonthDayTime({
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
  static ZoneableDateTimeFormat yearMonthDayWeekdayTime({
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
  static ZoneableDateTimeFormat time({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) => DateTimeFormatImpl.build(
    locale ?? findSystemLocale(),
  ).t(alignment: alignment, length: length, timePrecision: timePrecision);
}

/// Formatters that can format a [DateTime] with time zone information.
///
/// This class extends [DateTimeFormat] and provides additional
/// methods to format dates and times with time zone information.
///
/// Example:
/// ```dart
/// import 'package:intl4x/datetime_format.dart';
/// void main() {
///   final date = DateTime(2021, 12, 17, 4, 0, 42);
///   print(DateTimeFormat.year().format(date)); // Output: '2021'
/// }
/// ```
sealed class ZoneableDateTimeFormat extends DateTimeFormat {
  /// Returns a [ZonedDateTimeFormat] that formats the datetime with a
  /// short time zone name.
  ZonedDateTimeFormat withTimeZoneShort();

  /// Returns a [ZonedDateTimeFormat] that formats the datetime with a
  /// long time zone name.
  ZonedDateTimeFormat withTimeZoneLong();

  /// Returns a [ZonedDateTimeFormat] that formats the datetime with a
  /// short localized GMT format (e.g. "GMT-8").
  ZonedDateTimeFormat withTimeZoneShortOffset();

  /// Returns a [ZonedDateTimeFormat] that formats the datetime with a
  /// long localized GMT format (e.g. "GMT-08:00").
  ZonedDateTimeFormat withTimeZoneLongOffset();

  /// Returns a [ZonedDateTimeFormat] that formats the datetime with a
  /// short generic non-location format (e.g. "PT").
  ZonedDateTimeFormat withTimeZoneShortGeneric();

  /// Returns a [ZonedDateTimeFormat] that formats the datetime with a
  /// long generic non-location format (e.g. "Pacific Time").
  ZonedDateTimeFormat withTimeZoneLongGeneric();
}

/// A base class for formatters that can format a [DateTime] and time zone
/// string into a string.
///
/// Example
/// ```dart
/// import 'package:intl4x/datetime_format.dart';
/// void main() {
///   final timeZone = 'Europe/Paris';
///   final dateTime = DateTime.parse('2024-07-01T08:50:07');
///   final formatter = DateTimeFormat.yearMonthDayTime(
///     locale: Locale.parse('en'),
///     length: DateTimeLength.long,
///   ).withTimeZoneShort();
///   print(
///     formatter.format(dateTime, timeZone),
///   ); // prints 'July 1, 2024 at 8:50:07 AM GMT+2'
/// }
/// ```
sealed class ZonedDateTimeFormat {
  /// Formats the given [datetime] and [timeZone] into a string according to the
  /// formatter's configured locale and options.
  String format(DateTime datetime, String timeZone);
}
