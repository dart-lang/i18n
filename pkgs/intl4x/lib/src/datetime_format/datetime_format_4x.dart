// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';
import '../options.dart';
import 'datetime_format.dart';

DatetimeFormat getDatetimeFormatter4X(String locale) =>
    DatetimeFormat4X(locale);

class DatetimeFormat4X extends DatetimeFormat {
  DatetimeFormat4X(super.locale);

  // @override
  // List<String> supportedLocalesOf(List<String> locales) {
  //   return intl.icu4xDataKeys.entries
  //       .where((element) => element.value.contains('NumberFormat'))
  //       .map((e) => e.key)
  //       .toList();
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
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
