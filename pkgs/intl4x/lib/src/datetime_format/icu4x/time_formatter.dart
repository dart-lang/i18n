// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;

import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import '../../../datetime_format.dart';
import '../datetime_format_impl.dart';
import 'datetime_format_4x.dart';

class TimeFormatterX extends FormatterImpl {
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
  TimeFormatterZonedX withTimeZoneShort() => TimeFormatterZonedX.short(this);

  @override
  ZonedDateTimeFormatter withTimeZoneLong() => TimeFormatterZonedX.long(this);

  @override
  ZonedDateTimeFormatter withTimeZoneShortOffset() =>
      TimeFormatterZonedX.shortOffset(this);

  @override
  ZonedDateTimeFormatter withTimeZoneLongOffset() =>
      TimeFormatterZonedX.longOffset(this);

  @override
  ZonedDateTimeFormatter withTimeZoneShortGeneric() =>
      TimeFormatterZonedX.shortGeneric(this);

  @override
  ZonedDateTimeFormatter withTimeZoneLongGeneric() =>
      TimeFormatterZonedX.longGeneric(this);
}

class TimeFormatterZonedX extends FormatterZonedImpl {
  final TimeFormatterX timeFormatter;
  final icu.ZonedTimeFormatter formatter;
  bool isInitialized = false;

  TimeFormatterZonedX.short(this.timeFormatter)
    : formatter = icu.ZonedTimeFormatter.specificShort(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl, TimeZoneType.short);

  TimeFormatterZonedX.long(this.timeFormatter)
    : formatter = icu.ZonedTimeFormatter.specificLong(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl, TimeZoneType.long);

  TimeFormatterZonedX.shortOffset(this.timeFormatter)
    : formatter = icu.ZonedTimeFormatter.localizedOffsetShort(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl, TimeZoneType.shortOffset);

  TimeFormatterZonedX.longOffset(this.timeFormatter)
    : formatter = icu.ZonedTimeFormatter.localizedOffsetLong(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl, TimeZoneType.longOffset);

  TimeFormatterZonedX.shortGeneric(this.timeFormatter)
    : formatter = icu.ZonedTimeFormatter.genericShort(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl, TimeZoneType.shortGeneric);

  TimeFormatterZonedX.longGeneric(this.timeFormatter)
    : formatter = icu.ZonedTimeFormatter.genericLong(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl, TimeZoneType.longGeneric);

  @override
  String formatInternal(DateTime datetime, String timeZone) {
    final timeZoneX = timeZoneToX(timeZone, datetime);
    final (isoDate, time) = datetime.toX;
    return formatter.format(time, timeZoneX);
  }
}
