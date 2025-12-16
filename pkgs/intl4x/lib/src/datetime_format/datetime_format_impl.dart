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

  FormatterZoneableImpl d({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  });
  FormatterUnzoneableImpl m({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  });
  FormatterZoneableImpl md({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
  });

  FormatterUnzoneableImpl y({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  });

  FormatterZoneableImpl ymd({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  });

  FormatterZoneableImpl ymde({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  });

  FormatterZoneableImpl mdt({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  });

  FormatterZoneableImpl ymdt({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  });

  FormatterZoneableImpl ymdet({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  });

  FormatterZoneableImpl t({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  });
}

abstract class FormatterImpl extends DateTimeFormatter {
  final DateTimeFormatImpl _impl;

  FormatterImpl(this._impl);

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

abstract class FormatterZoneableImpl extends FormatterImpl
    implements DateTimeFormatterZoneable {
  FormatterZoneableImpl(super.impl);
}

abstract class FormatterUnzoneableImpl extends FormatterImpl
    implements DateTimeFormatterUnzoneable {
  FormatterUnzoneableImpl(super.impl);
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
sealed class DateTimeFormatter {
  /// Formats the given [datetime] into a string according to the formatter's
  /// configured locale and options.
  String format(DateTime datetime);
}

sealed class DateTimeFormatterZoneable extends DateTimeFormatter {
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

sealed class DateTimeFormatterUnzoneable extends DateTimeFormatter {}

/// A base class for formatters that can format a [DateTime] and time zone
/// string into a string.
sealed class ZonedDateTimeFormatter {
  /// Formats the given [datetime] and [timeZone] into a string according to the
  /// formatter's configured locale and options.
  String format(DateTime datetime, String timeZone);
}
