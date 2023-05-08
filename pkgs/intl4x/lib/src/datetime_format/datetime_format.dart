// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';
import '../options.dart';
import '../test_checker.dart';

abstract class DatetimeFormat {
  final String locale;

  const DatetimeFormat(this.locale);

  String format(
    DateTime datetime, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
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
    TimeZoneName? timeZoneName,
  }) {
    if (isInTest) {
      return '$datetime//$locale';
    } else {
      return formatImpl(
        datetime,
        localeMatcher: localeMatcher,
        dateStyle: dateStyle,
        timeStyle: timeStyle,
        calendar: calendar,
        dayPeriod: dayPeriod,
        numberingSystem: numberingSystem,
        timeZone: timeZone,
        hour12: hour12,
        hourCycle: hourCycle,
        formatMatcher: formatMatcher,
        weekday: weekday,
        era: era,
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
        fractionalSecondDigits: fractionalSecondDigits,
        timeZoneName: timeZoneName,
      );
    }
  }

  String formatImpl(
    DateTime datetime, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
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
    TimeZoneName? timeZoneName,
  });
}
