// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@JS()

import 'package:intl4x/intl.dart';
import 'package:intl4x/src/datetime_format/datetime_format_options.dart';
import 'package:intl4x/src/utils.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'datetime_formatter.dart';

DatetimeFormatter getDatetimeFormatter(
        Intl intl, DatetimeFormatOptions datetimeFormatterData) =>
    DatetimeFormatECMA(intl, datetimeFormatterData);

@JS('Date')
class DateJS {
  external factory DateJS(int epoch);
}

@JS('Intl.DateTimeFormat')
class DatetimeFormatJS {
  external factory DatetimeFormatJS([String locale, Object options]);
  external String format(DateJS datetime);
}

@JS('Intl.DateTimeFormat.supportedLocalesOf')
external List<String> supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

class DatetimeFormatECMA extends DatetimeFormatter {
  DatetimeFormatECMA(super.intl, super.datetimeFormatterData);

  @override
  String formatImpl(DateTime datetime) {
    var o = newObject<Object>();
    setProperty(o, 'localeMatcher', datetimeFormatterData.localeMatcher.jsName);
    if (datetimeFormatterData.dateStyle != null) {
      setProperty(o, 'dateStyle', datetimeFormatterData.dateStyle!.name);
    }
    if (datetimeFormatterData.timeStyle != null) {
      setProperty(o, 'timeStyle', datetimeFormatterData.timeStyle!.name);
    }
    if (datetimeFormatterData.calendar != null) {
      setProperty(o, 'calendar', datetimeFormatterData.calendar!.jsName);
    }
    if (datetimeFormatterData.dayPeriod != null) {
      setProperty(o, 'dayPeriod', datetimeFormatterData.dayPeriod!.name);
    }
    if (datetimeFormatterData.numberingSystem != null) {
      setProperty(
          o, 'numberingSystem', datetimeFormatterData.numberingSystem!.name);
    }
    if (datetimeFormatterData.timeZone != null) {
      setProperty(o, 'timeZone', datetimeFormatterData.timeZone!);
    }
    if (datetimeFormatterData.hour12 != null) {
      setProperty(o, 'hour12', datetimeFormatterData.hour12!);
    }
    if (datetimeFormatterData.hourCycle != null) {
      setProperty(o, 'hourCycle', datetimeFormatterData.hourCycle!.name);
    }
    if (datetimeFormatterData.formatMatcher != null) {
      setProperty(
          o, 'formatMatcher', datetimeFormatterData.formatMatcher!.jsName);
    }
    if (datetimeFormatterData.weekday != null) {
      setProperty(o, 'weekday', datetimeFormatterData.weekday!.name);
    }
    if (datetimeFormatterData.era != null) {
      setProperty(o, 'era', datetimeFormatterData.era!.name);
    }
    if (datetimeFormatterData.year != null) {
      setProperty(o, 'year', datetimeFormatterData.year!.jsName);
    }
    if (datetimeFormatterData.month != null) {
      setProperty(o, 'month', datetimeFormatterData.month!.jsName);
    }
    if (datetimeFormatterData.day != null) {
      setProperty(o, 'day', datetimeFormatterData.day!.jsName);
    }
    if (datetimeFormatterData.hour != null) {
      setProperty(o, 'hour', datetimeFormatterData.hour!.jsName);
    }
    if (datetimeFormatterData.minute != null) {
      setProperty(o, 'minute', datetimeFormatterData.minute!.jsName);
    }
    if (datetimeFormatterData.second != null) {
      setProperty(o, 'second', datetimeFormatterData.second!.jsName);
    }
    if (datetimeFormatterData.fractionalSecondDigits != null) {
      setProperty(o, 'fractionalSecondDigits',
          datetimeFormatterData.fractionalSecondDigits!);
    }
    if (datetimeFormatterData.timeZoneName != null) {
      setProperty(o, 'timeZoneName', datetimeFormatterData.timeZoneName!.name);
    }
    return DatetimeFormatJS(localeToJs(intl.locale), o)
        .format(DateJS(datetime.millisecondsSinceEpoch));
  }

  @override
  List<String> supportedLocalesOf(
      List<String> locales, LocaleMatcher localeMatcher) {
    var o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return supportedLocalesOfJS(locales.map(localeToJs).toList(), o);
  }
}
