// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;
import 'package:timezone/data/latest_all.dart' show initializeTimeZones;
import 'package:timezone/timezone.dart' show TZDateTime, timeZoneDatabase;

import '../../../datetime_format.dart';
import '../../locale/locale_4x.dart';
import '../datetime_format_impl.dart';
import 'date_formatter.dart';
import 'date_time_formatter.dart';
import 'time_formatter.dart';

DateTimeFormatImpl getDateTimeFormatter4X(Locale locale, Null options) =>
    DateTimeFormat4X(locale as Locale4x);

class DateTimeFormat4X extends DateTimeFormatImpl {
  DateTimeFormat4X(Locale4x super.locale);

  icu.Locale get localeX => (super.locale as Locale4x).get4X;

  @override
  FormatterImpl d({DateTimeAlignment? alignment, DateTimeLength? length}) =>
      DateFormatterX.d(this, localeX, alignment?.toX, length?.toX);

  @override
  FormatterImpl m({DateTimeAlignment? alignment, DateTimeLength? length}) =>
      DateFormatterX.m(this, localeX, alignment?.toX, length?.toX);

  @override
  FormatterImpl md({DateTimeAlignment? alignment, DateTimeLength? length}) =>
      DateFormatterX.md(this, localeX, alignment?.toX, length?.toX);

  @override
  FormatterImpl y({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => DateFormatterX.y(
    this,
    localeX,
    alignment?.toX,
    length?.toX,
    yearStyle?.toX,
  );

  @override
  FormatterImpl ymd({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => DateFormatterX.ymd(
    this,
    localeX,
    alignment?.toX,
    length?.toX,
    yearStyle?.toX,
  );

  @override
  FormatterImpl ymde({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => DateFormatterX.ymde(
    this,
    localeX,
    alignment?.toX,
    length?.toX,
    yearStyle?.toX,
  );

  @override
  FormatterImpl mdt({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) => DateTimeFormatterX.mdt(
    this,
    localeX,
    alignment?.toX,
    length?.toX,
    timePrecision?.toX,
  );

  @override
  FormatterImpl ymdt({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  }) => DateTimeFormatterX.ymdt(
    this,
    localeX,
    alignment?.toX,
    length?.toX,
    timePrecision?.toX,
    yearStyle?.toX,
  );

  @override
  FormatterImpl ymdet({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  }) => DateTimeFormatterX.ymdet(
    this,
    localeX,
    alignment?.toX,
    length?.toX,
    timePrecision?.toX,
    yearStyle?.toX,
  );

  @override
  FormatterImpl t({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) => TimeFormatterX.t(
    this,
    localeX,
    timePrecision?.toX,
    alignment?.toX,
    length?.toX,
  );
}

extension DateToICU4X on DateTime {
  (icu.IsoDate, icu.Time) get toX {
    final isoDate = icu.IsoDate(year, month, day);
    final time = icu.Time(
      hour,
      minute,
      second,
      millisecond * 1_000_000 + microsecond * 1_000,
    );
    return (isoDate, time);
  }
}

extension on DateTimeLength {
  icu.DateTimeLength get toX => switch (this) {
    DateTimeLength.long => icu.DateTimeLength.long,
    DateTimeLength.medium => icu.DateTimeLength.medium,
    DateTimeLength.short => icu.DateTimeLength.short,
  };
}

extension on TimePrecision {
  icu.TimePrecision get toX => switch (this) {
    TimePrecision.hour => icu.TimePrecision.hour,
    TimePrecision.minute => icu.TimePrecision.minute,
    TimePrecision.minuteOptional => icu.TimePrecision.minuteOptional,
    TimePrecision.second => icu.TimePrecision.second,
    TimePrecision.subsecond1 => icu.TimePrecision.subsecond1,
    TimePrecision.subsecond2 => icu.TimePrecision.subsecond2,
    TimePrecision.subsecond3 => icu.TimePrecision.subsecond3,
  };
}

extension on YearStyle {
  icu.YearStyle get toX => switch (this) {
    YearStyle.auto => icu.YearStyle.auto,
    YearStyle.full => icu.YearStyle.full,
    YearStyle.withEra => icu.YearStyle.withEra,
  };
}

extension on DateTimeAlignment {
  icu.DateTimeAlignment get toX => switch (this) {
    DateTimeAlignment.auto => icu.DateTimeAlignment.auto,
    DateTimeAlignment.column => icu.DateTimeAlignment.column,
  };
}

icu.TimeZoneInfo timeZoneToX(String timeZone, DateTime datetime) {
  if (!timeZoneDatabase.isInitialized) {
    initializeTimeZones();
  }
  final location = timeZoneDatabase.locations[timeZone];
  final timeZoneX = location != null
      ? icu.IanaParser()
            .parse(timeZone)
            .withOffset(
              icu.UtcOffset.fromSeconds(
                TZDateTime(
                  location,
                  datetime.year,
                  datetime.month,
                  datetime.day,
                  datetime.hour,
                  datetime.minute,
                  datetime.second,
                  datetime.millisecond,
                  datetime.microsecond,
                ).timeZoneOffset.inSeconds,
              ),
            )
      : icu.TimeZone.unknown().withoutOffset();
  return timeZoneX;
}
