// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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

  FormatterStandaloneImpl m({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  });

  FormatterImpl md({DateTimeAlignment? alignment, DateTimeLength? length});

  FormatterStandaloneImpl y({
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

abstract class FormatterStandaloneImpl extends DateTimeFormatterStandalone {
  final DateTimeFormatImpl _impl;

  FormatterStandaloneImpl(this._impl);

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

abstract class FormatterImpl extends FormatterStandaloneImpl
    implements DateTimeFormatter {
  FormatterImpl(super.impl);
}

abstract class FormatterZonedImpl extends ZonedDateTimeFormatter {
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
/// Most formatters are [DateTimeFormatter]s that can also format with time zone
/// information. Only the formatters for year and month are standalone and do
/// not support time zones, returning [DateTimeFormatterStandalone].
///
/// Example:
/// ```dart
/// import 'package:intl4x/datetime_format.dart';
/// void main() {
///   final date = DateTime(2021, 12, 17, 4, 0, 42);
///   print(DateTimeFormat.year().format(date)); // Output: '2021'
/// }
/// ```
sealed class DateTimeFormatterStandalone {
  /// Formats the given [datetime] into a string according to the formatter's
  /// configured locale and options.
  String format(DateTime datetime);
}

/// Formatters that can format a [DateTime] with time zone information.
///
/// This class extends [DateTimeFormatterStandalone] and provides additional
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
sealed class DateTimeFormatter extends DateTimeFormatterStandalone {
  /// Returns a [ZonedDateTimeFormatter] that formats the datetime with a
  /// short time zone name.
  ZonedDateTimeFormatter withTimeZoneShort();

  /// Returns a [ZonedDateTimeFormatter] that formats the datetime with a
  /// long time zone name.
  ZonedDateTimeFormatter withTimeZoneLong();

  /// Returns a [ZonedDateTimeFormatter] that formats the datetime with a
  /// short localized GMT format (e.g. "GMT-8").
  ZonedDateTimeFormatter withTimeZoneShortOffset();

  /// Returns a [ZonedDateTimeFormatter] that formats the datetime with a
  /// long localized GMT format (e.g. "GMT-08:00").
  ZonedDateTimeFormatter withTimeZoneLongOffset();

  /// Returns a [ZonedDateTimeFormatter] that formats the datetime with a
  /// short generic non-location format (e.g. "PT").
  ZonedDateTimeFormatter withTimeZoneShortGeneric();

  /// Returns a [ZonedDateTimeFormatter] that formats the datetime with a
  /// long generic non-location format (e.g. "Pacific Time").
  ZonedDateTimeFormatter withTimeZoneLongGeneric();
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
sealed class ZonedDateTimeFormatter {
  /// Formats the given [datetime] and [timeZone] into a string according to the
  /// formatter's configured locale and options.
  String format(DateTime datetime, String timeZone);
}
