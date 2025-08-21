// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;

import '../../../datetime_format.dart';
import '../../locale/locale.dart';
import '../../locale/locale_4x.dart';
import '../datetime_format_impl.dart';
import 'date_formatter.dart';
import 'date_time_formatter.dart';
import 'time_formatter.dart';

DateTimeFormatImpl getDateTimeFormatter4X(
  Locale locale,
  DateTimeFormatOptions options,
) => DateTimeFormat4X(locale as Locale4x, options);

class DateTimeFormat4X extends DateTimeFormatImpl {
  DateTimeFormat4X(Locale4x super.locale, super.options);

  icu.Locale get localeX => (super.locale as Locale4x).get4X;

  @override
  FormatterImpl d({DateFormatStyle? dateStyle}) {
    final (alignment, _, _, length) = options.toX(dateStyle: dateStyle);
    final locale = setLocaleExtensions(localeX, options);
    return DateFormatterX.d(this, locale, alignment, length);
  }

  @override
  FormatterImpl m({DateFormatStyle? dateStyle}) {
    final (alignment, _, _, length) = options.toX(dateStyle: dateStyle);
    final locale = setLocaleExtensions(localeX, options);
    return DateFormatterX.m(this, locale, alignment, length);
  }

  @override
  FormatterImpl md({DateFormatStyle? dateStyle}) {
    final (alignment, _, _, length) = options.toX(dateStyle: dateStyle);
    final locale = setLocaleExtensions(localeX, options);
    return DateFormatterX.md(this, locale, alignment, length);
  }

  @override
  FormatterImpl y({DateFormatStyle? dateStyle}) {
    final (alignment, yearStyle, _, length) = options.toX(dateStyle: dateStyle);
    final locale = setLocaleExtensions(localeX, options);
    return DateFormatterX.y(this, locale, alignment, length, yearStyle);
  }

  @override
  FormatterImpl ymd({DateFormatStyle? dateStyle}) {
    final (alignment, yearStyle, _, length) = options.toX(dateStyle: dateStyle);
    final locale = setLocaleExtensions(localeX, options);
    return DateFormatterX.ymd(this, locale, alignment, length, yearStyle);
  }

  @override
  FormatterImpl ymde({DateFormatStyle? dateStyle}) {
    final (alignment, yearStyle, _, length) = options.toX(dateStyle: dateStyle);
    final locale = setLocaleExtensions(localeX, options);
    return DateFormatterX.ymde(this, locale, alignment, length, yearStyle);
  }

  @override
  FormatterImpl mdt({DateFormatStyle? dateStyle, TimeFormatStyle? timeStyle}) {
    final (alignment, _, timePrecision, length) = options.toX(
      timeStyle: timeStyle,
      dateStyle: dateStyle,
    );
    final locale = setLocaleExtensions(localeX, options);
    return DateTimeFormatterX.mdt(
      this,
      locale,
      alignment,
      length,
      timePrecision,
    );
  }

  @override
  FormatterImpl ymdt({DateFormatStyle? dateStyle, TimeFormatStyle? timeStyle}) {
    final (alignment, yearStyle, timePrecision, length) = options.toX(
      timeStyle: timeStyle,
      dateStyle: dateStyle,
    );
    final locale = setLocaleExtensions(localeX, options);
    return DateTimeFormatterX.ymdt(
      this,
      locale,
      alignment,
      length,
      timePrecision,
      yearStyle,
    );
  }

  @override
  FormatterImpl ymdet({
    DateFormatStyle? dateStyle,
    TimeFormatStyle? timeStyle,
  }) {
    final (alignment, yearStyle, timePrecision, length) = options.toX(
      timeStyle: timeStyle,
      dateStyle: dateStyle,
    );
    final locale = setLocaleExtensions(localeX, options);
    return DateTimeFormatterX.ymdet(
      this,
      locale,
      alignment,
      length,
      timePrecision,
      yearStyle,
    );
  }

  @override
  FormatterImpl t({TimeFormatStyle? style}) {
    final (alignment, _, timePrecision, length) = options.toX(
      timePrecisionDefault:
          options.timestyle == TimeStyle.twodigit
              ? icu.TimePrecision.minute
              : null,
      timeStyle: style,
    );
    final locale = setLocaleExtensions(localeX, options);
    return TimeFormatterX.t(this, locale, timePrecision, alignment, length);
  }
}

extension VariantSetting on icu.TimeZoneInfo {
  void setVariant(TimeZone timeZone) {
    final success = inferVariant(icu.VariantOffsetsCalculator());
    if (!success) {
      throw ArgumentError(
        '''
The variant of ${timeZone.name} with offset ${timeZone.offset} could not be inferred''',
      );
    }
  }
}

extension DateToICU4X on DateTime {
  (icu.IsoDate, icu.Time) get toX {
    final isoDate = icu.IsoDate(year, month, day);
    final time = icu.Time(
      hour,
      minute,
      second,
      millisecond * 1_000_000 + microsecond * 1_000,
    );
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
  toX({
    icu.TimePrecision? timePrecisionDefault,
    TimeFormatStyle? timeStyle,
    DateFormatStyle? dateStyle,
  }) {
    icu.TimePrecision? timePrecision;
    if (fractionalSecondDigits != null) {
      timePrecision = icu.TimePrecision.fromSubsecondDigits(
        fractionalSecondDigits!,
      );
    } else {
      timePrecision = switch (timeStyle) {
        null => timePrecisionDefault ?? icu.TimePrecision.hour,
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
      switch (dateStyle) {
        null => icu.YearStyle.full,
        DateFormatStyle.full => icu.YearStyle.auto,
        DateFormatStyle.long => icu.YearStyle.auto,
        DateFormatStyle.medium => icu.YearStyle.auto,
        DateFormatStyle.short => icu.YearStyle.auto,
      },
      timePrecision,
      switch (dateStyle) {
        DateFormatStyle.full => icu.DateTimeLength.long,
        DateFormatStyle.long => icu.DateTimeLength.long,
        DateFormatStyle.medium => icu.DateTimeLength.medium,
        DateFormatStyle.short => icu.DateTimeLength.short,
        null => null,
      },
    );
  }
}

icu.Locale setLocaleExtensions(
  icu.Locale locale,
  DateTimeFormatOptions options,
) {
  final l = locale.clone();
  final calendar = options.calendar;
  if (calendar != null) {
    l.setUnicodeExtension('ca', calendar.jsName);
  }
  final clockStyle = options.clockstyle;
  if (clockStyle != null) {
    l.setUnicodeExtension('hc', clockStyle.hourStyleExtensionString);
  }
  final numberingSystem = options.numberingSystem;
  if (numberingSystem != null) {
    l.setUnicodeExtension('nu', numberingSystem.name);
  }
  return l;
}
