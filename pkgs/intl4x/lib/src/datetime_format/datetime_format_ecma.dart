// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:collection/collection.dart' show IterableExtension;

import '../locale/locale.dart';
import '../options.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

DateTimeFormatImpl getDateTimeFormatterECMA(Locale locale, Null options) =>
    _DateTimeFormatECMA.tryToBuild(locale);

extension type _DateTimeJSOptions(JSAny _options) {
  // final DateTimeLength? year;
  // final DateTimeLength? month;
  // final DateTimeLength? day;
  // final DateTimeLength? hour;
  // final DateTimeLength? minute;
  // final DateTimeLength? second;
  // final String? timeZone;
  // final TimeZoneType? timeZoneType;
  // final Style? weekday;

  _DateTimeJSOptions.from({
    YearStyle? yearStyle,
    _TimeStyle? year,
    _MonthStyle? month,
    _TimeStyle? day,
    _TimeStyle? hour,
    _TimeStyle? minute,
    _TimeStyle? second,
    Style? weekday,
    String? timeZone,
    TimeZoneType? timeZoneType,
    int? fractionalSecondDigits,
  }) : _options = _optionsFrom(
         yearStyle: yearStyle,
         year: year,
         month: month,
         day: day,
         hour: hour,
         minute: minute,
         second: second,
         weekday: weekday,
         timeZone: timeZone,
         timeZoneType: timeZoneType,
         fractionalSecondDigits: fractionalSecondDigits,
       );

  static JSAny _optionsFrom({
    YearStyle? yearStyle,
    _TimeStyle? year,
    _MonthStyle? month,
    _TimeStyle? day,
    _TimeStyle? hour,
    _TimeStyle? minute,
    _TimeStyle? second,
    Style? weekday,
    String? timeZone,
    TimeZoneType? timeZoneType,
    int? fractionalSecondDigits,
  }) => {
    if (timeZone != null) ...{
      'timeZone': timeZone,
      'timeZoneName': timeZoneType!.name,
    },
    if (weekday != null) 'weekday': weekday.name,
    if (yearStyle == YearStyle.withEra) 'era': Style.short.name,
    if (year != null) 'year': year.jsName,
    if (month != null) 'month': month.jsName,
    if (day != null) 'day': day.jsName,
    if (hour != null) 'hour': hour.jsName,
    if (minute != null) 'minute': minute.jsName,
    if (second != null) 'second': second.jsName,
    if (fractionalSecondDigits != null)
      'fractionalSecondDigits': fractionalSecondDigits,
    //  'formatMatcher': formatMatcher.jsName,
  }.jsify()!;
}

enum _TimeStyle {
  numeric,
  twodigit('2-digit');

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const _TimeStyle([this._jsName]);
}

enum _MonthStyle {
  numeric,
  twodigit('2-digit'),
  narrow,
  short,
  long;

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const _MonthStyle([this._jsName]);
}

class _FormatterECMA extends FormatterImpl {
  final Locale locale;
  final _DateTimeJSOptions _optionsJS;
  final DateTimeFormatImpl impl;
  final _DateTimeFormat dateTimeFormat;

  _FormatterECMA._(this.impl, this._optionsJS, this.locale)
    : dateTimeFormat = _DateTimeFormat(
        [locale.toLanguageTag().toJS].toJS,
        _optionsJS,
      ),
      super(impl);

  @override
  String formatInternal(DateTime datetime) =>
      dateTimeFormat.format(datetime.js);

  @override
  ZonedDateTimeFormatter withTimeZoneLong() =>
      FormatterZonedECMA(TimeZoneType.long, this);

  @override
  ZonedDateTimeFormatter withTimeZoneLongGeneric() =>
      FormatterZonedECMA(TimeZoneType.longGeneric, this);

  @override
  ZonedDateTimeFormatter withTimeZoneLongOffset() =>
      FormatterZonedECMA(TimeZoneType.longOffset, this);

  @override
  ZonedDateTimeFormatter withTimeZoneShort() =>
      FormatterZonedECMA(TimeZoneType.short, this);

  @override
  ZonedDateTimeFormatter withTimeZoneShortGeneric() =>
      FormatterZonedECMA(TimeZoneType.shortGeneric, this);

  @override
  ZonedDateTimeFormatter withTimeZoneShortOffset() =>
      FormatterZonedECMA(TimeZoneType.shortOffset, this);
}

class FormatterZonedECMA extends FormatterZonedImpl {
  final _FormatterECMA formatter;

  FormatterZonedECMA(TimeZoneType timeZoneType, this.formatter)
    : super(formatter.impl, timeZoneType);

  static _DateTimeFormat createDateTimeFormat(
    _FormatterECMA formatter,
    TimeZoneType timeZoneType,
    String timeZone,
  ) {
    final localeJS = [formatter.locale.toLanguageTag().toJS].toJS;
    return _DateTimeFormat(localeJS, formatter._optionsJS);
  }

  @override
  String formatInternal(DateTime datetime, String timeZone) {
    try {
      // ECMA will interpret this as UTC time and convert it
      // into the time zone, we need to invert that change.
      final adjustedDateTime = datetime.subtract(
        offsetForTimeZone(datetime, timeZone),
      );
      return createDateTimeFormat(
        formatter,
        timeZoneType,
        timeZone,
      ).format(adjustedDateTime.jsUtc);
    } catch (e) {
      // Unknown timezone. Format with UTC and append '+?'
      // to construct a localized 'UTC+?'
      final parts = createDateTimeFormat(
        formatter,
        TimeZoneType.shortOffset,
        'UTC',
      ).formatToParts(datetime.jsUtc).toDart;
      return parts
          .map(Part._)
          .map(
            (part) => part.isTimezoneName
                ? '${part.value.split('+')[0]}+?'
                : part.value,
          )
          .join();
    }
  }
}

class _DateTimeFormatECMA extends DateTimeFormatImpl {
  _DateTimeFormatECMA(super.locale);

  @override
  FormatterImpl d({DateTimeAlignment? alignment, DateTimeLength? length}) =>
      _FormatterECMA._(
        this,
        _DateTimeJSOptions.from(day: _TimeStyle.numeric),
        locale,
      );

  @override
  FormatterImpl m({DateTimeAlignment? alignment, DateTimeLength? length}) =>
      _FormatterECMA._(
        this,
        _DateTimeJSOptions.from(month: _monthStyle(length: length)),
        locale,
      );

  @override
  FormatterImpl md({DateTimeAlignment? alignment, DateTimeLength? length}) =>
      _FormatterECMA._(
        this,
        _DateTimeJSOptions.from(
          month: _monthStyle(length: length),
          day: _TimeStyle.numeric,
        ),
        locale,
      );

  @override
  FormatterImpl t({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) => _FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      hour: _TimeStyle.numeric,
      minute: _style(timePrecision, TimePrecision.minute),
      second: _style(timePrecision, TimePrecision.second),
      fractionalSecondDigits: _fractionalSeconds(timePrecision),
    ),
    locale,
  );

  @override
  FormatterImpl y({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => _FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      year: _yearStyle(length, alignment, yearStyle),
      yearStyle: yearStyle,
    ),
    locale,
  );

  @override
  FormatterImpl ymd({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => _FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      hour: _TimeStyle.numeric,
      year: _yearStyle(length, alignment, yearStyle),
      yearStyle: yearStyle,
      month: _monthStyle(length: length),
      day: _TimeStyle.numeric,
    ),
    locale,
  );

  @override
  FormatterImpl ymde({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => _FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      hour: _TimeStyle.numeric,
      year: _yearStyle(length, alignment, yearStyle),
      yearStyle: yearStyle,
      month: _monthStyle(length: length),
      day: _TimeStyle.numeric,
      weekday: _weekday(length),
    ),
    locale,
  );

  @override
  FormatterImpl mdt({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) => _FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      hour: _TimeStyle.numeric,
      minute: _style(timePrecision, TimePrecision.minute),
      second: _style(timePrecision, TimePrecision.second),
      fractionalSecondDigits: _fractionalSeconds(timePrecision),
      month: _monthStyle(length: length),
      day: _TimeStyle.numeric,
    ),
    locale,
  );

  @override
  FormatterImpl ymdt({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  }) => _FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      hour: _TimeStyle.numeric,
      minute: _style(timePrecision, TimePrecision.minute),
      second: _style(timePrecision, TimePrecision.second),
      year: _yearStyle(length, alignment, yearStyle),
      fractionalSecondDigits: _fractionalSeconds(timePrecision),
      yearStyle: yearStyle,
      month: _monthStyle(length: length),
      day: _TimeStyle.numeric,
    ),
    locale,
  );

  @override
  FormatterImpl ymdet({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  }) => _FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      hour: _TimeStyle.numeric,
      minute: _style(timePrecision, TimePrecision.minute),
      second: _style(timePrecision, TimePrecision.second),
      year: _yearStyle(length, alignment, yearStyle),
      fractionalSecondDigits: _fractionalSeconds(timePrecision),
      yearStyle: yearStyle,
      month: _monthStyle(length: length),
      day: _TimeStyle.numeric,
      weekday: _weekday(length),
    ),
    locale,
  );

  _MonthStyle _monthStyle({DateTimeLength? length}) => switch (length) {
    null => _MonthStyle.twodigit,
    DateTimeLength.long => _MonthStyle.long,
    DateTimeLength.medium => _MonthStyle.twodigit,
    DateTimeLength.short => _MonthStyle.twodigit,
  };

  int? _fractionalSeconds(TimePrecision? timePrecision) =>
      switch (timePrecision) {
        TimePrecision.subsecond1 => 1,
        TimePrecision.subsecond2 => 2,
        TimePrecision.subsecond3 => 3,
        _ => null,
      };

  _TimeStyle _yearStyle(
    DateTimeLength? length,
    DateTimeAlignment? alignment,
    YearStyle? yearStyle,
  ) => switch ((length, alignment, yearStyle)) {
    (_, _, YearStyle.full) => _TimeStyle.numeric,
    (DateTimeLength.medium, _, _) => _TimeStyle.numeric,
    (DateTimeLength.long, _, _) => _TimeStyle.numeric,
    (_, _, _) => _TimeStyle.twodigit,
  };

  _TimeStyle? _style(TimePrecision? timePrecision, TimePrecision second) =>
      timePrecision != null
      ? (timePrecision >= second ? _TimeStyle.numeric : null)
      : _TimeStyle.numeric;

  static List<Locale> supportedLocalesOf(Locale locale) =>
      _DateTimeFormat.supportedLocalesOf(
        [locale.toLanguageTag().toJS].toJS,
      ).toDart.whereType<String>().map(Locale.parse).toList();

  static DateTimeFormatImpl tryToBuild(Locale locale) {
    final supportedLocales = supportedLocalesOf(locale);
    return _DateTimeFormatECMA(
      supportedLocales.firstOrNull ?? Locale.parse('und'),
    );
  }

  Style? _weekday(DateTimeLength? length) => switch (length) {
    DateTimeLength.long => Style.long,
    DateTimeLength.medium => Style.short,
    DateTimeLength.short => Style.short,
    null => Style.short,
  };
}

extension type Date._(JSObject _) implements JSObject {
  external factory Date(
    int year,
    int monthIndex,
    int day,
    int hours,
    int minutes,
    int seconds,
    int milliseconds,
  );

  external factory Date.fromTimeStamp(int timeStamp);

  // ignore: non_constant_identifier_names
  external static int UTC(
    int year,
    int monthIndex,
    int day,
    int hours,
    int minutes,
    int seconds,
    int milliseconds,
  );
}

Duration offsetForTimeZone(DateTime datetime, String iana) {
  final timeZoneName = _DateTimeFormat(
    ['en'.toJS].toJS,
    _DateTimeJSOptions(
      {'timeZoneName': TimeZoneType.longOffset.name, 'timeZone': iana}.jsify()!,
    ),
  ).timeZoneName(datetime.js);
  return parseTimeZoneOffset(timeZoneName);
}

@JS('Intl.DateTimeFormat')
extension type _DateTimeFormat._(JSObject _) implements JSObject {
  external factory _DateTimeFormat([
    JSArray<JSString> locale,
    _DateTimeJSOptions options,
  ]);
  external String format(Date num);

  external static JSArray<JSString> supportedLocalesOf(
    JSArray listOfLocales, [
    JSAny options,
  ]);

  external JSArray<JSObject> formatToParts(JSAny num);

  String? timeZoneName(Date date) {
    final timezoneNameObject = formatToParts(
      date,
    ).toDart.map(Part._).firstWhereOrNull((part) => part.isTimezoneName);
    return timezoneNameObject?.value;
  }
}

@JS()
extension type Part._(JSObject _) implements JSObject {
  external String get type;
  external String get value;

  bool get isTimezoneName => type == 'timeZoneName';
}

final _offsetRegex = RegExp(
  r'([+\-\u2212])(\d{2}):?(\d{2})(?:(?::?)(\d{2}))?$',
);

Duration parseTimeZoneOffset(String? offsetString) {
  if (offsetString == null || offsetString == 'UTC' || offsetString == 'GMT') {
    return Duration.zero;
  }

  final Match? match = _offsetRegex.firstMatch(offsetString);

  if (match == null) {
    throw ArgumentError('Invalid time zone offset format: "$offsetString"');
  }

  final sign = (match.group(1)! == '-' || match.group(1)! == '\u2212') ? -1 : 1;
  final hours = int.parse(match.group(2)!);
  final minutes = int.parse(match.group(3)!);
  final seconds = int.parse(match.group(4) ?? '0');

  return Duration(hours: hours, minutes: minutes, seconds: seconds) * sign;
}

extension on DateTime {
  Date get js => Date(year, month - 1, day, hour, minute, second, millisecond);

  Date get jsUtc => Date.fromTimeStamp(
    Date.UTC(year, month - 1, day, hour, minute, second, millisecond),
  );
}
