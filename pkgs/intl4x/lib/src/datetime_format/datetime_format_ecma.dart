// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS()
import '../../intl4x.dart';
import '../options.dart';
import '../utils.dart';
import 'datetime_format.dart';

DatetimeFormat getDatetimeFormatter(String locale) =>
    DatetimeFormatECMA(locale);

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

class DatetimeFormatECMA extends DatetimeFormat {
  DatetimeFormatECMA(super.locale);

  // @override
  // List<String> supportedLocalesOf(List<String> locales) {
  //   var o = newObject<Object>();
  //   setProperty(o, 'localeMatcher', localeMatcher.jsName);
  //   return supportedLocalesOfJS(locales.map(localeToJs).toList(), o);
  // }

  @override
  String formatImpl(DateTime datetime,
      {LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
      DateStyle? dateStyle,
      TimeStyle? timeStyle,
      Calendar? calendar,
      DayPeriod? dayPeriod,
      NumberingSystem? numberingSystem,
      String? timeZone,
      bool? hour12,
      HourCycle? hourCycle,
      FormatMatcher? formatMatcher,
      Weekday? weekday,
      Era? era,
      Year? year,
      Month? month,
      Day? day,
      Hour? hour,
      Minute? minute,
      Second? second,
      int? fractionalSecondDigits,
      TimeZoneName? timeZoneName}) {
    var o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    if (dateStyle != null) {
      setProperty(o, 'dateStyle', dateStyle.name);
    }
    if (timeStyle != null) {
      setProperty(o, 'timeStyle', timeStyle.name);
    }
    if (calendar != null) {
      setProperty(o, 'calendar', calendar.jsName);
    }
    if (dayPeriod != null) {
      setProperty(o, 'dayPeriod', dayPeriod.name);
    }
    if (numberingSystem != null) {
      setProperty(o, 'numberingSystem', numberingSystem.name);
    }
    if (timeZone != null) {
      setProperty(o, 'timeZone', timeZone);
    }
    if (hour12 != null) {
      setProperty(o, 'hour12', hour12);
    }
    if (hourCycle != null) {
      setProperty(o, 'hourCycle', hourCycle.name);
    }
    if (formatMatcher != null) {
      setProperty(o, 'formatMatcher', formatMatcher.jsName);
    }
    if (weekday != null) {
      setProperty(o, 'weekday', weekday.name);
    }
    if (era != null) {
      setProperty(o, 'era', era.name);
    }
    if (year != null) {
      setProperty(o, 'year', year.jsName);
    }
    if (month != null) {
      setProperty(o, 'month', month.jsName);
    }
    if (day != null) {
      setProperty(o, 'day', day.jsName);
    }
    if (hour != null) {
      setProperty(o, 'hour', hour.jsName);
    }
    if (minute != null) {
      setProperty(o, 'minute', minute.jsName);
    }
    if (second != null) {
      setProperty(o, 'second', second.jsName);
    }
    if (fractionalSecondDigits != null) {
      setProperty(o, 'fractionalSecondDigits', fractionalSecondDigits);
    }
    if (timeZoneName != null) {
      setProperty(o, 'timeZoneName', timeZoneName.name);
    }
    return DatetimeFormatJS(localeToJs(locale), o)
        .format(DateJS(datetime.millisecondsSinceEpoch));
  }
}
