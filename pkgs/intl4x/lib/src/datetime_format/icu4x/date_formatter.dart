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
  ZonedDateTimeFormatter withTimeZoneShort() => DateFormatterZonedX.short(this);

  @override
  ZonedDateTimeFormatter withTimeZoneLong() => DateFormatterZonedX.long(this);

  @override
  ZonedDateTimeFormatter withTimeZoneShortOffset() =>
      DateFormatterZonedX.shortOffset(this);

  @override
  ZonedDateTimeFormatter withTimeZoneLongOffset() =>
      DateFormatterZonedX.longOffset(this);

  @override
  ZonedDateTimeFormatter withTimeZoneShortGeneric() =>
      DateFormatterZonedX.shortGeneric(this);

  @override
  ZonedDateTimeFormatter withTimeZoneLongGeneric() =>
      DateFormatterZonedX.longGeneric(this);
}

class DateFormatterZonedX extends FormatterZonedImpl {
  final DateFormatterX dateFormatter;
  final icu.ZonedDateFormatter formatter;

  DateFormatterZonedX.short(this.dateFormatter)
    : formatter = icu.ZonedDateFormatter.specificShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, TimeZoneType.short);

  DateFormatterZonedX.long(this.dateFormatter)
    : formatter = icu.ZonedDateFormatter.specificLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),

      super(dateFormatter.impl, TimeZoneType.long);

  DateFormatterZonedX.shortOffset(this.dateFormatter)
    : formatter = icu.ZonedDateFormatter.localizedOffsetShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, TimeZoneType.shortOffset);

  DateFormatterZonedX.longOffset(this.dateFormatter)
    : formatter = icu.ZonedDateFormatter.localizedOffsetLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, TimeZoneType.longOffset);

  DateFormatterZonedX.shortGeneric(this.dateFormatter)
    : formatter = icu.ZonedDateFormatter.genericShort(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, TimeZoneType.shortGeneric);

  DateFormatterZonedX.longGeneric(this.dateFormatter)
    : formatter = icu.ZonedDateFormatter.genericLong(
        dateFormatter.localeX,
        dateFormatter.formatter,
      ),
      super(dateFormatter.impl, TimeZoneType.longGeneric);

  @override
  String formatInternal(DateTime datetime, TimeZone timeZone) {
    final utcOffset = icu.UtcOffset.fromSeconds(timeZone.offset.inSeconds);
    final (isoDate, time) = datetime.toX;
    final timeZoneX = icu.IanaParser()
        .parse(timeZone.name)
        .withOffset(utcOffset)
        .atDateTimeIso(isoDate, time);

    return formatter.formatIso(isoDate, timeZoneX);
  }
}
