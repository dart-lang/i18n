// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale.dart';
import '../options.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

DateTimeFormatImpl? getDateTimeFormatterECMA(
  Locale locale,
  LocaleMatcher localeMatcher,
) =>
    _DateTimeFormatECMA.tryToBuild(locale, localeMatcher);

@JS('Intl.DateTimeFormat')
class _DateTimeFormatJS {
  external factory _DateTimeFormatJS([List<String> locale, Object options]);
  external String format(Object num);
}

@JS('Intl.DateTimeFormat.supportedLocalesOf')
external List<String> _supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

@JS('Date')
class DateJS {
  external factory DateJS(
    int year,
    int monthIndex,
    int day,
    int hours,
    int minutes,
    int seconds,
    int milliseconds,
  );

  external factory DateJS.fromTimeStamp(int timeStamp);
}

@JS('Date.UTC')
// ignore: non_constant_identifier_names
external int UTC(
  int year,
  int monthIndex,
  int day,
  int hours,
  int minutes,
  int seconds,
  int milliseconds,
);

class _DateTimeFormatECMA extends DateTimeFormatImpl {
  _DateTimeFormatECMA(super.locale);

  static DateTimeFormatImpl? tryToBuild(
    Locale locale,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(localeMatcher, locale);
    return supportedLocales.isNotEmpty
        ? _DateTimeFormatECMA(supportedLocales.first)
        : null; //TODO: Add support to force return an instance instead of null.
  }

  static List<Locale> supportedLocalesOf(
    LocaleMatcher localeMatcher,
    Locale locale,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return List.from(_supportedLocalesOfJS([locale.toLanguageTag()], o))
        .whereType<String>()
        .map(Locale.parse)
        .toList();
  }

  @override
  String formatImpl(DateTime datetime, DateTimeFormatOptions options) {
    final datetimeFormatJS = _DateTimeFormatJS(
      [locale.toLanguageTag()],
      options.toJsOptions(),
    );
    return datetimeFormatJS.format(datetime.toJs());
  }
}

extension on DateTime {
  DateJS toJs() {
    if (isUtc) {
      return DateJS.fromTimeStamp(
          UTC(year, month - 1, day, hour, minute, second, millisecond));
    } else {
      return DateJS(year, month - 1, day, hour, minute, second, millisecond);
    }
  }
}

extension on DateTimeFormatOptions {
  Object toJsOptions() {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    if (dateFormatStyle != null) {
      setProperty(o, 'dateStyle', dateFormatStyle!.name);
    }
    if (timeFormatStyle != null) {
      setProperty(o, 'timeStyle', timeFormatStyle!.name);
    }
    if (calendar != null) setProperty(o, 'calendar', calendar!.jsName);
    if (dayPeriod != null) setProperty(o, 'dayPeriod', dayPeriod!.name);
    if (numberingSystem != null) {
      setProperty(o, 'numberingSystem', numberingSystem!.name);
    }
    if (timeZone != null) setProperty(o, 'timeZone', timeZone!);
    if (clockstyle != null) {
      setProperty(o, 'hour12', clockstyle!.is12Hour);
      if (clockstyle!.startAtZero != null) {
        setProperty(o, 'hourCycle', clockstyle!.hourStyleJsString());
      }
    }
    if (weekday != null) setProperty(o, 'weekday', weekday!.name);
    if (era != null) setProperty(o, 'era', era!.name);
    if (year != null) setProperty(o, 'year', year!.jsName);
    if (month != null) setProperty(o, 'month', month!.jsName);
    if (day != null) setProperty(o, 'day', day!.jsName);
    if (hour != null) setProperty(o, 'hour', hour!.jsName);
    if (minute != null) setProperty(o, 'minute', minute!.jsName);
    if (second != null) setProperty(o, 'second', second!.jsName);
    if (fractionalSecondDigits != null) {
      setProperty(o, 'fractionalSecondDigits', fractionalSecondDigits!);
    }
    if (timeZoneName != null) {
      setProperty(o, 'timeZoneName', timeZoneName!.name);
    }
    setProperty(o, 'formatMatcher', formatMatcher.jsName);
    return o;
  }
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
