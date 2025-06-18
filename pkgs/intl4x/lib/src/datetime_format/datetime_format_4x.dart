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
  icu.ZonedDateTimeFormatter? _zonedDateTimeFormatter;
  icu.ZonedDateFormatter? _zonedDateFormatter;
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
    final timeFormatStyle = options.timeFormatStyle;
    final dateFormatStyle = options.dateFormatStyle;
    if (timeZone != null &&
        timeFormatStyle != null &&
        dateFormatStyle != null) {
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
    if (options.dateFormatStyle != null) {
      return null;
    }
    final (alignment, yearstyle, precision) = options.toX;
    return options.timeFormatStyle?.map(
      (style) => icu.TimeFormatter(
        locale.toX,
        timePrecision: precision,
        alignment: icu.DateTimeAlignment.auto,
        length: icu.DateTimeLength.long,
      ),
    );
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

    final localeX = locale.toX;
    final calendar = options.calendar;
    if (calendar != null) {
      localeX.setUnicodeExtension('ca', calendar.jsName);
    }
    final (alignment, yearStyle, timePrecision) = options.toX;
    return switch ((dateFormatStyle, timeFormatStyle)) {
      (_, _) => icu.DateTimeFormatter.ymdt(
        localeX,
        alignment: alignment,
        length: icu.DateTimeLength.short,
        timePrecision: timePrecision,
        yearStyle: yearStyle,
      ),
    };
  }

  static icu.DateFormatter? _setDateFormatter(
    DateTimeFormatOptions options,
    Locale locale,
  ) {
    final dateFormatStyle = options.dateFormatStyle;
    final timeFormatStyle = options.timeFormatStyle;

    if (timeFormatStyle != null) {
      return null;
    }
    final (alignment, yearStyle, timePrecision) = options.toX;

    return switch (dateFormatStyle) {
      TimeFormatStyle.full => icu.DateFormatter.ymde(
        locale.toX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.long,
      ),
      TimeFormatStyle.long => icu.DateFormatter.ymd(
        locale.toX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.long,
      ),
      TimeFormatStyle.medium => icu.DateFormatter.ymd(
        locale.toX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.medium,
      ),
      TimeFormatStyle.short => icu.DateFormatter.ymd(
        locale.toX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.short,
      ),
      null => icu.DateFormatter.ymd(
        locale.toX,
        alignment: alignment,
        yearStyle: yearStyle,
        length: icu.DateTimeLength.short,
      ),
    };
  }

  @override
  String formatImpl(DateTime datetime) {
    final timeZone = options.timeZone;
    if (timeZone != null) {
      final utcOffset = icu.UtcOffset.fromString(timeZone.offset);
      final correctedDateTime = datetime.add(
        Duration(seconds: utcOffset.seconds),
      );
      final (isoDate, time) = correctedDateTime.toX;
      final timeZoneX = icu.IanaParser()
          .parse(timeZone.name)
          .withOffset(utcOffset)
          .atDateTimeIso(isoDate, time);

      final success = timeZoneX.inferVariant(icu.VariantOffsetsCalculator());
      if (!success) {
        throw ArgumentError(
          '''
The variant of ${timeZone.name} with offset ${timeZone.offset} could not be inferred''',
        );
      }
      if (_zonedDateFormatter != null) {
        return _zonedDateFormatter!.formatIso(isoDate, timeZoneX);
      } else if (_zonedTimeFormatter != null) {
        return _zonedTimeFormatter.format(time, timeZoneX);
      } else if (_zonedDateTimeFormatter != null) {
        return _zonedDateTimeFormatter!.formatIso(isoDate, time, timeZoneX);
      } else {
        throw UnimplementedError('''
Either date or time formatting has to be enabled if a timezone is given.''');
      }
    } else {
      final (isoDate, time) = datetime.toX;
      if (_dateFormatter != null) {
        return _dateFormatter.formatIso(isoDate);
      } else if (_timeFormatter != null) {
        return _timeFormatter.format(time);
      } else if (_dateTimeFormatter != null) {
        return _dateTimeFormatter.formatIso(isoDate, time);
      } else {
        throw UnimplementedError(
          'Either date or time formatting has to be enabled.',
        );
      }
    }
  }
}

extension on DateTime {
  (icu.IsoDate, icu.Time) get toX {
    final isoDate = icu.IsoDate(year, month, day);
    final time = icu.Time(hour, minute, second, millisecond);
    return (isoDate, time);
  }
}

extension on DateTimeFormatOptions {
  (icu.DateTimeAlignment?, icu.YearStyle?, icu.TimePrecision?) get toX {
    return (
      switch (year) {
        null => null,
        TimeStyle.numeric => icu.DateTimeAlignment.auto,
        TimeStyle.twodigit => icu.DateTimeAlignment.column,
      },
      switch (dateFormatStyle) {
        null => icu.YearStyle.full,
        TimeFormatStyle.full => icu.YearStyle.auto,
        TimeFormatStyle.long => icu.YearStyle.auto,
        TimeFormatStyle.medium => icu.YearStyle.auto,
        TimeFormatStyle.short => icu.YearStyle.auto,
      },
      switch (timeFormatStyle) {
        null => null,
        TimeFormatStyle.full => icu.TimePrecision.second,
        TimeFormatStyle.long => icu.TimePrecision.second,
        TimeFormatStyle.medium => icu.TimePrecision.second,
        TimeFormatStyle.short => icu.TimePrecision.minute,
      },
    );
  }
}
