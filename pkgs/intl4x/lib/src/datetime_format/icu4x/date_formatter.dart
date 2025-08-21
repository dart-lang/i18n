// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;

import '../../../datetime_format.dart';
import '../datetime_format_impl.dart';
import 'datetime_format_4x.dart';

class DateFormatterX extends FormatterImpl {
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
  ZonedFormatter withTimeZoneShort(TimeZone timeZone) =>
      DateFormatterZonedX.short(this, timeZone);

  @override
  ZonedFormatter withTimeZoneLong(TimeZone timeZone) =>
      DateFormatterZonedX.long(this, timeZone);

  @override
  ZonedFormatter withTimeZoneShortOffset(TimeZone timeZone) =>
      DateFormatterZonedX.shortOffset(this, timeZone);

  @override
  ZonedFormatter withTimeZoneLongOffset(TimeZone timeZone) =>
      DateFormatterZonedX.longOffset(this, timeZone);

  @override
  ZonedFormatter withTimeZoneShortGeneric(TimeZone timeZone) =>
      DateFormatterZonedX.shortGeneric(this, timeZone);

  @override
  ZonedFormatter withTimeZoneLongGeneric(TimeZone timeZone) =>
      DateFormatterZonedX.longGeneric(this, timeZone);
}

class DateFormatterZonedX extends FormatterZonedImpl {
  final DateFormatterX dateFormatter;
  final icu.ZonedDateFormatter formatter;

  DateFormatterZonedX.short(this.dateFormatter, TimeZone timeZone)
    : formatter = icu.ZonedDateFormatter.specificShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, timeZone, TimeZoneType.short);

  DateFormatterZonedX.long(this.dateFormatter, TimeZone timeZone)
    : formatter = icu.ZonedDateFormatter.specificLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),

      super(dateFormatter.impl, timeZone, TimeZoneType.long);

  DateFormatterZonedX.shortOffset(this.dateFormatter, TimeZone timeZone)
    : formatter = icu.ZonedDateFormatter.localizedOffsetShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, timeZone, TimeZoneType.shortOffset);

  DateFormatterZonedX.longOffset(this.dateFormatter, TimeZone timeZone)
    : formatter = icu.ZonedDateFormatter.localizedOffsetLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, timeZone, TimeZoneType.longOffset);

  DateFormatterZonedX.shortGeneric(this.dateFormatter, TimeZone timeZone)
    : formatter = icu.ZonedDateFormatter.genericShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, timeZone, TimeZoneType.shortGeneric);

  DateFormatterZonedX.longGeneric(this.dateFormatter, TimeZone timeZone)
    : formatter = icu.ZonedDateFormatter.genericLong(
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
    return formatter.formatIso(isoDate, timeZoneX);
  }
}
