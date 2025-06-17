// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../datetime_format.dart';
import '../bindings/lib.g.dart' as icu;
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import '../utils.dart';
import 'datetime_format_impl.dart';

DateTimeFormatImpl getDateTimeFormatter4X(
  Locale locale,
  DateTimeFormatOptions options,
) => DateTimeFormat4X(locale, options);

class DateTimeFormat4X extends DateTimeFormatImpl {
  final icu.DateTimeFormatter? _dateTimeFormatter;
  final icu.DateFormatter? _dateFormatter;
  final icu.TimeFormatter? _timeFormatter;
  late final icu.ZonedDateTimeFormatter? _zonedDateTimeFormatter;
  late final icu.ZonedDateFormatter? _zonedDateFormatter;
  final icu.ZonedTimeFormatter? _zonedTimeFormatter;

  DateTimeFormat4X(super.locale, super.options)
    : _dateTimeFormatter = _setDateTimeFormatter(options, locale),
      _timeFormatter = _setTimeFormatter(options, locale),
      _dateFormatter = _setDateFormatter(options, locale),
      _zonedTimeFormatter = _setZonedTimeFormatter(options, locale) {
    if (_dateFormatter != null) {
      _zonedDateFormatter = _setZonedDateFormatter(
        options,
        locale,
        _dateFormatter,
      );
    }
    if (_dateTimeFormatter != null) {
      _zonedDateTimeFormatter = _setZonedDateTimeFormatter(
        options,
        locale,
        _dateTimeFormatter,
      );
    }
  }

  static icu.ZonedDateTimeFormatter? _setZonedDateTimeFormatter(
    DateTimeFormatOptions options,
    Locale locale,
    icu.DateTimeFormatter df,
  ) {
    final timeZone = options.timeZone;
    if (timeZone != null) {
      final constr = switch (timeZone.type) {
        TimeZoneType.long => icu.ZonedDateTimeFormatter.specificLong,
        TimeZoneType.short => icu.ZonedDateTimeFormatter.specificShort,
        TimeZoneType.shortOffset =>
          icu.ZonedDateTimeFormatter.localizedOffsetShort,
        TimeZoneType.longOffset =>
          icu.ZonedDateTimeFormatter.localizedOffsetLong,
        TimeZoneType.shortGeneric => icu.ZonedDateTimeFormatter.genericShort,
        TimeZoneType.longGeneric => icu.ZonedDateTimeFormatter.genericLong,
      };

      return constr(locale.toX, df);
    } else {
      return null;
    }
  }

  static icu.ZonedDateFormatter? _setZonedDateFormatter(
    DateTimeFormatOptions options,
    Locale locale,
    icu.DateFormatter df,
  ) {
    final timeZone = options.timeZone;
    if (timeZone != null) {
      final constr = switch (timeZone.type) {
        TimeZoneType.long => icu.ZonedDateFormatter.specificLong,
        TimeZoneType.short => icu.ZonedDateFormatter.specificShort,
        TimeZoneType.shortOffset => icu.ZonedDateFormatter.localizedOffsetShort,
        TimeZoneType.longOffset => icu.ZonedDateFormatter.localizedOffsetLong,
        TimeZoneType.shortGeneric => icu.ZonedDateFormatter.genericShort,
        TimeZoneType.longGeneric => icu.ZonedDateFormatter.genericLong,
      };

      return constr(locale.toX, df);
    } else {
      return null;
    }
  }

  static icu.ZonedTimeFormatter? _setZonedTimeFormatter(
    DateTimeFormatOptions options,
    Locale locale,
  ) {
    final timeZone = options.timeZone;
    final timeFormatStyle = options.timeFormatStyle;
    if (timeZone != null && timeFormatStyle != null) {
      final constr = switch (timeZone.type) {
        TimeZoneType.long => icu.ZonedTimeFormatter.specificLong,
        TimeZoneType.short => icu.ZonedTimeFormatter.specificShort,
        TimeZoneType.shortOffset => icu.ZonedTimeFormatter.localizedOffsetShort,
        TimeZoneType.longOffset => icu.ZonedTimeFormatter.localizedOffsetLong,
        TimeZoneType.shortGeneric => icu.ZonedTimeFormatter.genericShort,
        TimeZoneType.longGeneric => icu.ZonedTimeFormatter.genericLong,
      };

      return constr(locale.toX);
    } else {
      return null;
    }
  }

  static icu.TimeFormatter? _setTimeFormatter(
    DateTimeFormatOptions options,
    Locale locale,
  ) {
    final timeFormatStyle = options.timeFormatStyle;
    if (timeFormatStyle != null) {
      return icu.TimeFormatter(locale.toX);
    } else {
      return null;
    }
  }

  static icu.DateTimeFormatter? _setDateTimeFormatter(
    DateTimeFormatOptions options,
    Locale locale,
  ) {
    final dateFormatStyle = options.dateFormatStyle;
    final timeFormatStyle = options.timeFormatStyle;

    if (dateFormatStyle == null || timeFormatStyle == null) {
      return null;
    }

    final calendar = options.calendar?.toX.map(icu.Calendar.new);

    final localeX = locale.toX;
    if (calendar != null) {
      localeX.setUnicodeExtension('ca', calendar.kind.name);
    }
    return icu.DateTimeFormatter.det(localeX);
  }

  static icu.DateFormatter? _setDateFormatter(
    DateTimeFormatOptions options,
    Locale locale,
  ) {
    final dateFormatStyle = options.dateFormatStyle;
    final timeFormatStyle = options.timeFormatStyle;

    if (dateFormatStyle == null && timeFormatStyle != null) {
      return null;
    }
    final (alignment, yearStyle, timePrecision) = options.toX;

    return icu.DateFormatter.d(locale.toX);
  }

  @override
  String formatImpl(DateTime datetime) {
    final isoDate = icu.IsoDate(datetime.year, datetime.month, datetime.day);
    final time = icu.Time(
      datetime.hour,
      datetime.minute,
      datetime.second,
      datetime.millisecond,
    );
    if (_zonedDateTimeFormatter != null) {
      final timeZone = icu.IanaParser().parse(options.timeZone!.name);
      return _zonedDateTimeFormatter.formatIso(
        isoDate,
        time,
        timeZone.withoutOffset(),
      );
    } else if (_zonedDateFormatter != null) {
      final timeZone = icu.IanaParser().parse(options.timeZone!.name);
      return _zonedDateFormatter.formatIso(isoDate, timeZone.withoutOffset());
    } else if (_zonedTimeFormatter != null) {
      final timeZone = icu.IanaParser().parse(options.timeZone!.name);
      return _zonedTimeFormatter.format(time, timeZone.withoutOffset());
    } else if (_dateTimeFormatter != null) {
      return _dateTimeFormatter.formatIso(isoDate, time);
    } else if (_dateFormatter != null) {
      return _dateFormatter.formatIso(isoDate);
    } else if (_timeFormatter != null) {
      return _timeFormatter.format(time);
    } else {
      throw UnimplementedError(
        'Custom skeletons are not yet supported in ICU4X. '
        'Either date or time formatting has to be enabled.',
      );
    }
  }
}

extension on TimeFormatStyle {
  icu.DateTimeLength get t2oX => switch (this) {
    TimeFormatStyle.full => icu.DateTimeLength.long, //TODO: Does this match?
    TimeFormatStyle.long => icu.DateTimeLength.long,
    TimeFormatStyle.medium => icu.DateTimeLength.medium,
    TimeFormatStyle.short => icu.DateTimeLength.short,
  };
}

extension on DateTimeFormatOptions {
  (icu.DateTimeAlignment?, icu.YearStyle?, icu.TimePrecision?) get toX {
    var yearStyle;
    var timePrecision;
    return (alignmentX, yearStyle, timePrecision);
  }

  icu.DateTimeAlignment? get alignmentX {
    final alignment = switch (year) {
      null => null,
      TimeStyle.numeric => icu.DateTimeAlignment.auto,
      TimeStyle.twodigit => icu.DateTimeAlignment.column,
    };
    return alignment;
  }
}

extension on Calendar {
  icu.CalendarKind get toX => switch (this) {
    Calendar.buddhist => icu.CalendarKind.buddhist,
    Calendar.chinese => icu.CalendarKind.chinese,
    Calendar.coptic => icu.CalendarKind.coptic,
    Calendar.dangi => icu.CalendarKind.dangi,
    Calendar.ethioaa => icu.CalendarKind.ethiopianAmeteAlem,
    Calendar.ethiopic => icu.CalendarKind.ethiopian,
    Calendar.gregory => icu.CalendarKind.gregorian,
    Calendar.hebrew => icu.CalendarKind.hebrew,
    Calendar.indian => icu.CalendarKind.indian,
    Calendar.islamic => icu.CalendarKind.hijriTabularTypeIiThursday,
    Calendar.islamicUmalqura => icu.CalendarKind.hijriUmmAlQura,
    Calendar.islamicTbla => icu.CalendarKind.hijriTabularTypeIiThursday,
    Calendar.islamicCivil => icu.CalendarKind.hijriTabularTypeIiFriday,
    Calendar.islamicRgsa => icu.CalendarKind.hijriSimulatedMecca,
    Calendar.iso8601 => icu.CalendarKind.iso,
    Calendar.japanese => icu.CalendarKind.japanese,
    Calendar.persian => icu.CalendarKind.persian,
    Calendar.roc => icu.CalendarKind.roc,
  };
}
