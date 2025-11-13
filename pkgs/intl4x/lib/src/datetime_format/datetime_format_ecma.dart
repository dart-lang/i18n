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

class _DateTimeJSOptions {
  final DateTimeLength? year;
  final DateTimeLength? month;
  final DateTimeLength? day;
  final DateTimeLength? hour;
  final DateTimeLength? minute;
  final DateTimeLength? second;
  final String? timeZone;
  final TimeZoneType? timeZoneType;
  final Style? weekday;

  _DateTimeJSOptions.from({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.timeZone,
    this.timeZoneType,
    this.weekday,
  }) {}

  JSAny get toJS => {
    // if (dateStyle != null) 'dateStyle': dateStyle.name,
    // if (timeStyle != null) 'timeStyle': timeStyle.name,
    // if (calendar != null) 'calendar': calendar!.jsName,
    // if (dayPeriod != null) 'dayPeriod': dayPeriod!.name,
    // if (numberingSystem != null) 'numberingSystem': numberingSystem!.name,
    // if (options.timeZone != null) ...{
    //   'timeZone': options.timeZone,
    //   'timeZoneName': options.timeZoneType!.name,
    // },
    // if (clockstyle != null) ...{
    //   'hour12': clockstyle!.is12Hour,
    //   'hourCycle': clockstyle!.hourStyleExtensionString,
    // },
    // if (options.weekday != null && dateStyle == null)
    //   'weekday': options.weekday!.name,
    // if (withEra && dateStyle == null) 'era': Style.short.name,
    // if (options.year != null && dateStyle == null) 'year': options.year!.jsName,
    // if (options.month != null && dateStyle == null)
    //   'month': options.month!.jsName,
    // if (options.day != null && dateStyle == null) 'day': options.day!.jsName,
    // if (options.hour != null && timeStyle == null) 'hour': options.hour!.jsName,
    // if (options.minute != null && timeStyle == null)
    //   'minute': options.minute!.jsName,
    // if (options.second != null && timeStyle == null)
    //   'second': options.second!.jsName,
    // if (fractionalSecondDigits != null)
    //   'fractionalSecondDigits': fractionalSecondDigits!,
    // 'formatMatcher': formatMatcher.jsName,
  }.jsify()!;
}

enum _TimeStyle {
  numeric,
  twodigit('2-digit');

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const _TimeStyle([this._jsName]);
}

class FormatterECMA extends FormatterImpl {
  final Locale locale;
  final _DateTimeJSOptions _optionsJS;
  final DateTimeFormatImpl impl;
  final DateTimeFormat dateTimeFormat;

  FormatterECMA._(this.impl, this._optionsJS, this.locale)
    : dateTimeFormat = DateTimeFormat(
        [locale.toLanguageTag().toJS].toJS,
        _optionsJS.toJS,
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
  final FormatterECMA formatter;

  FormatterZonedECMA(TimeZoneType timeZoneType, this.formatter)
    : super(formatter.impl, timeZoneType);

  static DateTimeFormat createDateTimeFormat(
    FormatterECMA formatter,
    TimeZoneType timeZoneType,
    String timeZone,
  ) {
    final localeJS = [formatter.locale.toLanguageTag().toJS].toJS;
    return DateTimeFormat(localeJS, formatter._optionsJS.toJS);
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
      FormatterECMA._(
        this,
        _DateTimeJSOptions.from(alignment: alignment, length: length),
        locale,
      );

  @override
  FormatterImpl m({DateTimeAlignment? alignment, DateTimeLength? length}) =>
      FormatterECMA._(
        this,
        _DateTimeJSOptions.from(alignment: alignment, length: length),
        locale,
      );

  @override
  FormatterImpl md({DateTimeAlignment? alignment, DateTimeLength? length}) =>
      FormatterECMA._(
        this,
        _DateTimeJSOptions.from(alignment: alignment, length: length),
        locale,
      );

  @override
  FormatterImpl t({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) => FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      alignment: alignment,
      length: length,
      timePrecision: timePrecision,
    ),
    locale,
  );

  @override
  FormatterImpl y({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      alignment: alignment,
      length: length,
      yearStyle: yearStyle,
    ),
    locale,
  );

  @override
  FormatterImpl ymd({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      alignment: alignment,
      length: length,
      yearStyle: yearStyle,
    ),
    locale,
  );

  @override
  FormatterImpl ymde({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
  }) => FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      alignment: alignment,
      length: length,
      yearStyle: yearStyle,
    ),
    locale,
  );

  @override
  FormatterImpl ymdet({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  }) => FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      alignment: alignment,
      length: length,
      yearStyle: yearStyle,
      timePrecision: timePrecision,
    ),
    locale,
  );

  @override
  FormatterImpl mdt({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
  }) => FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      alignment: alignment,
      length: length,
      timePrecision: timePrecision,
    ),
    locale,
  );

  @override
  FormatterImpl ymdt({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    TimePrecision? timePrecision,
    YearStyle? yearStyle,
  }) => FormatterECMA._(
    this,
    _DateTimeJSOptions.from(
      alignment: alignment,
      length: length,
      yearStyle: yearStyle,
      timePrecision: timePrecision,
    ),
    locale,
  );

  static List<Locale> supportedLocalesOf(Locale locale) {
    return DateTimeFormat.supportedLocalesOf(
      [locale.toLanguageTag().toJS].toJS,
    ).toDart.whereType<String>().map(Locale.parse).toList();
  }

  static DateTimeFormatImpl tryToBuild(Locale locale) {
    final supportedLocales = supportedLocalesOf(locale);
    return _DateTimeFormatECMA(
      supportedLocales.firstOrNull ?? Locale.parse('und'),
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

Duration offsetForTimeZone(DateTime datetime, String iana) {
  final timeZoneName = DateTimeFormat(
    ['en'.toJS].toJS,
    {'timeZoneName': TimeZoneType.longOffset.name, 'timeZone': iana}.jsify()!,
  ).timeZoneName(datetime.js);
  return parseTimeZoneOffset(timeZoneName);
}

@JS('Intl.DateTimeFormat')
extension type DateTimeFormat._(JSObject _) implements JSObject {
  external factory DateTimeFormat([JSArray<JSString> locale, JSAny options]);
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
