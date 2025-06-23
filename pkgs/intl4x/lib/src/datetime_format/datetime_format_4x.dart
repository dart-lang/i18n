// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../datetime_format.dart';
import '../bindings/lib.g.dart' as icu;
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'datetime_format_impl.dart';

DateTimeFormatImpl getDateTimeFormatter4X(
  Locale locale,
  DateTimeFormatOptions options,
) => DateTimeFormat4X(locale, options);

class DateTimeFormat4X extends DateTimeFormatImpl {
  DateTimeFormat4X(super.locale, super.options);

  static icu.Locale setLocaleExtensions(
    Locale locale,
    DateTimeFormatOptions options,
  ) {
    final localeX = locale.toX;
    final calendar = options.calendar;
    if (calendar != null) {
      localeX.setUnicodeExtension('ca', calendar.jsName);
    }
    final clockStyle = options.clockstyle;
    if (clockStyle != null) {
      final hourStyleExtensionString = clockStyle.hourStyleExtensionString;
      localeX.setUnicodeExtension('hc', hourStyleExtensionString);
    }
    final numberingSystem = options.numberingSystem;
    if (numberingSystem != null) {
      localeX.setUnicodeExtension('nu', numberingSystem.name);
    }
    return localeX;
  }

  String _dateFormatter(
    icu.DateFormatter Function(
      icu.Locale locale, {
      icu.DateTimeAlignment? alignment,
      icu.DateTimeLength? length,
      icu.YearStyle? yearStyle,
    })
    f,
    icu.DateTimeLength length,
    DateTime datetime,
  ) {
    final (alignment, yearStyle, timePrecision, optionLength) = options.toX;
    return f(
      setLocaleExtensions(locale, options),
      alignment: alignment,
      length: optionLength ?? length,
      yearStyle: yearStyle,
    ).formatIso(datetime.toX.$1);
  }

  String _dateTimeFormatter(
    icu.DateTimeFormatter Function(
      icu.Locale locale, {
      icu.DateTimeLength? length,
      icu.TimePrecision? timePrecision,
      icu.DateTimeAlignment? alignment,
      icu.YearStyle? yearStyle,
    })
    f,
    DateTime datetime,
  ) {
    final (alignment, yearStyle, timePrecision, length) = options.toX;
    final localeX = setLocaleExtensions(locale, options);
    final (isoDate, time) = datetime.toX;
    return f(
      localeX,
      alignment: alignment,
      length: length ?? icu.DateTimeLength.short,
    ).formatIso(isoDate, time);
  }

  @override
  String d(DateTime datetime) {
    final (alignment, _, _, optionLength) = options.toX;
    return icu.DateFormatter.d(
      setLocaleExtensions(locale, options),
      alignment: alignment,
      length: optionLength ?? icu.DateTimeLength.short,
    ).formatIso(datetime.toX.$1);
  }

  @override
  String m(DateTime datetime) {
    final (alignment, _, _, optionLength) = options.toX;
    return icu.DateFormatter.m(
      setLocaleExtensions(locale, options),
      alignment: alignment,
      length: optionLength ?? icu.DateTimeLength.short,
    ).formatIso(datetime.toX.$1);
  }

  @override
  String md(DateTime datetime) {
    final (alignment, _, _, optionLength) = options.toX;
    return icu.DateFormatter.md(
      setLocaleExtensions(locale, options),
      alignment: alignment,
      length: optionLength ?? icu.DateTimeLength.short,
    ).formatIso(datetime.toX.$1);
  }

  @override
  String y(DateTime datetime) =>
      _dateFormatter(icu.DateFormatter.y, icu.DateTimeLength.long, datetime);

  @override
  String ymd(DateTime datetime) =>
      _dateFormatter(icu.DateFormatter.ymd, icu.DateTimeLength.short, datetime);

  @override
  String ymde(DateTime datetime) => _dateFormatter(
    icu.DateFormatter.ymde,
    icu.DateTimeLength.short,
    datetime,
  );

  @override
  String ymdt(DateTime datetime) =>
      _dateTimeFormatter(icu.DateTimeFormatter.ymdt, datetime);

  @override
  String time(DateTime datetime) {
    final (alignment, yearStyle, timePrecision, length) = options.toX;
    final localeX = setLocaleExtensions(locale, options);
    final (_, time) = datetime.toX;
    return icu.TimeFormatter(
      localeX,
      alignment: alignment,
      length: length ?? icu.DateTimeLength.short,
      timePrecision: timePrecision,
    ).format(time);
  }

  @override
  String ymdet(DateTime datetime) =>
      _dateTimeFormatter(icu.DateTimeFormatter.ymdet, datetime);
}

extension on DateTime {
  (icu.IsoDate, icu.Time) get toX {
    final isoDate = icu.IsoDate(year, month, day);
    final time = icu.Time(hour, minute, second, millisecond * 1_000_000);
    return (isoDate, time);
  }
}

extension on DateTimeFormatOptions {
  (
    icu.DateTimeAlignment?,
    icu.YearStyle?,
    icu.TimePrecision?,
    icu.DateTimeLength?,
  )
  get toX {
    icu.TimePrecision? timePrecision;
    if (fractionalSecondDigits != null) {
      timePrecision = icu.TimePrecision.fromSubsecondDigits(
        fractionalSecondDigits!,
      );
    } else {
      timePrecision = switch (timeFormatStyle) {
        null => icu.TimePrecision.minute,
        TimeFormatStyle.full => icu.TimePrecision.second,
        TimeFormatStyle.long => icu.TimePrecision.second,
        TimeFormatStyle.medium => icu.TimePrecision.second,
        TimeFormatStyle.short => icu.TimePrecision.minute,
      };
    }
    final dateTimeAlignment =
        timestyle == TimeStyle.twodigit
            ? icu.DateTimeAlignment.column
            : icu.DateTimeAlignment.auto;
    return (
      dateTimeAlignment,
      switch (dateFormatStyle) {
        null => icu.YearStyle.full,
        TimeFormatStyle.full => icu.YearStyle.auto,
        TimeFormatStyle.long => icu.YearStyle.auto,
        TimeFormatStyle.medium => icu.YearStyle.auto,
        TimeFormatStyle.short => icu.YearStyle.auto,
      },
      timePrecision,
      switch (dateFormatStyle) {
        TimeFormatStyle.full => icu.DateTimeLength.long,
        TimeFormatStyle.long => icu.DateTimeLength.long,
        TimeFormatStyle.medium => icu.DateTimeLength.medium,
        TimeFormatStyle.short => icu.DateTimeLength.short,
        null => null,
      },
    );
  }
}
