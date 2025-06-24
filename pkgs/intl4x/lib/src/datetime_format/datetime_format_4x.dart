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

  String _dateFormatter(
    icu.DateFormatter Function(
      icu.Locale locale, {
      icu.DateTimeAlignment? alignment,
      icu.DateTimeLength? length,
      icu.YearStyle? yearStyle,
    })
    f,
    icu.DateTimeLength length,
    DateTime datetime,
    TimeZone? timeZone,
  ) {
    final (alignment, yearStyle, _, optionLength) = options.toX;
    final dateFormatter = f(
      setLocaleExtensions(locale, options),
      alignment: alignment,
      length: optionLength ?? length,
      yearStyle: yearStyle,
    );
    if (timeZone != null) {
      final utcOffset = icu.UtcOffset.fromString(timeZone.offset);
      final (isoDate, time) = datetime.toX;
      final timeZoneX = icu.IanaParser()
          .parse(timeZone.name)
          .withOffset(utcOffset)
          .atDateTimeIso(isoDate, time);

      timeZoneX.setVariant(timeZone);

      final zonedDateFormatter = timeZone
          .map(
            (timeZone) => switch (timeZone.type) {
              TimeZoneType.long => icu.ZonedDateFormatter.specificLong,
              TimeZoneType.short => icu.ZonedDateFormatter.specificShort,
              TimeZoneType.shortOffset =>
                icu.ZonedDateFormatter.localizedOffsetShort,
              TimeZoneType.longOffset =>
                icu.ZonedDateFormatter.localizedOffsetLong,
              TimeZoneType.shortGeneric => icu.ZonedDateFormatter.genericShort,
              TimeZoneType.longGeneric => icu.ZonedDateFormatter.genericLong,
            },
          )
          .map((constr) => constr(locale.toX, dateFormatter));
      return zonedDateFormatter.formatIso(isoDate, timeZoneX);
    } else {
      return dateFormatter.formatIso(datetime.toX.$1);
    }
  }

  @override
  String d(DateTime datetime) {
    final (alignment, _, _, optionLength) = options.toX;
    return icu.DateFormatter.d(
      setLocaleExtensions(locale, options),
      alignment: alignment,
      length: optionLength ?? icu.DateTimeLength.short,
    ).formatIso(datetime.toX.$1);
  }

  @override
  String m(DateTime datetime) {
    final (alignment, _, _, optionLength) = options.toX;
    return icu.DateFormatter.m(
      setLocaleExtensions(locale, options),
      alignment: alignment,
      length: optionLength ?? icu.DateTimeLength.short,
    ).formatIso(datetime.toX.$1);
  }

  @override
  String md(DateTime datetime) {
    final (alignment, _, _, optionLength) = options.toX;
    return icu.DateFormatter.md(
      setLocaleExtensions(locale, options),
      alignment: alignment,
      length: optionLength ?? icu.DateTimeLength.short,
    ).formatIso(datetime.toX.$1);
  }

  @override
  String y(DateTime datetime, {TimeZone? timeZone}) => _dateFormatter(
    icu.DateFormatter.y,
    icu.DateTimeLength.long,
    datetime,
    timeZone,
  );

  @override
  String ymd(DateTime datetime, {TimeZone? timeZone}) => _dateFormatter(
    icu.DateFormatter.ymd,
    icu.DateTimeLength.short,
    datetime,
    timeZone,
  );

  @override
  String ymde(DateTime datetime, {TimeZone? timeZone}) => _dateFormatter(
    icu.DateFormatter.ymde,
    icu.DateTimeLength.short,
    datetime,
    timeZone,
  );

  @override
  String ymdt(DateTime datetime) {
    final (alignment, yearStyle, timePrecision, length) = options.toX;
    final localeX = setLocaleExtensions(locale, options);
    final (isoDate, time) = datetime.toX;
    return icu.DateTimeFormatter.ymdt(
      localeX,
      alignment: alignment,
      length: length ?? icu.DateTimeLength.short,
    ).formatIso(isoDate, time);
  }

  @override
  String time(DateTime datetime, {TimeZone? timeZone}) {
    final (alignment, yearStyle, timePrecision, length) = options.toX;
    final localeX = setLocaleExtensions(locale, options);
    final (_, time) = datetime.toX;
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

      timeZoneX.setVariant(timeZone);

      final zonedTimeFormatter = timeZone
          .map(
            (timeZone) => switch (timeZone.type) {
              TimeZoneType.long => icu.ZonedTimeFormatter.specificLong,
              TimeZoneType.short => icu.ZonedTimeFormatter.specificShort,
              TimeZoneType.shortOffset =>
                icu.ZonedTimeFormatter.localizedOffsetShort,
              TimeZoneType.longOffset =>
                icu.ZonedTimeFormatter.localizedOffsetLong,
              TimeZoneType.shortGeneric => icu.ZonedTimeFormatter.genericShort,
              TimeZoneType.longGeneric => icu.ZonedTimeFormatter.genericLong,
            },
          )
          .map((constr) => constr(locale.toX));
      return zonedTimeFormatter.format(time, timeZoneX);
    } else {
      return icu.TimeFormatter(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
        timePrecision: timePrecision,
      ).format(time);
    }
  }

  @override
  String ymdet(DateTime datetime, {TimeZone? timeZone}) {
    final (alignment, yearStyle, timePrecision, length) = options.toX;
    final localeX = setLocaleExtensions(locale, options);
    final (isoDate, time) = datetime.toX;
    final dateTimeFormatter = icu.DateTimeFormatter.ymdet(
      localeX,
      alignment: alignment,
      length: length ?? icu.DateTimeLength.short,
    );
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

      timeZoneX.setVariant(timeZone);

      final zonedDateTimeFormatter = timeZone
          .map(
            (timeZone) => switch (timeZone.type) {
              TimeZoneType.long => icu.ZonedDateTimeFormatter.specificLong,
              TimeZoneType.short => icu.ZonedDateTimeFormatter.specificShort,
              TimeZoneType.shortOffset =>
                icu.ZonedDateTimeFormatter.localizedOffsetShort,
              TimeZoneType.longOffset =>
                icu.ZonedDateTimeFormatter.localizedOffsetLong,
              TimeZoneType.shortGeneric =>
                icu.ZonedDateTimeFormatter.genericShort,
              TimeZoneType.longGeneric =>
                icu.ZonedDateTimeFormatter.genericLong,
            },
          )
          .map((constr) => constr(locale.toX, dateTimeFormatter));
      return zonedDateTimeFormatter.formatIso(isoDate, time, timeZoneX);
    } else {
      return dateTimeFormatter.formatIso(isoDate, time);
    }
  }

  String tzYmdet(DateTime datetime) {
    final (alignment, yearStyle, timePrecision, length) = options.toX;
    final localeX = setLocaleExtensions(locale, options);
    final (isoDate, time) = datetime.toX;
    return icu.DateTimeFormatter.ymdet(
      localeX,
      alignment: alignment,
      length: length ?? icu.DateTimeLength.short,
    ).formatIso(isoDate, time);
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
    final time = icu.Time(hour, minute, second, millisecond * 1_000_000);
    return (isoDate, time);
  }
}

extension on DateTimeFormatOptions {
  (
    icu.DateTimeAlignment?,
    icu.YearStyle?,
    icu.TimePrecision?,
    icu.DateTimeLength?,
  )
  get toX {
    icu.TimePrecision? timePrecision;
    if (fractionalSecondDigits != null) {
      timePrecision = icu.TimePrecision.fromSubsecondDigits(
        fractionalSecondDigits!,
      );
    } else {
      timePrecision = switch (timeFormatStyle) {
        null => icu.TimePrecision.minute,
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
      switch (dateFormatStyle) {
        TimeFormatStyle.full => icu.DateTimeLength.long,
        TimeFormatStyle.long => icu.DateTimeLength.long,
        TimeFormatStyle.medium => icu.DateTimeLength.medium,
        TimeFormatStyle.short => icu.DateTimeLength.short,
        null => null,
      },
    );
  }
}
