// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../locale/locale.dart';
import '../options.dart';
import 'datetime_format.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

DateTimeFormatImpl getDateTimeFormatterECMA(
  Locale locale,
  DateTimeFormatOptions options,
) => _DateTimeFormatECMA.tryToBuild(locale, options);

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

class FormatterECMA extends FormatterImpl {
  final Locale locale;
  final DateTimeFormatOptions options;
  final DateTimeJSOptions optionsJS;
  final DateTimeFormatImpl impl;
  final DateTimeFormat dateTimeFormat;
  final TimeFormatStyle? timeStyle;
  final DateFormatStyle? dateStyle;

  FormatterECMA(
    this.impl,
    this.optionsJS,
    this.locale,
    this.options, {
    required this.timeStyle,
    required this.dateStyle,
  }) : dateTimeFormat = DateTimeFormat(
         [locale.toLanguageTag().toJS].toJS,
         options.toJsMap(optionsJS, timeStyle, dateStyle),
       ),
       super(impl);

  @override
  String formatInternal(DateTime datetime) =>
      dateTimeFormat.format(datetime.js);

  @override
  ZonedFormatter withTimeZoneLong(TimeZone timeZone) =>
      FormatterZonedECMA(timeZone, TimeZoneType.long, this);

  @override
  ZonedFormatter withTimeZoneLongGeneric(TimeZone timeZone) =>
      FormatterZonedECMA(timeZone, TimeZoneType.longGeneric, this);

  @override
  ZonedFormatter withTimeZoneLongOffset(TimeZone timeZone) =>
      FormatterZonedECMA(timeZone, TimeZoneType.longOffset, this);

  @override
  ZonedFormatter withTimeZoneShort(TimeZone timeZone) =>
      FormatterZonedECMA(timeZone, TimeZoneType.short, this);

  @override
  ZonedFormatter withTimeZoneShortGeneric(TimeZone timeZone) =>
      FormatterZonedECMA(timeZone, TimeZoneType.shortGeneric, this);

  @override
  ZonedFormatter withTimeZoneShortOffset(TimeZone timeZone) =>
      FormatterZonedECMA(timeZone, TimeZoneType.shortOffset, this);
}

class FormatterZonedECMA extends FormatterZonedImpl {
  final DateTimeFormat dateTimeFormat;

  FormatterZonedECMA(
    TimeZone timeZone,
    TimeZoneType timeZoneType,
    FormatterECMA formatter,
  ) : dateTimeFormat = DateTimeFormat(
        [formatter.locale.toLanguageTag().toJS].toJS,
        formatter.options.toJsMap(
          formatter.optionsJS.copyWith(
            timeZone: timeZone,
            timeZoneType: timeZoneType,
          ),
          formatter.timeStyle,
          formatter.dateStyle,
        ),
      ),
      super(formatter.impl, timeZone, timeZoneType);

  @override
  String formatInternal(DateTime datetime) =>
      dateTimeFormat.format(datetime.subtract(timeZone.offset).jsUtc);
}

class _DateTimeFormatECMA extends DateTimeFormatImpl {
  _DateTimeFormatECMA(super.locale, super.options);

  TimeStyle? _timeStyle(
    TimeFormatStyle? timeStyle,
    DateFormatStyle? dateStyle,
  ) => dateStyle != null || timeStyle != null
      ? null
      : (options.timestyle ?? TimeStyle.numeric);

  TimeStyle? _timeStyleOrNull(
    TimeFormatStyle? timeStyle,
    DateFormatStyle? dateStyle,
  ) => dateStyle != null || timeStyle != null ? null : options.timestyle;

  @override
  FormatterImpl d({DateFormatStyle? dateStyle}) => FormatterECMA(
    this,
    DateTimeJSOptions(
      year: null,
      day: _timeStyle(null, dateStyle),
      month: null,
    ),
    locale,
    options,
    timeStyle: null,
    dateStyle: dateStyle,
  );

  @override
  FormatterImpl m({DateFormatStyle? dateStyle}) => FormatterECMA(
    this,
    DateTimeJSOptions(
      year: null,
      day: null,
      month: _timeStyle(null, dateStyle),
    ),
    locale,
    options,
    timeStyle: null,
    dateStyle: dateStyle,
  );

  @override
  FormatterImpl md({DateFormatStyle? dateStyle}) => FormatterECMA(
    this,
    DateTimeJSOptions(
      year: null,
      day: _timeStyle(null, dateStyle),
      month: _timeStyle(null, dateStyle),
    ),
    locale,
    options,
    timeStyle: null,
    dateStyle: dateStyle,
  );

  @override
  FormatterImpl t({TimeFormatStyle? style}) => FormatterECMA(
    this,
    DateTimeJSOptions(
      hour: _timeStyle(style, null),
      minute: _timeStyleOrNull(style, null),
    ),
    locale,
    options,
    timeStyle: style,
    dateStyle: null,
  );

  @override
  FormatterImpl y({DateFormatStyle? dateStyle}) => FormatterECMA(
    this,
    DateTimeJSOptions(year: _timeStyle(null, dateStyle)),
    locale,
    options,
    timeStyle: null,
    dateStyle: dateStyle,
  );

  @override
  FormatterImpl ymd({DateFormatStyle? dateStyle}) => FormatterECMA(
    this,
    DateTimeJSOptions(
      year: _timeStyle(null, dateStyle),
      month: _timeStyle(null, dateStyle),
      day: _timeStyle(null, dateStyle),
    ),
    locale,
    options,
    timeStyle: null,
    dateStyle: dateStyle,
  );

  @override
  FormatterImpl ymde({DateFormatStyle? dateStyle}) => FormatterECMA(
    this,
    DateTimeJSOptions(),
    locale,
    options,
    timeStyle: null,
    dateStyle: dateStyle,
  );

  @override
  FormatterImpl ymdet({
    DateFormatStyle? dateStyle,
    TimeFormatStyle? timeStyle,
  }) => FormatterECMA(
    this,
    DateTimeJSOptions(
      hour: _timeStyle(timeStyle, dateStyle),
      minute: _timeStyleOrNull(timeStyle, dateStyle),
      year: _timeStyle(timeStyle, dateStyle),
      month: _timeStyle(timeStyle, dateStyle),
      day: _timeStyle(timeStyle, dateStyle),
      weekday: Style.short,
    ),
    locale,
    options,
    timeStyle: timeStyle,
    dateStyle: dateStyle,
  );

  @override
  FormatterImpl mdt({DateFormatStyle? dateStyle, TimeFormatStyle? timeStyle}) =>
      FormatterECMA(
        this,
        DateTimeJSOptions(
          hour: _timeStyle(timeStyle, dateStyle),
          minute: _timeStyleOrNull(timeStyle, dateStyle),
          month: _timeStyle(timeStyle, dateStyle),
          day: _timeStyle(timeStyle, dateStyle),
        ),
        locale,
        options,
        timeStyle: timeStyle,
        dateStyle: dateStyle,
      );

  @override
  FormatterImpl ymdt({
    DateFormatStyle? dateStyle,
    TimeFormatStyle? timeStyle,
  }) => FormatterECMA(
    this,
    DateTimeJSOptions(
      hour: _timeStyle(timeStyle, dateStyle),
      minute: _timeStyleOrNull(timeStyle, dateStyle),
      year: _timeStyle(timeStyle, dateStyle),
      month: _timeStyle(timeStyle, dateStyle),
      day: _timeStyle(timeStyle, dateStyle),
    ),
    locale,
    options,
    timeStyle: timeStyle,
    dateStyle: dateStyle,
  );

  static List<Locale> supportedLocalesOf(Locale locale) {
    return DateTimeFormat.supportedLocalesOf(
      [locale.toLanguageTag().toJS].toJS,
    ).toDart.whereType<String>().map(Locale.parse).toList();
  }

  static DateTimeFormatImpl tryToBuild(
    Locale locale,
    DateTimeFormatOptions options,
  ) {
    final supportedLocales = supportedLocalesOf(locale);
    return _DateTimeFormatECMA(
      supportedLocales.firstOrNull ?? Locale.parse('und'),
      options,
    );
  }
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

@JS('Intl.DateTimeFormat')
extension type DateTimeFormat._(JSObject _) implements JSObject {
  external factory DateTimeFormat([JSArray<JSString> locale, JSAny options]);
  external String format(JSAny num);

  external static JSArray<JSString> supportedLocalesOf(
    JSArray listOfLocales, [
    JSAny options,
  ]);
}

extension on DateTime {
  Date get js => Date(year, month - 1, day, hour, minute, second, millisecond);

  Date get jsUtc => Date.fromTimeStamp(
    Date.UTC(year, month - 1, day, hour, minute, second, millisecond),
  );
}

extension on DateTimeFormatOptions {
  JSAny toJsMap(
    DateTimeJSOptions options,
    TimeFormatStyle? timeStyle,
    DateFormatStyle? dateStyle,
  ) => {
    if (dateStyle != null) 'dateStyle': dateStyle.name,
    if (timeStyle != null) 'timeStyle': timeStyle.name,
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
    if (options.weekday != null && dateStyle == null)
      'weekday': options.weekday!.name,
    if (era != null && dateStyle == null) 'era': era!.name,
    if (options.year != null && dateStyle == null) 'year': options.year!.jsName,
    if (options.month != null && dateStyle == null)
      'month': options.month!.jsName,
    if (options.day != null && dateStyle == null) 'day': options.day!.jsName,
    if (options.hour != null && timeStyle == null) 'hour': options.hour!.jsName,
    if (options.minute != null && timeStyle == null)
      'minute': options.minute!.jsName,
    if (options.second != null && timeStyle == null)
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
