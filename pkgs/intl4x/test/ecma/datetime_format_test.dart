// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  final date = DateTime.utc(2021, 12, 17, 4, 0, 42);
  testWithFormatting('Basic', () {
    expect(
        Intl(defaultLocale: 'en_US')
            .datetimeFormat()
            .format(DateTime.utc(2012, 12, 20, 3, 0, 0)),
        '12/20/2012');
  });

  testWithFormatting('timezone', () {
    final intl = Intl(defaultLocale: 'en_US');
    final timeZone = 'America/Los_Angeles';
    expect(
      intl
          .datetimeFormat(DatetimeFormatOptions(
            timeZone: timeZone,
            timeZoneName: TimeZoneName.short,
          ))
          .format(date),
      '12/16/2021, PST',
    );
    expect(
      intl
          .datetimeFormat(DatetimeFormatOptions(
            timeZone: timeZone,
            timeZoneName: TimeZoneName.long,
          ))
          .format(date),
      '12/16/2021, Pacific Standard Time',
    );
    expect(
      intl
          .datetimeFormat(DatetimeFormatOptions(
            timeZone: timeZone,
            timeZoneName: TimeZoneName.shortOffset,
          ))
          .format(date),
      '12/16/2021, GMT-8',
    );
    expect(
      intl
          .datetimeFormat(DatetimeFormatOptions(
            timeZone: timeZone,
            timeZoneName: TimeZoneName.longOffset,
          ))
          .format(date),
      '12/16/2021, GMT-08:00',
    );
    expect(
      intl
          .datetimeFormat(DatetimeFormatOptions(
            timeZone: timeZone,
            timeZoneName: TimeZoneName.shortGeneric,
          ))
          .format(date),
      '12/16/2021, PT',
    );
    expect(
      intl
          .datetimeFormat(DatetimeFormatOptions(
            timeZone: timeZone,
            timeZoneName: TimeZoneName.longGeneric,
          ))
          .format(date),
      '12/16/2021, Pacific Time',
    );
  });

  testWithFormatting('day period', () {
    expect(
        Intl(defaultLocale: 'en_GB')
            .datetimeFormat(const DatetimeFormatOptions(
              hour: TimeRepresentation.numeric,
              hourCycle: HourCycle.h12,
              dayPeriod: DayPeriod.short,
              timeZone: 'UTC',
            ))
            .format(date),
        '4 at night');

    expect(
        Intl(defaultLocale: 'fr')
            .datetimeFormat(const DatetimeFormatOptions(
              hour: TimeRepresentation.numeric,
              hourCycle: HourCycle.h12,
              dayPeriod: DayPeriod.narrow,
              timeZone: 'UTC',
            ))
            .format(date),
        '4 mat.');

    expect(
        Intl(defaultLocale: 'fr')
            .datetimeFormat(const DatetimeFormatOptions(
              hour: TimeRepresentation.numeric,
              hourCycle: HourCycle.h12,
              dayPeriod: DayPeriod.long,
              timeZone: 'UTC',
            ))
            .format(date),
        '4 du matin');
  });

  testWithFormatting('style', () {
    expect(
        Intl(defaultLocale: 'en')
            .datetimeFormat(const DatetimeFormatOptions(
              timeStyle: TimeStyle.short,
            ))
            .format(date),
        '5:00 AM');
    expect(
        Intl(defaultLocale: 'en')
            .datetimeFormat(const DatetimeFormatOptions(
              dateStyle: DateStyle.short,
            ))
            .format(date),
        '12/17/21');
    expect(
        Intl(defaultLocale: 'en')
            .datetimeFormat(const DatetimeFormatOptions(
              timeStyle: TimeStyle.medium,
              dateStyle: DateStyle.short,
            ))
            .format(date),
        '12/17/21, 5:00:42 AM');
  });
}
