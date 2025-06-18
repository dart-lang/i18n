// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../datetime_format.dart';
import '../bindings/lib.g.dart' as icu;
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import '../utils.dart';
import 'datetime_format_impl.dart';

DateTimeFormatImpl getDateTimeFormatter4X(
  Locale locale,
  DateTimeFormatOptions options,
) => DateTimeFormat4X(locale, options);

class DateTimeFormat4X extends DateTimeFormatImpl {
  final icu.DateTimeFormatter? _dateTime;
  final icu.DateFormatter? _date;
  final icu.TimeFormatter? _time;
  icu.ZonedDateTimeFormatter? _zonedDateTime;
  icu.ZonedDateFormatter? _zonedDate;
  final icu.ZonedTimeFormatter? _zonedTime;

  DateTimeFormat4X(super.locale, super.options)
    : _dateTime =
          options.dateFormatStyle != null && options.timeFormatStyle != null
              ? _buildDateTime(options, locale)
              : null,
      _time =
          options.dateFormatStyle == null ? _buildTime(options, locale) : null,
      _date = _buildDate(options, locale),
      _zonedTime =
          options.timeFormatStyle != null
              ? _buildZonedTime(options, locale)
              : null {
    if (_date != null) {
      _zonedDate = _buildZonedDate(options, locale, _date);
    }
    if (_dateTime != null) {
      _zonedDateTime =
          options.timeFormatStyle != null && options.dateFormatStyle != null
              ? _buildZonedDateTime(options, locale, _dateTime)
              : null;
    }
  }

  static icu.ZonedDateTimeFormatter? _buildZonedDateTime(
    DateTimeFormatOptions options,
    Locale locale,
    icu.DateTimeFormatter df,
  ) => options.timeZone
      ?.map(
        (timeZone) => switch (timeZone.type) {
          TimeZoneType.long => icu.ZonedDateTimeFormatter.specificLong,
          TimeZoneType.short => icu.ZonedDateTimeFormatter.specificShort,
          TimeZoneType.shortOffset =>
            icu.ZonedDateTimeFormatter.localizedOffsetShort,
          TimeZoneType.longOffset =>
            icu.ZonedDateTimeFormatter.localizedOffsetLong,
          TimeZoneType.shortGeneric => icu.ZonedDateTimeFormatter.genericShort,
          TimeZoneType.longGeneric => icu.ZonedDateTimeFormatter.genericLong,
        },
      )
      .map((constr) => constr(locale.toX, df));

  static icu.ZonedDateFormatter? _buildZonedDate(
    DateTimeFormatOptions options,
    Locale locale,
    icu.DateFormatter df,
  ) => options.timeZone
      ?.map(
        (timeZone) => switch (timeZone.type) {
          TimeZoneType.long => icu.ZonedDateFormatter.specificLong,
          TimeZoneType.short => icu.ZonedDateFormatter.specificShort,
          TimeZoneType.shortOffset =>
            icu.ZonedDateFormatter.localizedOffsetShort,
          TimeZoneType.longOffset => icu.ZonedDateFormatter.localizedOffsetLong,
          TimeZoneType.shortGeneric => icu.ZonedDateFormatter.genericShort,
          TimeZoneType.longGeneric => icu.ZonedDateFormatter.genericLong,
        },
      )
      .map((constructor) => constructor(locale.toX, df));

  static icu.ZonedTimeFormatter? _buildZonedTime(
    DateTimeFormatOptions options,
    Locale locale,
  ) => options.timeZone
      ?.map(
        (timeZone) => switch (timeZone.type) {
          TimeZoneType.long => icu.ZonedTimeFormatter.specificLong,
          TimeZoneType.short => icu.ZonedTimeFormatter.specificShort,
          TimeZoneType.shortOffset =>
            icu.ZonedTimeFormatter.localizedOffsetShort,
          TimeZoneType.longOffset => icu.ZonedTimeFormatter.localizedOffsetLong,
          TimeZoneType.shortGeneric => icu.ZonedTimeFormatter.genericShort,
          TimeZoneType.longGeneric => icu.ZonedTimeFormatter.genericLong,
        },
      )
      .map((constructor) => constructor(locale.toX));

  static icu.TimeFormatter? _buildTime(
    DateTimeFormatOptions options,
    Locale locale,
  ) => options.timeFormatStyle?.map((style) {
    final (alignment, yearstyle, precision) = options.toX;
    return icu.TimeFormatter(
      locale.toX,
      timePrecision: precision,
      alignment: icu.DateTimeAlignment.auto,
      length: icu.DateTimeLength.long,
    );
  });

  static icu.DateTimeFormatter? _buildDateTime(
    DateTimeFormatOptions options,
    Locale locale,
  ) {
    final dateFormatStyle = options.dateFormatStyle;
    final timeFormatStyle = options.timeFormatStyle;

    final localeX = locale.toX;
    final calendar = options.calendar;
    if (calendar != null) {
      localeX.setUnicodeExtension('ca', calendar.jsName);
    }
    final (alignment, yearStyle, timePrecision) = options.toX;
    return switch ((dateFormatStyle, timeFormatStyle)) {
      (_, _) => icu.DateTimeFormatter.ymdt(
        localeX,
        alignment: alignment,
        length: icu.DateTimeLength.short,
        timePrecision: timePrecision,
        yearStyle: yearStyle,
      ),
    };
  }

  static icu.DateFormatter? _buildDate(
    DateTimeFormatOptions options,
    Locale locale,
  ) {
    final timeFormatStyle = options.timeFormatStyle;

    if (timeFormatStyle != null) {
      // Use the time or datetime formatters
      return null;
    }

    final (alignment, yearStyle, timePrecision) = options.toX;
    final dateFormatStyle = options.dateFormatStyle;
    return switch (dateFormatStyle) {
      TimeFormatStyle.full => icu.DateFormatter.ymde(
        locale.toX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.long,
      ),
      TimeFormatStyle.long => icu.DateFormatter.ymd(
        locale.toX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.long,
      ),
      TimeFormatStyle.medium => icu.DateFormatter.ymd(
        locale.toX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.medium,
      ),
      TimeFormatStyle.short => icu.DateFormatter.ymd(
        locale.toX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.short,
      ),
      null => icu.DateFormatter.ymd(
        locale.toX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.short,
      ),
    };
  }

  @override
  String formatImpl(DateTime datetime) {
    final timeZone = options.timeZone;
    if (timeZone != null) {
      final utcOffset = icu.UtcOffset.fromString(timeZone.offset);
      final correctedDateTime = datetime.add(
        Duration(seconds: utcOffset.seconds),
      );
      final (isoDate, time) = correctedDateTime.toX;
      final timeZoneX = icu.IanaParser()
          .parse(timeZone.name)
          .withOffset(utcOffset)
          .atDateTimeIso(isoDate, time);

      final success = timeZoneX.inferVariant(icu.VariantOffsetsCalculator());
      if (!success) {
        throw ArgumentError(
          '''
The variant of ${timeZone.name} with offset ${timeZone.offset} could not be inferred''',
        );
      }
      if (_zonedDate != null) {
        return _zonedDate!.formatIso(isoDate, timeZoneX);
      } else if (_zonedTime != null) {
        return _zonedTime.format(time, timeZoneX);
      } else if (_zonedDateTime != null) {
        return _zonedDateTime!.formatIso(isoDate, time, timeZoneX);
      } else {
        throw UnimplementedError('''
Either date or time formatting has to be enabled if a timezone is given.''');
      }
    } else {
      final (isoDate, time) = datetime.toX;
      if (_date != null) {
        return _date.formatIso(isoDate);
      } else if (_time != null) {
        return _time.format(time);
      } else if (_dateTime != null) {
        return _dateTime.formatIso(isoDate, time);
      } else {
        throw UnimplementedError(
          'Either date or time formatting has to be enabled.',
        );
      }
    }
  }
}

extension on DateTime {
  (icu.IsoDate, icu.Time) get toX {
    final isoDate = icu.IsoDate(year, month, day);
    final time = icu.Time(hour, minute, second, millisecond);
    return (isoDate, time);
  }
}

extension on DateTimeFormatOptions {
  (icu.DateTimeAlignment?, icu.YearStyle?, icu.TimePrecision?) get toX {
    return (
      switch (year) {
        null => null,
        TimeStyle.numeric => icu.DateTimeAlignment.auto,
        TimeStyle.twodigit => icu.DateTimeAlignment.column,
      },
      switch (dateFormatStyle) {
        null => icu.YearStyle.full,
        TimeFormatStyle.full => icu.YearStyle.auto,
        TimeFormatStyle.long => icu.YearStyle.auto,
        TimeFormatStyle.medium => icu.YearStyle.auto,
        TimeFormatStyle.short => icu.YearStyle.auto,
      },
      switch (timeFormatStyle) {
        null => null,
        TimeFormatStyle.full => icu.TimePrecision.second,
        TimeFormatStyle.long => icu.TimePrecision.second,
        TimeFormatStyle.medium => icu.TimePrecision.second,
        TimeFormatStyle.short => icu.TimePrecision.minute,
      },
    );
  }
}
