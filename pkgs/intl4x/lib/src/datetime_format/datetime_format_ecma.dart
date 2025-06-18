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
  String formatImpl(DateTime datetime) => DateTimeFormat(
    [locale.toLanguageTag().toJS].toJS,
    options.toJsOptions(),
  ).format(datetime.toJs());
}

extension on DateTime {
  // We assume the date is UTC
  Date toJs() => Date(year, month - 1, day, hour, minute, second, millisecond);
}

extension on DateTimeFormatOptions {
  JSAny toJsOptions() =>
      {
        'localeMatcher': localeMatcher.jsName,
        if (dateFormatStyle != null) 'dateStyle': dateFormatStyle!.name,
        if (timeFormatStyle != null) 'timeStyle': timeFormatStyle!.name,
        if (calendar != null) 'calendar': calendar!.jsName,
        if (dayPeriod != null) 'dayPeriod': dayPeriod!.name,
        if (numberingSystem != null) 'numberingSystem': numberingSystem!.name,
        if (timeZone != null) 'timeZone': timeZone!.name,
        if (clockstyle != null) 'hour12': clockstyle!.is12Hour,
        if (clockstyle != null && clockstyle!.startAtZero != null)
          'hourCycle': clockstyle!.hourStyleJsString(),
        if (weekday != null) 'weekday': weekday!.name,
        if (era != null) 'era': era!.name,
        if (year != null) 'year': year!.jsName,
        if (month != null) 'month': month!.jsName,
        if (day != null) 'day': day!.jsName,
        if (hour != null) 'hour': hour!.jsName,
        if (minute != null) 'minute': minute!.jsName,
        if (second != null) 'second': second!.jsName,
        if (fractionalSecondDigits != null)
          'fractionalSecondDigits': fractionalSecondDigits!,
        if (timeZone != null) 'timeZoneName': timeZone!.type.name,
        'formatMatcher': formatMatcher.jsName,
      }.jsify()!;
}

extension on ClockStyle {
  String hourStyleJsString() {
    // The four possible values are h11, h12, h23, h24.
    final firstDigit = is12Hour ? 1 : 2;

    final subtrahend = startAtZero! ? 1 : 0;
    final secondDigit = firstDigit * 2 - subtrahend;

    /// The cases are
    /// * firstDigit == 1 && subtrahend == 1  --> h11
    /// * firstDigit == 1 && subtrahend == 0  --> h12
    /// * firstDigit == 2 && subtrahend == 1  --> h23
    /// * firstDigit == 2 && subtrahend == 0  --> h24
    return 'h$firstDigit$secondDigit';
  }
}
