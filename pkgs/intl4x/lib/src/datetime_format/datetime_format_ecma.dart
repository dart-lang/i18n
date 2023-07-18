// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale.dart';
import '../options.dart';
import '../utils.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

DatetimeFormatImpl? getDatetimeFormatterECMA(
  Locale locale,
  LocaleMatcher localeMatcher,
) =>
    _DatetimeFormatECMA.tryToBuild(locale, localeMatcher);

@JS('Intl.DateTimeFormat')
class _DatetimeFormatJS {
  external factory _DatetimeFormatJS([List<String> locale, Object options]);
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

class _DatetimeFormatECMA extends DatetimeFormatImpl {
  _DatetimeFormatECMA(super.locales);

  static DatetimeFormatImpl? tryToBuild(
    Locale locale,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(localeMatcher, locale);
    return supportedLocales.isNotEmpty
        ? _DatetimeFormatECMA(supportedLocales.first)
        : null; //TODO: Add support to force return an instance instead of null.
  }

  static List<String> supportedLocalesOf(
    LocaleMatcher localeMatcher,
    Locale locale,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return List.from(_supportedLocalesOfJS([localeToJsFormat(locale)], o));
  }

  @override
  String formatImpl(DateTime datetime, DatetimeFormatOptions options) {
    final datetimeFormatJS = _DatetimeFormatJS(
      [localeToJsFormat(locale)],
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

extension on DatetimeFormatOptions {
  Object toJsOptions() {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    if (dateStyle != null) setProperty(o, 'dateStyle', dateStyle!.name);
    if (timeStyle != null) setProperty(o, 'timeStyle', timeStyle!.name);
    if (calendar != null) setProperty(o, 'calendar', calendar!.jsName);
    if (dayPeriod != null) setProperty(o, 'dayPeriod', dayPeriod!.name);
    if (numberingSystem != null) {
      setProperty(o, 'numberingSystem', numberingSystem!.name);
    }
    if (timeZone != null) setProperty(o, 'timeZone', timeZone!);
    if (hour12 ?? false) setProperty(o, 'hour12', true);
    if (hourCycle != null) setProperty(o, 'hourCycle', hourCycle!.name);
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
