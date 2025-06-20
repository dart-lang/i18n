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
  icu.ZonedTimeFormatter? _zonedTime;

  DateTimeFormat4X(super.locale, super.options)
    : _dateTime =
          shouldFormatDate(options) && shouldFormatTime(options)
              ? _buildDateTime(options, locale)
              : null,
      _time =
          shouldFormatTime(options) && !shouldFormatDate(options)
              ? _buildTime(options, locale)
              : null,
      _date = !shouldFormatTime(options) ? _buildDate(options, locale) : null {
    if (_time != null) {
      _zonedTime = _buildZonedTime(options, locale);
    }
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

  static bool shouldFormatTime(DateTimeFormatOptions options) =>
      options.timeFormatStyle != null ||
      options.hour != null ||
      options.minute != null ||
      options.second != null;

  static bool shouldFormatDate(DateTimeFormatOptions options) =>
      options.dateFormatStyle != null ||
      options.year != null ||
      options.month != null ||
      options.day != null;

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
  ) {
    final localeX = setLocaleExtensions(locale, options);
    final (alignment, yearstyle, precision) = options.toX;
    return icu.TimeFormatter(
      localeX,
      timePrecision: precision,
      alignment: icu.DateTimeAlignment.auto,
      length: icu.DateTimeLength.long,
    );
  }

  static icu.DateTimeFormatter? _buildDateTime(
    DateTimeFormatOptions options,
    Locale locale,
  ) {
    final dateFormatStyle = options.dateFormatStyle;
    final timeFormatStyle = options.timeFormatStyle;

    final localeX = setLocaleExtensions(locale, options);
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

  static icu.Locale setLocaleExtensions(
    Locale locale,
    DateTimeFormatOptions options,
  ) {
    final localeX = locale.toX;
    final calendar = options.calendar;
    if (calendar != null) {
      localeX.setUnicodeExtension('ca', calendar.jsName);
    }
    final clockStyle = options.clockstyle;
    if (clockStyle != null) {
      final hourStyleExtensionString = clockStyle.hourStyleExtensionString;
      localeX.setUnicodeExtension(
        'hc',
        hourStyleExtensionString == 'h24' ? 'h23' : hourStyleExtensionString,
      );
    }
    final numberingSystem = options.numberingSystem;
    if (numberingSystem != null) {
      localeX.setUnicodeExtension('nu', numberingSystem.name);
    }
    return localeX;
  }

  static icu.DateFormatter? _buildDate(
    DateTimeFormatOptions options,
    Locale locale,
  ) {
    final (alignment, yearStyle, timePrecision) = options.toX;
    final dateFormatStyle = options.dateFormatStyle;
    final localeX = setLocaleExtensions(locale, options);
    if (dateFormatStyle == null &&
        (options.year != null ||
            options.month != null ||
            options.day != null)) {
      return switch ((options.year, options.month, options.day)) {
        (null, null, _) => icu.DateFormatter.d(
          localeX,
          alignment: alignment,
          length: icu.DateTimeLength.short,
        ),
        (null, _, _) => icu.DateFormatter.md(
          localeX,
          alignment: alignment,
          length: icu.DateTimeLength.short,
        ),
        (_, null, null) => icu.DateFormatter.y(
          localeX,
          alignment: alignment,
          length: icu.DateTimeLength.long,
        ),
        (_, _, _) => icu.DateFormatter.md(
          localeX,
          alignment: alignment,
          length: icu.DateTimeLength.short,
        ),
      };
    }
    return switch (dateFormatStyle) {
      TimeFormatStyle.full => icu.DateFormatter.ymde(
        localeX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.long,
      ),
      TimeFormatStyle.long => icu.DateFormatter.ymd(
        localeX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.long,
      ),
      TimeFormatStyle.medium => icu.DateFormatter.ymd(
        localeX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.medium,
      ),
      TimeFormatStyle.short => icu.DateFormatter.ymd(
        localeX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.short,
      ),
      null => icu.DateFormatter.ymd(
        localeX,
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
      assert([_zonedDate, _zonedTime, _zonedDateTime].nonNulls.length == 1);
      final utcOffset = icu.UtcOffset.fromString(timeZone.offset);
      final correctedDateTime = datetime.add(
        Duration(seconds: utcOffset.seconds),
      );
      final (isoDate, time) = correctedDateTime.toX;
      final timeZoneX = icu.IanaParser()
          .parse(timeZone.name)
          .withOffset(utcOffset)
          .atDateTimeIso(isoDate, time);

      timeZoneX.setVariant(timeZone);

      if (_zonedDate != null) {
        return _zonedDate!.formatIso(isoDate, timeZoneX);
      } else if (_zonedTime != null) {
        return _zonedTime!.format(time, timeZoneX);
      } else if (_zonedDateTime != null) {
        return _zonedDateTime!.formatIso(isoDate, time, timeZoneX);
      } else {
        throw StateError('''
Either date or time formatting has to be enabled if a timezone is given.''');
      }
    } else {
      assert([_date, _time, _dateTime].nonNulls.length == 1);
      final (isoDate, time) = datetime.toX;

      if (_date != null) {
        return _date.formatIso(isoDate);
      } else if (_time != null) {
        return _time.format(time);
      } else if (_dateTime != null) {
        return _dateTime.formatIso(isoDate, time);
      } else {
        throw StateError('Either date or time formatting has to be enabled.');
      }
    }
  }
}

extension on icu.TimeZoneInfo {
  void setVariant(TimeZone timeZone) {
    final success = inferVariant(icu.VariantOffsetsCalculator());
    if (!success) {
      throw ArgumentError(
        '''
The variant of ${timeZone.name} with offset ${timeZone.offset} could not be inferred''',
      );
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
    icu.TimePrecision? timePrecision;
    if (fractionalSecondDigits != null) {
      timePrecision = icu.TimePrecision.fromSubsecondDigits(
        fractionalSecondDigits!,
      );
    } else if (minute != null && second == null) {
      timePrecision = icu.TimePrecision.minute;
    } else {
      timePrecision = switch (timeFormatStyle) {
        null => null,
        TimeFormatStyle.full => icu.TimePrecision.second,
        TimeFormatStyle.long => icu.TimePrecision.second,
        TimeFormatStyle.medium => icu.TimePrecision.second,
        TimeFormatStyle.short => icu.TimePrecision.minute,
      };
    }
    final dateTimeAlignment =
        [month, day, hour].any((style) => style == TimeStyle.twodigit)
            ? icu.DateTimeAlignment.column
            : icu.DateTimeAlignment.auto;
    return (
      dateTimeAlignment,
      switch (dateFormatStyle) {
        null => icu.YearStyle.full,
        TimeFormatStyle.full => icu.YearStyle.auto,
        TimeFormatStyle.long => icu.YearStyle.auto,
        TimeFormatStyle.medium => icu.YearStyle.auto,
        TimeFormatStyle.short => icu.YearStyle.auto,
      },
      timePrecision,
    );
  }
}
