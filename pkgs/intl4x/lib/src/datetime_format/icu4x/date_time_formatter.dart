// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;

import '../../../datetime_format.dart';
import '../datetime_format_impl.dart';
import 'datetime_format_4x.dart';

class DateTimeFormatterX extends FormatterImpl {
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
      ),
      super(impl);

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
  ZonedFormatter withTimeZoneShort(TimeZone timeZone) =>
      DateTimeFormatterZonedX.short(this, timeZone);

  @override
  ZonedFormatter withTimeZoneLong(TimeZone timeZone) =>
      DateTimeFormatterZonedX.long(this, timeZone);

  @override
  ZonedFormatter withTimeZoneShortOffset(TimeZone timeZone) =>
      DateTimeFormatterZonedX.shortOffset(this, timeZone);

  @override
  ZonedFormatter withTimeZoneLongOffset(TimeZone timeZone) =>
      DateTimeFormatterZonedX.longOffset(this, timeZone);

  @override
  ZonedFormatter withTimeZoneShortGeneric(TimeZone timeZone) =>
      DateTimeFormatterZonedX.shortGeneric(this, timeZone);

  @override
  ZonedFormatter withTimeZoneLongGeneric(TimeZone timeZone) =>
      DateTimeFormatterZonedX.longGeneric(this, timeZone);
}

class DateTimeFormatterZonedX extends FormatterZonedImpl {
  final DateTimeFormatterX dateFormatter;
  final icu.ZonedDateTimeFormatter formatter;

  DateTimeFormatterZonedX.short(this.dateFormatter, TimeZone timeZone)
    : formatter = icu.ZonedDateTimeFormatter.specificShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, timeZone, TimeZoneType.short);

  DateTimeFormatterZonedX.long(this.dateFormatter, TimeZone timeZone)
    : formatter = icu.ZonedDateTimeFormatter.specificLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, timeZone, TimeZoneType.long);

  DateTimeFormatterZonedX.shortOffset(this.dateFormatter, TimeZone timeZone)
    : formatter = icu.ZonedDateTimeFormatter.localizedOffsetShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, timeZone, TimeZoneType.shortOffset);

  DateTimeFormatterZonedX.longOffset(this.dateFormatter, TimeZone timeZone)
    : formatter = icu.ZonedDateTimeFormatter.localizedOffsetLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, timeZone, TimeZoneType.longOffset);

  DateTimeFormatterZonedX.shortGeneric(this.dateFormatter, TimeZone timeZone)
    : formatter = icu.ZonedDateTimeFormatter.genericShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, timeZone, TimeZoneType.shortGeneric);

  DateTimeFormatterZonedX.longGeneric(this.dateFormatter, TimeZone timeZone)
    : formatter = icu.ZonedDateTimeFormatter.genericLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, timeZone, TimeZoneType.longGeneric);

  @override
  String formatInternal(DateTime datetime) {
    final utcOffset = icu.UtcOffset.fromSeconds(timeZone.offset.inSeconds);
    final (isoDate, time) = datetime.toX;
    final timeZoneX = icu.IanaParser()
        .parse(timeZone.name)
        .withOffset(utcOffset)
        .atDateTimeIso(isoDate, time);

    if (timeZoneType.inferVariant) {
      timeZoneX.setVariant(timeZone);
    }
    return formatter.formatIso(isoDate, time, timeZoneX);
  }
}
