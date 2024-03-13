// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../bindings/lib.g.dart' as icu;
import '../data.dart';
import '../data_4x.dart';
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

DateTimeFormatImpl getDateTimeFormatter4X(
  Locale locale,
  Data data,
  DateTimeFormatOptions options,
) =>
    DateTimeFormat4X(locale, data, options);

class DateTimeFormat4X extends DateTimeFormatImpl {
  final icu.DateTimeFormatter? _dateTimeFormatter;
  final icu.DateFormatter? _dateFormatter;
  final icu.TimeFormatter? _timeFormatter;
  final icu.ZonedDateTimeFormatter? _zonedDateTimeFormatter;
  final icu.DataProvider _data;

  DateTimeFormat4X(super.locale, Data data, super.options)
      : _data = data.to4X(),
        _dateTimeFormatter = _setDateTimeFormatter(options, data, locale),
        _timeFormatter = options.timeFormatStyle != null
            ? icu.TimeFormatter.withLength(
                data.to4X(),
                locale.to4X(),
                options.dateFormatStyle?.timeTo4xOptions() ??
                    icu.TimeLength.short,
              )
            : null,
        _dateFormatter = _setDateFormatter(options, data, locale),
        _zonedDateTimeFormatter = options.timeZone != null
            ? icu.ZonedDateTimeFormatter.withLengths(
                data.to4X(),
                locale.to4X(),
                options.dateFormatStyle?.dateTo4xOptions() ??
                    icu.DateLength.short, //TODO: Check defaults
                options.timeFormatStyle?.timeTo4xOptions() ??
                    icu.TimeLength.short, //TODO: Check defaults
              )
            : null;

  static icu.DateTimeFormatter? _setDateTimeFormatter(
    DateTimeFormatOptions options,
    Data data,
    Locale locale,
  ) {
    final dateFormatStyle = options.dateFormatStyle;
    final timeFormatStyle = options.timeFormatStyle;

    if (dateFormatStyle == null || timeFormatStyle == null) {
      return null;
    }

    return icu.DateTimeFormatter.withLengths(
      data.to4X(),
      locale.to4X(),
      dateFormatStyle.dateTo4xOptions(),
      timeFormatStyle.timeTo4xOptions(),
    );
  }

  static icu.DateFormatter? _setDateFormatter(
    DateTimeFormatOptions options,
    Data data,
    Locale locale,
  ) {
    final dateFormatStyle = options.dateFormatStyle;
    final timeFormatStyle = options.timeFormatStyle;

    if (dateFormatStyle == null && timeFormatStyle != null) {
      return null;
    }

    return icu.DateFormatter.withLength(
      data.to4X(),
      locale.to4X(),
      dateFormatStyle?.dateTo4xOptions() ?? icu.DateLength.short,
    );
  }

  @override
  String formatImpl(DateTime datetime) {
    final calendarKind = options.calendar?.to4x() ?? icu.AnyCalendarKind.iso;
    final isoDateTime = icu.DateTime.fromIsoInCalendar(
      datetime.year,
      datetime.month,
      datetime.day,
      datetime.hour,
      datetime.minute,
      datetime.second,
      datetime.microsecond * 1000,
      icu.Calendar.forKind(_data, calendarKind),
    );
    if (_zonedDateTimeFormatter != null) {
      final ianaToBcp47Mapper = icu.IanaToBcp47Mapper(_data);
      final timeZone = icu.CustomTimeZone.empty()
        ..trySetIanaTimeZoneId(ianaToBcp47Mapper, options.timeZone!);
      return _zonedDateTimeFormatter.formatDatetimeWithCustomTimeZone(
        isoDateTime,
        timeZone,
      );
    } else if (_dateTimeFormatter != null) {
      return _dateTimeFormatter.formatDatetime(isoDateTime);
    } else if (_dateFormatter != null) {
      return _dateFormatter.formatDatetime(isoDateTime);
    } else if (_timeFormatter != null) {
      return _timeFormatter.formatDatetime(isoDateTime);
    } else {
      throw UnimplementedError(
          'Custom skeletons are not yet supported in ICU4X. '
          'Either date or time formatting has to be enabled.');
    }
  }
}

extension on TimeFormatStyle {
  icu.TimeLength timeTo4xOptions() => switch (this) {
        TimeFormatStyle.full => icu.TimeLength.full,
        TimeFormatStyle.long => icu.TimeLength.long,
        TimeFormatStyle.medium => icu.TimeLength.medium,
        TimeFormatStyle.short => icu.TimeLength.short,
      };
  icu.DateLength dateTo4xOptions() => switch (this) {
        TimeFormatStyle.full => icu.DateLength.full,
        TimeFormatStyle.long => icu.DateLength.long,
        TimeFormatStyle.medium => icu.DateLength.medium,
        TimeFormatStyle.short => icu.DateLength.short,
      };
}

extension on Calendar {
  icu.AnyCalendarKind to4x() => switch (this) {
        Calendar.buddhist => icu.AnyCalendarKind.buddhist,
        Calendar.chinese => icu.AnyCalendarKind.chinese,
        Calendar.coptic => icu.AnyCalendarKind.coptic,
        Calendar.dangi => icu.AnyCalendarKind.dangi,
        Calendar.ethioaa => icu.AnyCalendarKind.ethiopianAmeteAlem,
        Calendar.ethiopic => icu.AnyCalendarKind.ethiopian,
        Calendar.gregory => icu.AnyCalendarKind.gregorian,
        Calendar.hebrew => icu.AnyCalendarKind.hebrew,
        Calendar.indian => icu.AnyCalendarKind.indian,
        Calendar.islamic => icu.AnyCalendarKind.islamicObservational,
        Calendar.islamicUmalqura => icu.AnyCalendarKind.islamicUmmAlQura,
        Calendar.islamicTbla => icu.AnyCalendarKind.islamicTabular,
        Calendar.islamicCivil => icu.AnyCalendarKind.islamicCivil,
        Calendar.islamicRgsa => icu.AnyCalendarKind.islamicObservational,
        Calendar.iso8601 => icu.AnyCalendarKind.iso,
        Calendar.japanese => icu.AnyCalendarKind.japanese,
        Calendar.persian => icu.AnyCalendarKind.persian,
        Calendar.roc => icu.AnyCalendarKind.roc,
      };
}
