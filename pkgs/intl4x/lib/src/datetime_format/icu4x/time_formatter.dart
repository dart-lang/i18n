// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;

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
  TimeFormatterZonedX withTimeZoneShort(TimeZone timeZone) =>
      TimeFormatterZonedX.short(this, timeZone);

  @override
  ZonedFormatter withTimeZoneLong(TimeZone timeZone) =>
      TimeFormatterZonedX.long(this, timeZone);

  @override
  ZonedFormatter withTimeZoneShortOffset(TimeZone timeZone) =>
      TimeFormatterZonedX.shortOffset(this, timeZone);

  @override
  ZonedFormatter withTimeZoneLongOffset(TimeZone timeZone) =>
      TimeFormatterZonedX.longOffset(this, timeZone);

  @override
  ZonedFormatter withTimeZoneShortGeneric(TimeZone timeZone) =>
      TimeFormatterZonedX.shortGeneric(this, timeZone);

  @override
  ZonedFormatter withTimeZoneLongGeneric(TimeZone timeZone) =>
      TimeFormatterZonedX.longGeneric(this, timeZone);
}

class TimeFormatterZonedX extends FormatterZonedImpl {
  final TimeFormatterX timeFormatter;
  final icu.ZonedTimeFormatter formatter;

  TimeFormatterZonedX.short(this.timeFormatter, TimeZone timeZone)
    : formatter = icu.ZonedTimeFormatter.specificShort(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl, timeZone, TimeZoneType.short);

  TimeFormatterZonedX.long(this.timeFormatter, TimeZone timeZone)
    : formatter = icu.ZonedTimeFormatter.specificLong(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl, timeZone, TimeZoneType.long);

  TimeFormatterZonedX.shortOffset(this.timeFormatter, TimeZone timeZone)
    : formatter = icu.ZonedTimeFormatter.localizedOffsetShort(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl, timeZone, TimeZoneType.shortOffset);

  TimeFormatterZonedX.longOffset(this.timeFormatter, TimeZone timeZone)
    : formatter = icu.ZonedTimeFormatter.localizedOffsetLong(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl, timeZone, TimeZoneType.longOffset);

  TimeFormatterZonedX.shortGeneric(this.timeFormatter, TimeZone timeZone)
    : formatter = icu.ZonedTimeFormatter.genericShort(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl, timeZone, TimeZoneType.shortGeneric);

  TimeFormatterZonedX.longGeneric(this.timeFormatter, TimeZone timeZone)
    : formatter = icu.ZonedTimeFormatter.genericLong(
        timeFormatter.localeX,
        alignment: timeFormatter.alignment,
        length: timeFormatter.length,
        timePrecision: timeFormatter.timePrecision,
      ),
      super(timeFormatter.impl, timeZone, TimeZoneType.longGeneric);

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

    if (timeZoneType.inferVariant) {
      timeZoneX.setVariant(timeZone);
    }
    return formatter.format(time, timeZoneX);
  }
}
