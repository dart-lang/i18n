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
  DateTimeFormat4X(super.locale, super.options);

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
      localeX.setUnicodeExtension('hc', hourStyleExtensionString);
    }
    final numberingSystem = options.numberingSystem;
    if (numberingSystem != null) {
      localeX.setUnicodeExtension('nu', numberingSystem.name);
    }
    return localeX;
  }

  @override
  String d(DateTime datetime) {
    return _dateFormatter(
      icu.DateFormatter.d,
      icu.DateTimeLength.short,
      datetime,
    );
  }

  String _dateFormatter(
    icu.DateFormatter Function(
      icu.Locale locale, {
      icu.DateTimeAlignment? alignment,
      icu.DateTimeLength? length,
    })
    f,
    icu.DateTimeLength length,
    DateTime datetime,
  ) {
    final (alignment, yearStyle, timePrecision) = options.toX;
    final localeX = setLocaleExtensions(locale, options);
    return f(
      localeX,
      alignment: alignment,
      length: switch (options.dateFormatStyle) {
        TimeFormatStyle.full => icu.DateTimeLength.long,
        TimeFormatStyle.long => icu.DateTimeLength.long,
        TimeFormatStyle.medium => icu.DateTimeLength.medium,
        TimeFormatStyle.short => icu.DateTimeLength.short,
        null => length,
      },
    ).formatIso(datetime.toX.$1);
  }

  String _dateTimeFormatter(
    icu.DateTimeFormatter Function(
      icu.Locale locale, {
      icu.DateTimeLength? length,
      icu.TimePrecision? timePrecision,
      icu.DateTimeAlignment? alignment,
      icu.YearStyle? yearStyle,
    })
    f,
    DateTime datetime,
  ) {
    final (alignment, yearStyle, timePrecision) = options.toX;
    final localeX = setLocaleExtensions(locale, options);
    final (isoDate, time) = datetime.toX;
    return f(
      localeX,
      alignment: alignment,
      length: icu.DateTimeLength.short,
    ).formatIso(isoDate, time);
  }

  @override
  String m(DateTime datetime) =>
      _dateFormatter(icu.DateFormatter.m, icu.DateTimeLength.short, datetime);

  @override
  String md(DateTime datetime) =>
      _dateFormatter(icu.DateFormatter.md, icu.DateTimeLength.short, datetime);

  @override
  String y(DateTime datetime) =>
      _dateFormatter(icu.DateFormatter.y, icu.DateTimeLength.long, datetime);

  @override
  String ymd(DateTime datetime) =>
      _dateFormatter(icu.DateFormatter.ymd, icu.DateTimeLength.short, datetime);

  @override
  String ymde(DateTime datetime) => _dateFormatter(
    icu.DateFormatter.ymde,
    icu.DateTimeLength.short,
    datetime,
  );

  @override
  String ymdt(DateTime datetime) =>
      _dateTimeFormatter(icu.DateTimeFormatter.ymdt, datetime);
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
    final time = icu.Time(hour, minute, second, millisecond * 1_000_000);
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
      // } else if (minute != null && second == null) {
      //   timePrecision = icu.TimePrecision.minute;
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
        timestyle == TimeStyle.twodigit
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
