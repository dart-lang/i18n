// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS()
import '../../intl4x.dart';
import '../utils.dart';
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
  DatetimeFormatECMA(super.intl, super.options);

  @override
  String formatImpl(DateTime datetime) {
    var o = newObject<Object>();
    setProperty(o, 'localeMatcher', options.localeMatcher.jsName);
    if (options.dateStyle != null) {
      setProperty(o, 'dateStyle', options.dateStyle!.name);
    }
    if (options.timeStyle != null) {
      setProperty(o, 'timeStyle', options.timeStyle!.name);
    }
    if (options.calendar != null) {
      setProperty(o, 'calendar', options.calendar!.jsName);
    }
    if (options.dayPeriod != null) {
      setProperty(o, 'dayPeriod', options.dayPeriod!.name);
    }
    if (options.numberingSystem != null) {
      setProperty(o, 'numberingSystem', options.numberingSystem!.name);
    }
    if (options.timeZone != null) {
      setProperty(o, 'timeZone', options.timeZone!);
    }
    if (options.hour12 != null) {
      setProperty(o, 'hour12', options.hour12!);
    }
    if (options.hourCycle != null) {
      setProperty(o, 'hourCycle', options.hourCycle!.name);
    }
    if (options.formatMatcher != null) {
      setProperty(o, 'formatMatcher', options.formatMatcher!.jsName);
    }
    if (options.weekday != null) {
      setProperty(o, 'weekday', options.weekday!.name);
    }
    if (options.era != null) {
      setProperty(o, 'era', options.era!.name);
    }
    if (options.year != null) {
      setProperty(o, 'year', options.year!.jsName);
    }
    if (options.month != null) {
      setProperty(o, 'month', options.month!.jsName);
    }
    if (options.day != null) {
      setProperty(o, 'day', options.day!.jsName);
    }
    if (options.hour != null) {
      setProperty(o, 'hour', options.hour!.jsName);
    }
    if (options.minute != null) {
      setProperty(o, 'minute', options.minute!.jsName);
    }
    if (options.second != null) {
      setProperty(o, 'second', options.second!.jsName);
    }
    if (options.fractionalSecondDigits != null) {
      setProperty(o, 'fractionalSecondDigits', options.fractionalSecondDigits!);
    }
    if (options.timeZoneName != null) {
      setProperty(o, 'timeZoneName', options.timeZoneName!.name);
    }
    return DatetimeFormatJS(localeToJs(intl.locale), o)
        .format(DateJS(datetime.millisecondsSinceEpoch));
  }

  @override
  List<String> supportedLocalesOf(List<String> locales) {
    var o = newObject<Object>();
    setProperty(o, 'localeMatcher', options.localeMatcher.jsName);
    return supportedLocalesOfJS(locales.map(localeToJs).toList(), o);
  }
}
