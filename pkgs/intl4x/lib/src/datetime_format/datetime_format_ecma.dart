// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../locale/locale.dart';
import '../options.dart';
import 'datetime_format.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

DateTimeFormatImpl? getDateTimeFormatterECMA(
  Locale locale,
  DateTimeFormatOptions options,
) => _DateTimeFormatECMA.tryToBuild(locale, options);

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
  ) {
    final supportedLocales = supportedLocalesOf(locale);
    return supportedLocales.isNotEmpty
        ? _DateTimeFormatECMA(supportedLocales.first, options)
        : null; //TODO: Add support to force return an instance instead of null.
  }

  static List<Locale> supportedLocalesOf(Locale locale) {
    return DateTimeFormat.supportedLocalesOf(
      [locale.toLanguageTag().toJS].toJS,
    ).toDart.whereType<String>().map(Locale.parse).toList();
  }

  @override
  DateFormatterImpl d() => DateFormatterECMA(
    this,
    DateTimeJSOptions(year: null, day: _timeStyle, month: null),
    locale,
    options,
  );

  @override
  DateFormatterImpl m() => DateFormatterECMA(
    this,
    DateTimeJSOptions(year: null, day: null, month: _timeStyle),
    locale,
    options,
  );

  @override
  DateFormatterImpl md() => DateFormatterECMA(
    this,
    DateTimeJSOptions(year: null, day: _timeStyle, month: _timeStyle),
    locale,
    options,
  );

  @override
  DateFormatterImpl y() => DateFormatterECMA(
    this,
    DateTimeJSOptions(year: _timeStyle),
    locale,
    options,
  );

  @override
  DateFormatterImpl ymd() => DateFormatterECMA(
    this,
    DateTimeJSOptions(year: _timeStyle, month: _timeStyle, day: _timeStyle),
    locale,
    options,
  );

  @override
  DateFormatterImpl ymde() =>
      DateFormatterECMA(this, DateTimeJSOptions(), locale, options);

  // @override
  // String time(DateTime datetime, {TimeZone? timeZone}) => _format(
  //   datetime: datetime,
  //   year: null,
  //   hour: _timeStyle,
  //   minute: _timeStyleOrNull,
  //   second: null,
  //   timeZone: timeZone,
  //   locale: locale,
  //   options: options,
  // );

  TimeStyle? get _timeStyle =>
      options.dateFormatStyle != null || options.timeFormatStyle != null
          ? null
          : (options.timestyle ?? TimeStyle.numeric);

  TimeStyle? get _timeStyleOrNull =>
      options.dateFormatStyle != null || options.timeFormatStyle != null
          ? null
          : options.timestyle;

  @override
  TimeFormatterImpl time() => throw UnimplementedError();

  @override
  DateTimeFormatterImpl ymdt() => DateTimeFormatterECMA(
    this,
    DateTimeJSOptions(
      hour: _timeStyle,
      minute: _timeStyleOrNull,
      year: _timeStyle,
      month: _timeStyle,
      day: _timeStyle,
    ),
    locale,
    options,
  );

  @override
  DateTimeFormatterImpl ymdet() => DateTimeFormatterECMA(
    this,
    DateTimeJSOptions(
      hour: _timeStyle,
      minute: _timeStyleOrNull,
      year: _timeStyle,
      month: _timeStyle,
      day: _timeStyle,
      weekday: Style.short,
    ),
    locale,
    options,
  );
}

class DateFormatterECMA extends DateFormatterImpl {
  final Locale locale;
  final DateTimeFormatOptions options;
  final DateTimeJSOptions optionsJS;
  final DateTimeFormatImpl impl;
  final DateTimeFormat dateTimeFormat;

  DateFormatterECMA(this.impl, this.optionsJS, this.locale, this.options)
    : dateTimeFormat = DateTimeFormat(
        [locale.toLanguageTag().toJS].toJS,
        options.toJsOptions(optionsJS),
      ),
      super(impl);

  @override
  String formatInternal(DateTime datetime) =>
      dateTimeFormat.format(datetime.toJs());

  @override
  DateFormatterZoned withTimezoneLong(TimeZone timeZone) =>
      DateFormatterZonedECMA(timeZone, TimeZoneType.long, this);

  @override
  DateFormatterZoned withTimezoneShort(TimeZone timeZone) =>
      DateFormatterZonedECMA(timeZone, TimeZoneType.short, this);

  @override
  DateFormatterZoned withTimeZoneLongGeneric(TimeZone timeZone) =>
      DateFormatterZonedECMA(timeZone, TimeZoneType.longGeneric, this);

  @override
  DateFormatterZoned withTimeZoneLongOffset(TimeZone timeZone) =>
      DateFormatterZonedECMA(timeZone, TimeZoneType.longOffset, this);

  @override
  DateFormatterZoned withTimeZoneShortGeneric(TimeZone timeZone) =>
      DateFormatterZonedECMA(timeZone, TimeZoneType.shortGeneric, this);

  @override
  DateFormatterZoned withTimeZoneShortOffset(TimeZone timeZone) =>
      DateFormatterZonedECMA(timeZone, TimeZoneType.shortOffset, this);
}

class DateFormatterZonedECMA extends DateFormatterZonedImpl {
  final TimeZone timeZone;
  final DateFormatterECMA formatter;
  final TimeZoneType timeZoneType;
  final DateTimeFormat dateTimeFormat;

  DateFormatterZonedECMA(this.timeZone, this.timeZoneType, this.formatter)
    : dateTimeFormat = DateTimeFormat(
        [formatter.locale.toLanguageTag().toJS].toJS,
        formatter.options.toJsOptions(
          formatter.optionsJS.copyWith(
            timeZone: timeZone,
            timeZoneType: timeZoneType,
          ),
        ),
      ),
      super(formatter.impl);

  @override
  String formatInternal(DateTime datetime) =>
      dateTimeFormat.format(datetime.subtract(timeZone.offset).toJsUtc());
}

class DateTimeFormatterECMA extends DateTimeFormatterImpl {
  final Locale locale;
  final DateTimeFormatOptions options;
  final DateTimeJSOptions optionsJS;
  final DateTimeFormatImpl impl;
  final DateTimeFormat dateTimeFormat;

  DateTimeFormatterECMA(this.impl, this.optionsJS, this.locale, this.options)
    : dateTimeFormat = DateTimeFormat(
        [locale.toLanguageTag().toJS].toJS,
        options.toJsOptions(optionsJS),
      ),
      super(impl);

  @override
  String formatInternal(DateTime datetime) =>
      dateTimeFormat.format(datetime.toJs());

  @override
  DateTimeFormatterZoned withTimezoneLong(TimeZone timeZone) =>
      DateTimeFormatterZonedECMA(timeZone, TimeZoneType.long, this);

  @override
  DateTimeFormatterZoned withTimezoneShort(TimeZone timeZone) =>
      DateTimeFormatterZonedECMA(timeZone, TimeZoneType.short, this);

  @override
  DateTimeFormatterZoned withTimeZoneLongGeneric(TimeZone timeZone) =>
      DateTimeFormatterZonedECMA(timeZone, TimeZoneType.longGeneric, this);

  @override
  DateTimeFormatterZoned withTimeZoneLongOffset(TimeZone timeZone) =>
      DateTimeFormatterZonedECMA(timeZone, TimeZoneType.longOffset, this);

  @override
  DateTimeFormatterZoned withTimeZoneShortGeneric(TimeZone timeZone) =>
      DateTimeFormatterZonedECMA(timeZone, TimeZoneType.shortGeneric, this);

  @override
  DateTimeFormatterZoned withTimeZoneShortOffset(TimeZone timeZone) =>
      DateTimeFormatterZonedECMA(timeZone, TimeZoneType.shortOffset, this);
}

class DateTimeFormatterZonedECMA extends DateTimeFormatterZonedImpl {
  final TimeZone timeZone;
  final DateTimeFormatterECMA formatter;
  final TimeZoneType timeZoneType;
  final DateTimeFormat dateTimeFormat;

  DateTimeFormatterZonedECMA(this.timeZone, this.timeZoneType, this.formatter)
    : dateTimeFormat = DateTimeFormat(
        [formatter.locale.toLanguageTag().toJS].toJS,
        formatter.options.toJsOptions(
          formatter.optionsJS.copyWith(
            timeZone: timeZone,
            timeZoneType: timeZoneType,
          ),
        ),
      ),
      super(formatter.impl);

  @override
  String formatInternal(DateTime datetime) =>
      dateTimeFormat.format(datetime.subtract(timeZone.offset).toJsUtc());
}

class DateTimeJSOptions {
  final TimeStyle? year;
  final TimeStyle? month;
  final TimeStyle? day;
  final TimeStyle? hour;
  final TimeStyle? minute;
  final TimeStyle? second;
  final TimeZone? timeZone;
  final TimeZoneType? timeZoneType;
  final Style? weekday;

  DateTimeJSOptions({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.timeZone,
    this.timeZoneType,
    this.weekday,
  });

  DateTimeJSOptions copyWith({
    TimeStyle? year,
    TimeStyle? month,
    TimeStyle? day,
    TimeStyle? hour,
    TimeStyle? minute,
    TimeStyle? second,
    TimeZone? timeZone,
    TimeZoneType? timeZoneType,
    Style? weekday,
  }) => DateTimeJSOptions(
    day: day ?? this.day,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    month: month ?? this.month,
    second: second ?? this.second,
    timeZone: timeZone ?? this.timeZone,
    timeZoneType: timeZoneType ?? this.timeZoneType,
    weekday: weekday ?? this.weekday,
    year: year ?? this.year,
  );
}

extension on DateTime {
  Date toJs() => Date(year, month - 1, day, hour, minute, second, millisecond);

  Date toJsUtc() => Date.fromTimeStamp(
    Date.UTC(year, month - 1, day, hour, minute, second, millisecond),
  );
}

extension on DateTimeFormatOptions {
  JSAny toJsOptions(DateTimeJSOptions options) =>
      {
        if (dateFormatStyle != null) 'dateStyle': dateFormatStyle!.name,
        if (timeFormatStyle != null) 'timeStyle': timeFormatStyle!.name,
        if (calendar != null) 'calendar': calendar!.jsName,
        if (dayPeriod != null) 'dayPeriod': dayPeriod!.name,
        if (numberingSystem != null) 'numberingSystem': numberingSystem!.name,
        if (options.timeZone != null) ...{
          'timeZone': options.timeZone!.name,
          'timeZoneName': options.timeZoneType!.name,
        },
        if (clockstyle != null) ...{
          'hour12': clockstyle!.is12Hour,
          'hourCycle': clockstyle!.hourStyleExtensionString,
        },
        if (options.weekday != null && dateFormatStyle == null)
          'weekday': options.weekday!.name,
        if (era != null && dateFormatStyle == null) 'era': era!.name,
        if (options.year != null && dateFormatStyle == null)
          'year': options.year!.jsName,
        if (options.month != null && dateFormatStyle == null)
          'month': options.month!.jsName,
        if (options.day != null && dateFormatStyle == null)
          'day': options.day!.jsName,
        if (options.hour != null && timeFormatStyle == null)
          'hour': options.hour!.jsName,
        if (options.minute != null && timeFormatStyle == null)
          'minute': options.minute!.jsName,
        if (options.second != null && timeFormatStyle == null)
          'second': options.second!.jsName,
        if (fractionalSecondDigits != null)
          'fractionalSecondDigits': fractionalSecondDigits!,
        'formatMatcher': formatMatcher.jsName,
      }.jsify()!;
}

extension on ClockStyle {
  bool get is12Hour =>
      this == ClockStyle.zeroToEleven || this == ClockStyle.oneToTwelve;
}
