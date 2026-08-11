// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;

import '../datetime_format_impl.dart';
import '../datetime_format_options.dart';
import 'datetime_format_4x.dart';

/// Wraps an [icu.DateFormatter]
class DateFormatterX implements FormatterImpl {
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
      );

  DateFormatterX.m(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
  ) : formatter = icu.DateFormatter.m(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
      );

  DateFormatterX.md(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
  ) : formatter = icu.DateFormatter.md(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
      );

  DateFormatterX.e(this.impl, this.localeX, icu.DateTimeLength? length)
    : formatter = icu.DateFormatter.e(localeX, length);

  DateFormatterX.mde(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
  ) : formatter = icu.DateFormatter.mde(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
      );

  DateFormatterX.ym(
    this.impl,
    this.localeX,
    icu.DateTimeAlignment? alignment,
    icu.DateTimeLength? length,
    icu.YearStyle? yearStyle,
  ) : formatter = icu.DateFormatter.ym(
        localeX,
        alignment: alignment,
        length: length ?? icu.DateTimeLength.short,
        yearStyle: yearStyle,
      );

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
      );

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
      );

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
      );

  @override
  String format(DateTime datetime) => formatter.formatIso(datetime.toX.$1);

  @override
  ZonedDateTimeFormat withTimeZone(TimeZoneType timeZoneType) =>
      switch (timeZoneType) {
        TimeZoneType.short => DateFormatterZonedX.short(this),
        TimeZoneType.long => DateFormatterZonedX.long(this),
        TimeZoneType.shortOffset => DateFormatterZonedX.shortOffset(this),
        TimeZoneType.longOffset => DateFormatterZonedX.longOffset(this),
        TimeZoneType.shortGeneric => DateFormatterZonedX.shortGeneric(this),
        TimeZoneType.longGeneric => DateFormatterZonedX.longGeneric(this),
      };
}

/// Wraps an [icu.ZonedDateFormatter]
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
  String formatInternal(DateTime datetime, String timeZone) {
    final timeZoneX = timeZoneToX(timeZone, datetime);
    final (isoDate, time) = datetime.toX;

    return formatter.formatIso(isoDate, timeZoneX);
  }
}
