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
  DateTimeFormatterImpl ymdt() {
    final (alignment, yearStyle, timePrecision, length) = options.toX();
    final locale = setLocaleExtensions(localeX, options);
    return DateTimeFormatterX.ymdt(
      this,
      locale,
      alignment,
      length,
      timePrecision,
      yearStyle,
    );
  }

  @override
  DateTimeFormatterImpl ymdet() {
    final (alignment, yearStyle, timePrecision, length) = options.toX();
    final locale = setLocaleExtensions(localeX, options);
    return DateTimeFormatterX.ymdet(
      this,
      locale,
      alignment,
      length,
      timePrecision,
      yearStyle,
    );
  }

  @override
  TimeFormatterImpl time() {
    final (alignment, _, timePrecision, length) = options.toX(
      timePrecisionDefault:
          options.timestyle == TimeStyle.twodigit
              ? icu.TimePrecision.minute
              : null,
    );
    final locale = setLocaleExtensions(localeX, options);
    return TimeFormatterX.t(this, locale, timePrecision, alignment, length);
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

class DateTimeFormatterX extends DateTimeFormatterImpl {
  final icu.DateTimeFormatter formatter;
  final DateTimeFormatImpl impl;
  final icu.Locale localeX;

  DateTimeFormatterX.ymdt(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
    icu.TimePrecision? timePrecision,
    icu.YearStyle? yearStyle,
  ) : formatter = icu.DateTimeFormatter.ymdt(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
        timePrecision: timePrecision,
        yearStyle: yearStyle,
      ),
      super(impl);

  DateTimeFormatterX.ymdet(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
    icu.TimePrecision? timePrecision,
    icu.YearStyle? yearStyle,
  ) : formatter = icu.DateTimeFormatter.ymdet(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
        timePrecision: timePrecision,
        yearStyle: yearStyle,
      ),
      super(impl);

  @override
  String formatInternal(DateTime datetime) {
    final (isoDate, time) = datetime.toX;
    return formatter.formatIso(isoDate, time);
  }

  @override
  DateTimeFormatterZoned withTimezoneShort(TimeZone timeZone) =>
      DateTimeFormatterZonedX.short(this, timeZone);

  @override
  DateTimeFormatterZoned withTimezoneLong(TimeZone timeZone) =>
      DateTimeFormatterZonedX.long(this, timeZone);

  @override
  DateTimeFormatterZoned withTimeZoneShortOffset(TimeZone timeZone) =>
      DateTimeFormatterZonedX.shortOffset(this, timeZone);

  @override
  DateTimeFormatterZoned withTimeZoneLongOffset(TimeZone timeZone) =>
      DateTimeFormatterZonedX.longOffset(this, timeZone);

  @override
  DateTimeFormatterZoned withTimeZoneShortGeneric(TimeZone timeZone) =>
      DateTimeFormatterZonedX.shortGeneric(this, timeZone);

  @override
  DateTimeFormatterZoned withTimeZoneLongGeneric(TimeZone timeZone) =>
      DateTimeFormatterZonedX.longGeneric(this, timeZone);
}

class DateTimeFormatterZonedX extends DateTimeFormatterZonedImpl {
  final TimeZone timeZone;
  final DateTimeFormatterX dateFormatter;
  final icu.ZonedDateTimeFormatter formatter;

  DateTimeFormatterZonedX.short(this.dateFormatter, this.timeZone)
    : formatter = icu.ZonedDateTimeFormatter.specificShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl);

  DateTimeFormatterZonedX.long(this.dateFormatter, this.timeZone)
    : formatter = icu.ZonedDateTimeFormatter.specificLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl);

  DateTimeFormatterZonedX.shortOffset(this.dateFormatter, this.timeZone)
    : formatter = icu.ZonedDateTimeFormatter.localizedOffsetShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl);

  DateTimeFormatterZonedX.longOffset(this.dateFormatter, this.timeZone)
    : formatter = icu.ZonedDateTimeFormatter.localizedOffsetLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl);

  DateTimeFormatterZonedX.shortGeneric(this.dateFormatter, this.timeZone)
    : formatter = icu.ZonedDateTimeFormatter.genericShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl);

  DateTimeFormatterZonedX.longGeneric(this.dateFormatter, this.timeZone)
    : formatter = icu.ZonedDateTimeFormatter.genericLong(
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
    return formatter.formatIso(isoDate, time, timeZoneX);
  }
}

class TimeFormatterX extends TimeFormatterImpl {
  final icu.TimeFormatter formatter;
  final DateTimeFormatImpl impl;
  final icu.Locale localeX;

  final icu.TimePrecision? timePrecision;
  final icu.DateTimeAlignment? alignment;
  final icu.DateTimeLength? length;

  TimeFormatterX.t(
    this.impl,
    this.localeX,
    this.timePrecision,
    this.alignment,
    this.length,
  ) : formatter = icu.TimeFormatter(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
        timePrecision: timePrecision,
      ),
      super(impl);

  @override
  String formatInternal(DateTime datetime) {
    final (_, time) = datetime.toX;
    return formatter.format(time);
  }

  @override
  TimeFormatterZonedX withTimezoneShort(TimeZone timeZone) =>
      TimeFormatterZonedX.short(this, timeZone);

  @override
  TimeFormatterZoned withTimezoneLong(TimeZone timeZone) =>
      TimeFormatterZonedX.long(this, timeZone);

  @override
  TimeFormatterZoned withTimeZoneShortOffset(TimeZone timeZone) =>
      TimeFormatterZonedX.shortOffset(this, timeZone);

  @override
  TimeFormatterZoned withTimeZoneLongOffset(TimeZone timeZone) =>
      TimeFormatterZonedX.longOffset(this, timeZone);

  @override
  TimeFormatterZoned withTimeZoneShortGeneric(TimeZone timeZone) =>
      TimeFormatterZonedX.shortGeneric(this, timeZone);

  @override
  TimeFormatterZoned withTimeZoneLongGeneric(TimeZone timeZone) =>
      TimeFormatterZonedX.longGeneric(this, timeZone);
}

class TimeFormatterZonedX extends TimeFormatterZonedImpl {
  final TimeZone timeZone;
  final TimeFormatterX timeFormatter;
  final icu.ZonedTimeFormatter formatter;

  TimeFormatterZonedX.short(this.timeFormatter, this.timeZone)
    : formatter = icu.ZonedTimeFormatter.specificShort(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl);

  TimeFormatterZonedX.long(this.timeFormatter, this.timeZone)
    : formatter = icu.ZonedTimeFormatter.specificLong(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl);

  TimeFormatterZonedX.shortOffset(this.timeFormatter, this.timeZone)
    : formatter = icu.ZonedTimeFormatter.localizedOffsetShort(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl);

  TimeFormatterZonedX.longOffset(this.timeFormatter, this.timeZone)
    : formatter = icu.ZonedTimeFormatter.localizedOffsetLong(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl);

  TimeFormatterZonedX.shortGeneric(this.timeFormatter, this.timeZone)
    : formatter = icu.ZonedTimeFormatter.genericShort(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl);

  TimeFormatterZonedX.longGeneric(this.timeFormatter, this.timeZone)
    : formatter = icu.ZonedTimeFormatter.genericLong(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl);

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
    return formatter.format(time, timeZoneX);
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
