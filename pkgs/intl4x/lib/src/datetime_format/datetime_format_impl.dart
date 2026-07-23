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

  FormatterImpl m({DateTimeAlignment? alignment, DateTimeLength? length});

  FormatterImpl md({DateTimeAlignment? alignment, DateTimeLength? length});

  FormatterImpl mde({DateTimeAlignment? alignment, DateTimeLength? length});

  FormatterImpl y({
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

abstract interface class FormatterImpl {
  String format(DateTime datetime);
  ZonedDateTimeFormat withTimeZone(TimeZoneType timeZoneType);
}

abstract class DateTimeFormattable {
  final FormatterImpl _impl;
  final Locale _locale;

  DateTimeFormattable(this._impl, this._locale);

  String format(DateTime datetime) {
    if (isInTest) {
      return '$datetime//$_locale';
    } else {
      return _impl.format(datetime);
    }
  }
}

mixin TimeZoneable {
  ZonedDateTimeFormat withTimeZoneShort();
  ZonedDateTimeFormat withTimeZoneLong();
  ZonedDateTimeFormat withTimeZoneShortOffset();
  ZonedDateTimeFormat withTimeZoneLongOffset();
  ZonedDateTimeFormat withTimeZoneShortGeneric();
  ZonedDateTimeFormat withTimeZoneLongGeneric();

  ZonedDateTimeFormat withTZLong() => withTimeZoneLong();
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
/// Most formatters are [DateTimeFormat]s that can also format with time
/// zone information. Formatters for year and month are
/// [DateTimeFormatUnzoneable] and do not support time zones.
///
/// Example:
/// ```dart
/// import 'package:intl4x/datetime_format.dart';
/// void main() {
///   final date = DateTime(2021, 12, 17, 4, 0, 42);
///   print(DateTimeFormat.year().format(date)); // Output: '2021'
/// }
/// ```
class DateTimeFormat extends DateTimeFormattable with TimeZoneable {
  DateTimeFormat._(super._impl, super._locale);

  @override
  ZonedDateTimeFormat withTimeZoneShort() =>
      _impl.withTimeZone(TimeZoneType.short);

  @override
  ZonedDateTimeFormat withTimeZoneLong() =>
      _impl.withTimeZone(TimeZoneType.long);

  @override
  ZonedDateTimeFormat withTimeZoneShortOffset() =>
      _impl.withTimeZone(TimeZoneType.shortOffset);

  @override
  ZonedDateTimeFormat withTimeZoneLongOffset() =>
      _impl.withTimeZone(TimeZoneType.longOffset);

  @override
  ZonedDateTimeFormat withTimeZoneShortGeneric() =>
      _impl.withTimeZone(TimeZoneType.shortGeneric);

  @override
  ZonedDateTimeFormat withTimeZoneLongGeneric() =>
      _impl.withTimeZone(TimeZoneType.longGeneric);

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
  static DateTimeFormat day({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) => DateTimeFormat._(
    DateTimeFormatImpl.build(
      locale ?? findSystemLocale(),
    ).d(alignment: alignment, length: length),
    locale ?? findSystemLocale(),
  );

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
  static DateTimeFormat weekday({Locale? locale, DateTimeLength? length}) {
    final loc = locale ?? findSystemLocale();
    final impl = DateTimeFormatImpl.build(loc);
    return DateTimeFormat._(impl.e(length: length), loc);
  }

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
  static DateTimeFormatUnzoneable month({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) {
    final loc = locale ?? findSystemLocale();
    final impl = DateTimeFormatImpl.build(loc);
    return DateTimeFormatUnzoneable._(
      impl.m(alignment: alignment, length: length),
      loc,
    );
  }

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
  static DateTimeFormat monthDay({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) {
    final loc = locale ?? findSystemLocale();
    final impl = DateTimeFormatImpl.build(loc);
    return DateTimeFormat._(impl.md(alignment: alignment, length: length), loc);
  }

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
  static DateTimeFormat monthDayWeekday({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  }) {
    final loc = locale ?? findSystemLocale();
    final impl = DateTimeFormatImpl.build(loc);
    return DateTimeFormat._(
      impl.mde(alignment: alignment, length: length),
      loc,
    );
  }

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
  static DateTimeFormatUnzoneable year({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) {
    final loc = locale ?? findSystemLocale();
    final impl = DateTimeFormatImpl.build(loc);
    return DateTimeFormatUnzoneable._(
      impl.y(alignment: alignment, length: length, yearStyle: yearStyle),
      loc,
    );
  }

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
  static DateTimeFormat yearMonth({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) {
    final loc = locale ?? findSystemLocale();
    final impl = DateTimeFormatImpl.build(loc);
    return DateTimeFormat._(
      impl.ym(alignment: alignment, length: length, yearStyle: yearStyle),
      loc,
    );
  }

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
  static DateTimeFormat yearMonthDay({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) {
    final loc = locale ?? findSystemLocale();
    final impl = DateTimeFormatImpl.build(loc);
    return DateTimeFormat._(
      impl.ymd(alignment: alignment, length: length, yearStyle: yearStyle),
      loc,
    );
  }

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
  static DateTimeFormat yearMonthDayWeekday({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) {
    final loc = locale ?? findSystemLocale();
    final impl = DateTimeFormatImpl.build(loc);
    return DateTimeFormat._(
      impl.ymde(alignment: alignment, length: length, yearStyle: yearStyle),
      loc,
    );
  }

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
  static DateTimeFormat monthDayTime({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) {
    final loc = locale ?? findSystemLocale();
    final impl = DateTimeFormatImpl.build(loc);
    return DateTimeFormat._(
      impl.mdt(
        alignment: alignment,
        length: length,
        timePrecision: timePrecision,
      ),
      loc,
    );
  }

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
  static DateTimeFormat yearMonthDayTime({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  }) {
    final loc = locale ?? findSystemLocale();
    final impl = DateTimeFormatImpl.build(loc);
    return DateTimeFormat._(
      impl.ymdt(
        alignment: alignment,
        length: length,
        timePrecision: timePrecision,
        yearStyle: yearStyle,
      ),
      loc,
    );
  }

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
  static DateTimeFormat yearMonthDayWeekdayTime({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  }) {
    final loc = locale ?? findSystemLocale();
    final impl = DateTimeFormatImpl.build(loc);
    return DateTimeFormat._(
      impl.ymdet(
        alignment: alignment,
        length: length,
        timePrecision: timePrecision,
        yearStyle: yearStyle,
      ),
      loc,
    );
  }

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
  static DateTimeFormat time({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) {
    final loc = locale ?? findSystemLocale();
    final impl = DateTimeFormatImpl.build(loc);
    return DateTimeFormat._(
      impl.t(
        alignment: alignment,
        length: length,
        timePrecision: timePrecision,
      ),
      loc,
    );
  }
}

class DateTimeFormatUnzoneable extends DateTimeFormattable {
  DateTimeFormatUnzoneable._(super._impl, super._locale);
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
