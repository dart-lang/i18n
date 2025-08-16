// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../datetime_format.dart';
import '../bindings/lib.g.dart' as icu;
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'datetime_format.dart';
import 'datetime_format_impl.dart';

DateTimeFormatImpl getDateTimeFormatter4X(
  Locale locale,
  DateTimeFormatOptions options,
) => DateTimeFormat4X(locale as Locale4x, options);

class DateTimeFormat4X extends DateTimeFormatImpl {
  DateTimeFormat4X(Locale4x super.locale, super.options);

  icu.Locale get localeX => (super.locale as Locale4x).get4X;

  String _dateTimeFormatter(
    icu.DateTimeFormatter Function(
      icu.Locale locale, {
      icu.DateTimeAlignment? alignment,
      icu.TimePrecision? timePrecision,
      icu.DateTimeLength? length,
      icu.YearStyle? yearStyle,
    })
    f,
    icu.DateTimeLength length,
    DateTime datetime,
    TimeZone? timeZone,
  ) {
    final (alignment, yearStyle, timePrecision, optionLength) = options.toX();
    final dateTimeFormatter = f(
      setLocaleExtensions(localeX, options),
      alignment: alignment,
      length: optionLength ?? length,
      timePrecision: timePrecision,
      yearStyle: yearStyle,
    );
    final (isoDate, time) = datetime.toX;
    if (timeZone != null) {
      final utcOffset = icu.UtcOffset.fromSeconds(timeZone.offset.inSeconds);
      final timeZoneX = icu.IanaParser()
          .parse(timeZone.name)
          .withOffset(utcOffset)
          .atDateTimeIso(isoDate, time);

      timeZoneX.setVariant(timeZone);

      final zonedDateFormatter = switch (timeZone.type) {
        TimeZoneType.long => icu.ZonedDateTimeFormatter.specificLong,
        TimeZoneType.short => icu.ZonedDateTimeFormatter.specificShort,
        TimeZoneType.shortOffset =>
          icu.ZonedDateTimeFormatter.localizedOffsetShort,
        TimeZoneType.longOffset =>
          icu.ZonedDateTimeFormatter.localizedOffsetLong,
        TimeZoneType.shortGeneric => icu.ZonedDateTimeFormatter.genericShort,
        TimeZoneType.longGeneric => icu.ZonedDateTimeFormatter.genericLong,
      }(localeX, dateTimeFormatter);
      return zonedDateFormatter.formatIso(isoDate, time, timeZoneX);
    } else {
      return dateTimeFormatter.formatIso(isoDate, time);
    }
  }

  @override
  DateFormatterImpl d() {
    final (alignment, _, _, length) = options.toX();
    final locale = setLocaleExtensions(localeX, options);
    return DateFormatterX.d(this, locale, alignment, length);
  }

  @override
  DateFormatterImpl m() {
    final (alignment, _, _, length) = options.toX();
    final locale = setLocaleExtensions(localeX, options);
    return DateFormatterX.m(this, locale, alignment, length);
  }

  @override
  DateFormatterImpl md() {
    final (alignment, _, _, length) = options.toX();
    final locale = setLocaleExtensions(localeX, options);
    return DateFormatterX.md(this, locale, alignment, length);
  }

  @override
  DateFormatterImpl y() {
    final (alignment, yearStyle, _, length) = options.toX();
    final locale = setLocaleExtensions(localeX, options);
    return DateFormatterX.y(this, locale, alignment, length, yearStyle);
  }

  @override
  DateFormatterImpl ymd() {
    final (alignment, yearStyle, _, length) = options.toX();
    final locale = setLocaleExtensions(localeX, options);
    return DateFormatterX.ymd(this, locale, alignment, length, yearStyle);
  }

  @override
  DateFormatterImpl ymde() {
    final (alignment, yearStyle, _, length) = options.toX();
    final locale = setLocaleExtensions(localeX, options);
    return DateFormatterX.ymde(this, locale, alignment, length, yearStyle);
  }

  @override
  String ymdt(DateTime datetime, {TimeZone? timeZone}) => _dateTimeFormatter(
    icu.DateTimeFormatter.ymdt,
    icu.DateTimeLength.short,
    datetime,
    timeZone,
  );

  @override
  String time(DateTime datetime, {TimeZone? timeZone}) {
    final (alignment, yearStyle, timePrecision, length) = options.toX(
      timePrecisionDefault:
          options.timestyle == TimeStyle.twodigit
              ? icu.TimePrecision.minute
              : null,
    );
    final localeXwithExtensions = setLocaleExtensions(localeX, options);
    final (_, time) = datetime.toX;
    if (timeZone != null) {
      final utcOffset = icu.UtcOffset.fromSeconds(timeZone.offset.inSeconds);
      final correctedDateTime = datetime.add(
        Duration(seconds: utcOffset.seconds),
      );
      final (isoDate, time) = correctedDateTime.toX;
      final timeZoneX = icu.IanaParser()
          .parse(timeZone.name)
          .withOffset(utcOffset)
          .atDateTimeIso(isoDate, time);

      timeZoneX.setVariant(timeZone);

      final zonedTimeFormatter = switch (timeZone.type) {
        TimeZoneType.long => icu.ZonedTimeFormatter.specificLong,
        TimeZoneType.short => icu.ZonedTimeFormatter.specificShort,
        TimeZoneType.shortOffset => icu.ZonedTimeFormatter.localizedOffsetShort,
        TimeZoneType.longOffset => icu.ZonedTimeFormatter.localizedOffsetLong,
        TimeZoneType.shortGeneric => icu.ZonedTimeFormatter.genericShort,
        TimeZoneType.longGeneric => icu.ZonedTimeFormatter.genericLong,
      }(localeXwithExtensions);
      return zonedTimeFormatter.format(time, timeZoneX);
    } else {
      return icu.TimeFormatter(
        localeXwithExtensions,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
        timePrecision: timePrecision,
      ).format(time);
    }
  }

  @override
  String ymdet(DateTime datetime, {TimeZone? timeZone}) {
    final (alignment, yearStyle, timePrecision, length) = options.toX();
    final localeXwithExtensions = setLocaleExtensions(localeX, options);
    final (isoDate, time) = datetime.toX;
    final dateTimeFormatter = icu.DateTimeFormatter.ymdet(
      localeXwithExtensions,
      alignment: alignment,
      timePrecision: timePrecision,
      yearStyle: yearStyle,
      length: length ?? icu.DateTimeLength.short,
    );
    if (timeZone != null) {
      final utcOffset = icu.UtcOffset.fromSeconds(timeZone.offset.inSeconds);
      final correctedDateTime = datetime.add(
        Duration(seconds: utcOffset.seconds),
      );
      final (isoDate, time) = correctedDateTime.toX;
      final timeZoneX = icu.IanaParser()
          .parse(timeZone.name)
          .withOffset(utcOffset)
          .atDateTimeIso(isoDate, time);

      timeZoneX.setVariant(timeZone);

      final zonedDateTimeFormatter = switch (timeZone.type) {
        TimeZoneType.long => icu.ZonedDateTimeFormatter.specificLong,
        TimeZoneType.short => icu.ZonedDateTimeFormatter.specificShort,
        TimeZoneType.shortOffset =>
          icu.ZonedDateTimeFormatter.localizedOffsetShort,
        TimeZoneType.longOffset =>
          icu.ZonedDateTimeFormatter.localizedOffsetLong,
        TimeZoneType.shortGeneric => icu.ZonedDateTimeFormatter.genericShort,
        TimeZoneType.longGeneric => icu.ZonedDateTimeFormatter.genericLong,
      }(localeXwithExtensions, dateTimeFormatter);
      return zonedDateTimeFormatter.formatIso(isoDate, time, timeZoneX);
    } else {
      return dateTimeFormatter.formatIso(isoDate, time);
    }
  }
}

class DateFormatterX extends DateFormatterImpl {
  final icu.DateFormatter formatter;
  final DateTimeFormatImpl impl;
  final icu.Locale localeX;

  DateFormatterX.d(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
  ) : formatter = icu.DateFormatter.d(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
      ),
      super(impl);

  DateFormatterX.m(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
  ) : formatter = icu.DateFormatter.m(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
      ),
      super(impl);

  DateFormatterX.md(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
  ) : formatter = icu.DateFormatter.md(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
      ),
      super(impl);

  DateFormatterX.y(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
    icu.YearStyle? yearStyle,
  ) : formatter = icu.DateFormatter.y(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
        yearStyle: yearStyle,
      ),
      super(impl);

  DateFormatterX.ymd(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
    icu.YearStyle? yearStyle,
  ) : formatter = icu.DateFormatter.ymd(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
        yearStyle: yearStyle,
      ),
      super(impl);

  DateFormatterX.ymde(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
    icu.YearStyle? yearStyle,
  ) : formatter = icu.DateFormatter.ymde(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
        yearStyle: yearStyle,
      ),
      super(impl);

  @override
  String formatInternal(DateTime datetime) =>
      formatter.formatIso(datetime.toX.$1);

  @override
  DateFormatterZoned withTimezoneShort(TimeZone timeZone) =>
      DateFormatterZonedX.short(this, timeZone);

  @override
  DateFormatterZoned withTimezoneLong(TimeZone timeZone) =>
      DateFormatterZonedX.long(this, timeZone);

  @override
  DateFormatterZoned withTimeZoneShortOffset(TimeZone timeZone) =>
      DateFormatterZonedX.shortOffset(this, timeZone);

  @override
  DateFormatterZoned withTimeZoneLongOffset(TimeZone timeZone) =>
      DateFormatterZonedX.longOffset(this, timeZone);

  @override
  DateFormatterZoned withTimeZoneShortGeneric(TimeZone timeZone) =>
      DateFormatterZonedX.shortGeneric(this, timeZone);

  @override
  DateFormatterZoned withTimeZoneLongGeneric(TimeZone timeZone) =>
      DateFormatterZonedX.longGeneric(this, timeZone);
}

class DateFormatterZonedX extends DateFormatterZonedImpl {
  final TimeZone timeZone;
  final DateFormatterX dateFormatter;
  final icu.ZonedDateFormatter formatter;

  DateFormatterZonedX.short(this.dateFormatter, this.timeZone)
    : formatter = icu.ZonedDateFormatter.specificShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl);

  DateFormatterZonedX.long(this.dateFormatter, this.timeZone)
    : formatter = icu.ZonedDateFormatter.specificLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl);

  DateFormatterZonedX.shortOffset(this.dateFormatter, this.timeZone)
    : formatter = icu.ZonedDateFormatter.localizedOffsetShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl);

  DateFormatterZonedX.longOffset(this.dateFormatter, this.timeZone)
    : formatter = icu.ZonedDateFormatter.localizedOffsetLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl);

  DateFormatterZonedX.shortGeneric(this.dateFormatter, this.timeZone)
    : formatter = icu.ZonedDateFormatter.genericShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl);

  DateFormatterZonedX.longGeneric(this.dateFormatter, this.timeZone)
    : formatter = icu.ZonedDateFormatter.genericLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl);

  @override
  String formatInternal(DateTime datetime) {
    final utcOffset = icu.UtcOffset.fromSeconds(timeZone.offset.inSeconds);
    // final correctedDateTime = datetime.add(
    //   Duration(seconds: utcOffset.seconds),
    // );
    final (isoDate, time) = datetime.toX;
    final timeZoneX = icu.IanaParser()
        .parse(timeZone.name)
        .withOffset(utcOffset)
        .atDateTimeIso(isoDate, time);

    if (timeZone.inferVariant) {
      timeZoneX.setVariant(timeZone);
    }
    return formatter.formatIso(isoDate, timeZoneX);
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
    final time = icu.Time(
      hour,
      minute,
      second,
      millisecond * 1_000_000 + microsecond * 1_000,
    );
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
  toX({icu.TimePrecision? timePrecisionDefault}) {
    icu.TimePrecision? timePrecision;
    if (fractionalSecondDigits != null) {
      timePrecision = icu.TimePrecision.fromSubsecondDigits(
        fractionalSecondDigits!,
      );
    } else {
      timePrecision = switch (timeFormatStyle) {
        null => timePrecisionDefault ?? icu.TimePrecision.hour,
        TimeFormatStyle.full => icu.TimePrecision.second,
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
        DateFormatStyle.full => icu.YearStyle.auto,
        DateFormatStyle.long => icu.YearStyle.auto,
        DateFormatStyle.medium => icu.YearStyle.auto,
        DateFormatStyle.short => icu.YearStyle.auto,
      },
      timePrecision,
      switch (dateFormatStyle) {
        DateFormatStyle.full => icu.DateTimeLength.long,
        DateFormatStyle.long => icu.DateTimeLength.long,
        DateFormatStyle.medium => icu.DateTimeLength.medium,
        DateFormatStyle.short => icu.DateTimeLength.short,
        null => null,
      },
    );
  }
}

icu.Locale setLocaleExtensions(
  icu.Locale locale,
  DateTimeFormatOptions options,
) {
  final l = locale.clone();
  final calendar = options.calendar;
  if (calendar != null) {
    l.setUnicodeExtension('ca', calendar.jsName);
  }
  final clockStyle = options.clockstyle;
  if (clockStyle != null) {
    l.setUnicodeExtension('hc', clockStyle.hourStyleExtensionString);
  }
  final numberingSystem = options.numberingSystem;
  if (numberingSystem != null) {
    l.setUnicodeExtension('nu', numberingSystem.name);
  }
  return l;
}
