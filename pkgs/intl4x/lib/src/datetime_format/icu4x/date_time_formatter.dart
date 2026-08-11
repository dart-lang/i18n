// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;

import '../datetime_format_impl.dart';
import '../datetime_format_options.dart';
import 'datetime_format_4x.dart';

/// Wraps an [icu.DateTimeFormatter]
class DateTimeFormatterX implements FormatterImpl {
  final icu.DateTimeFormatter formatter;
  final DateTimeFormatImpl impl;
  final icu.Locale localeX;

  DateTimeFormatterX.mdt(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
    icu.TimePrecision? timePrecision,
  ) : formatter = icu.DateTimeFormatter.mdt(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
        timePrecision: timePrecision,
      );

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
      );

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
      );

  @override
  String format(DateTime datetime) {
    final (isoDate, time) = datetime.toX;
    return formatter.formatIso(isoDate, time);
  }

  @override
  ZonedDateTimeFormat withTimeZone(TimeZoneType timeZoneType) =>
      switch (timeZoneType) {
        TimeZoneType.short => DateTimeFormatterZonedX.short(this),
        TimeZoneType.long => DateTimeFormatterZonedX.long(this),
        TimeZoneType.shortOffset => DateTimeFormatterZonedX.shortOffset(this),
        TimeZoneType.longOffset => DateTimeFormatterZonedX.longOffset(this),
        TimeZoneType.shortGeneric => DateTimeFormatterZonedX.shortGeneric(this),
        TimeZoneType.longGeneric => DateTimeFormatterZonedX.longGeneric(this),
      };
}

/// Wraps an [icu.ZonedDateTimeFormatter]
class DateTimeFormatterZonedX extends FormatterZonedImpl {
  final DateTimeFormatterX dateFormatter;
  final icu.ZonedDateTimeFormatter formatter;

  DateTimeFormatterZonedX.short(this.dateFormatter)
    : formatter = icu.ZonedDateTimeFormatter.specificShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, TimeZoneType.short);

  DateTimeFormatterZonedX.long(this.dateFormatter)
    : formatter = icu.ZonedDateTimeFormatter.specificLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, TimeZoneType.long);

  DateTimeFormatterZonedX.shortOffset(this.dateFormatter)
    : formatter = icu.ZonedDateTimeFormatter.localizedOffsetShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, TimeZoneType.shortOffset);

  DateTimeFormatterZonedX.longOffset(this.dateFormatter)
    : formatter = icu.ZonedDateTimeFormatter.localizedOffsetLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, TimeZoneType.longOffset);

  DateTimeFormatterZonedX.shortGeneric(this.dateFormatter)
    : formatter = icu.ZonedDateTimeFormatter.genericShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, TimeZoneType.shortGeneric);

  DateTimeFormatterZonedX.longGeneric(this.dateFormatter)
    : formatter = icu.ZonedDateTimeFormatter.genericLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, TimeZoneType.longGeneric);

  @override
  String formatInternal(DateTime datetime, String timeZone) {
    final timeZoneX = timeZoneToX(timeZone, datetime);
    final (isoDate, time) = datetime.toX;

    return formatter.formatIso(isoDate, time, timeZoneX);
  }
}
