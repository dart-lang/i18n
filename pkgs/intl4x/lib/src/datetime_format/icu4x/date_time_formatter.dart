// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;
import 'package:timezone/data/latest.dart' show initializeTimeZones;
import 'package:timezone/timezone.dart' show getLocation;

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
  ZonedDateTimeFormatter withTimeZoneShort() =>
      DateTimeFormatterZonedX.short(this);

  @override
  ZonedDateTimeFormatter withTimeZoneLong() =>
      DateTimeFormatterZonedX.long(this);

  @override
  ZonedDateTimeFormatter withTimeZoneShortOffset() =>
      DateTimeFormatterZonedX.shortOffset(this);

  @override
  ZonedDateTimeFormatter withTimeZoneLongOffset() =>
      DateTimeFormatterZonedX.longOffset(this);

  @override
  ZonedDateTimeFormatter withTimeZoneShortGeneric() =>
      DateTimeFormatterZonedX.shortGeneric(this);

  @override
  ZonedDateTimeFormatter withTimeZoneLongGeneric() =>
      DateTimeFormatterZonedX.longGeneric(this);
}

class DateTimeFormatterZonedX extends FormatterZonedImpl {
  final DateTimeFormatterX dateFormatter;
  final icu.ZonedDateTimeFormatter formatter;

  bool isInitialized = false;

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
    if (!isInitialized) {
      initializeTimeZones();
      isInitialized = true;
    }
    final location = getLocation(timeZone);
    final utcOffset = icu.UtcOffset.fromSeconds(
      location.currentTimeZone.offset ~/ 1000,
    );
    final (isoDate, time) = datetime.toX;
    final timeZoneX = icu.IanaParser()
        .parse(timeZone)
        .withOffset(utcOffset)
        .atDateTimeIso(isoDate, time);

    return formatter.formatIso(isoDate, time, timeZoneX);
  }
}
