// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../locale/locale.dart';
import '../options.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

DateTimeFormatImpl? getDateTimeFormatterECMA(
  Locale locale,
  DateTimeFormatOptions options,
  LocaleMatcher localeMatcher,
) => _DateTimeFormatECMA.tryToBuild(locale, options, localeMatcher);

@JS('Intl.DateTimeFormat')
extension type DateTimeFormat._(JSObject _) implements JSObject {
  external factory DateTimeFormat([JSArray<JSString> locale, JSAny options]);
  external String format(JSAny num);

  external static JSArray<JSString> supportedLocalesOf(
    JSArray listOfLocales, [
    JSAny options,
  ]);
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

class _DateTimeFormatECMA extends DateTimeFormatImpl {
  _DateTimeFormatECMA(super.locale, super.options);

  static DateTimeFormatImpl? tryToBuild(
    Locale locale,
    DateTimeFormatOptions options,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(localeMatcher, locale);
    return supportedLocales.isNotEmpty
        ? _DateTimeFormatECMA(supportedLocales.first, options)
        : null; //TODO: Add support to force return an instance instead of null.
  }

  static List<Locale> supportedLocalesOf(
    LocaleMatcher localeMatcher,
    Locale locale,
  ) {
    final o = {'localeMatcher': localeMatcher.jsName}.jsify()!;
    return DateTimeFormat.supportedLocalesOf(
      [locale.toLanguageTag().toJS].toJS,
      o,
    ).toDart.whereType<String>().map(Locale.parse).toList();
  }

  @override
  String d(DateTime datetime) =>
      _format(datetime: datetime, year: null, day: _timeStyle, month: null);

  @override
  String m(DateTime datetime) =>
      _format(datetime: datetime, year: null, day: null, month: _timeStyle);

  @override
  String md(DateTime datetime) => _format(
    datetime: datetime,
    year: null,
    day: _timeStyle,
    month: _timeStyle,
  );

  @override
  String y(DateTime datetime) => _format(datetime: datetime, year: _timeStyle);

  @override
  String ymd(DateTime datetime, {TimeZone? timeZone}) => _format(
    datetime: datetime,
    year: _timeStyle,
    month: _timeStyle,
    day: _timeStyle,
    timeZone: timeZone,
  );

  @override
  String ymde(DateTime datetime) => _format(datetime: datetime);

  @override
  String ymdt(DateTime datetime, {TimeZone? timeZone}) => _format(
    datetime: datetime,
    hour: _timeStyle,
    minute: _timeStyleOrNull,
    second: null,
    year: _timeStyle,
    month: _timeStyle,
    day: _timeStyle,
    timeZone: timeZone,
  );

  @override
  String time(DateTime datetime, {TimeZone? timeZone}) => _format(
    datetime: datetime,
    year: null,
    hour: _timeStyle,
    minute: _timeStyleOrNull,
    second: null,
    timeZone: timeZone,
  );

  TimeStyle? get _timeStyle =>
      options.dateFormatStyle != null || options.timeFormatStyle != null
          ? null
          : (options.timestyle ?? TimeStyle.numeric);

  TimeStyle? get _timeStyleOrNull =>
      options.dateFormatStyle != null || options.timeFormatStyle != null
          ? null
          : options.timestyle;

  @override
  String ymdet(DateTime datetime) => _format(
    datetime: datetime,
    hour: _timeStyle,
    minute: _timeStyleOrNull,
    second: null,
    year: _timeStyle,
    month: _timeStyle,
    day: _timeStyle,
    weekday: Style.short,
  );

  String _format({
    TimeStyle? year,
    TimeStyle? month,
    TimeStyle? day,
    TimeStyle? hour,
    TimeStyle? minute,
    TimeStyle? second,
    TimeZone? timeZone,
    Style? weekday,
    required DateTime datetime,
  }) {
    final correctedDatetime =
        timeZone == null
            ? datetime.toJs()
            : (timeZone.offset.sign == 1
                    ? datetime.subtract(timeZone.offset.duration)
                    : datetime.add(timeZone.offset.duration))
                .toJsUtc();

    return DateTimeFormat(
      [locale.toLanguageTag().toJS].toJS,
      options.toJsOptions(
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
        timeZone: timeZone,
        weekday: weekday,
      ),
    ).format(correctedDatetime);
  }
}

extension on DateTime {
  Date toJs() => Date(year, month - 1, day, hour, minute, second, millisecond);

  Date toJsUtc() => Date.fromTimeStamp(
    Date.UTC(year, month - 1, day, hour, minute, second, millisecond),
  );
}

extension on DateTimeFormatOptions {
  JSAny toJsOptions({
    TimeStyle? year,
    TimeStyle? month,
    TimeStyle? day,
    TimeStyle? hour,
    TimeStyle? minute,
    TimeStyle? second,
    TimeZone? timeZone,
    Style? weekday,
  }) =>
      {
        'localeMatcher': localeMatcher.jsName,
        if (dateFormatStyle != null) 'dateStyle': dateFormatStyle!.name,
        if (timeFormatStyle != null) 'timeStyle': timeFormatStyle!.name,
        if (calendar != null) 'calendar': calendar!.jsName,
        if (dayPeriod != null) 'dayPeriod': dayPeriod!.name,
        if (numberingSystem != null) 'numberingSystem': numberingSystem!.name,
        if (timeZone != null) ...{
          'timeZone': timeZone.name,
          'timeZoneName': timeZone.type.name,
        },
        if (clockstyle != null) ...{
          'hour12': clockstyle!.is12Hour,
          'hourCycle': clockstyle!.hourStyleExtensionString,
        },
        if (weekday != null && dateFormatStyle == null) 'weekday': weekday.name,
        if (era != null && dateFormatStyle == null) 'era': era!.name,
        if (year != null && dateFormatStyle == null) 'year': year.jsName,
        if (month != null && dateFormatStyle == null) 'month': month.jsName,
        if (day != null && dateFormatStyle == null) 'day': day.jsName,
        if (hour != null && timeFormatStyle == null) 'hour': hour.jsName,
        if (minute != null && timeFormatStyle == null) 'minute': minute.jsName,
        if (second != null && timeFormatStyle == null) 'second': second.jsName,
        if (fractionalSecondDigits != null)
          'fractionalSecondDigits': fractionalSecondDigits!,
        'formatMatcher': formatMatcher.jsName,
      }.jsify()!;
}

extension on ClockStyle {
  bool get is12Hour =>
      this == ClockStyle.zeroToEleven || this == ClockStyle.oneToTwelve;
}
