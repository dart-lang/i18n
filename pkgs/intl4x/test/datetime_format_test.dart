// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  testWithFormatting('Basic', () {
    expect(
      Intl(
        locale: const Locale(language: 'en', region: 'US'),
      ).datetimeFormat().format(DateTime.utc(2012, 12, 20, 3, 0, 0)),
      '12/20/2012',
    );
  });

  testWithFormatting('timezone', () {
    final date = DateTime.utc(2021, 12, 17, 3, 0, 42).toLocal();
    final intl = Intl(locale: const Locale(language: 'en', region: 'US'));
    const timeZone = 'America/Los_Angeles';
    const offset = '-08:00';
    expect(
      intl
          .datetimeFormat(
            const DateTimeFormatOptions(
              timeZone: TimeZone.short(name: timeZone, offset: offset),
            ),
          )
          .format(date),
      '12/16/2021, PST',
    );
    expect(
      intl
          .datetimeFormat(
            const DateTimeFormatOptions(
              timeZone: TimeZone.long(name: timeZone, offset: offset),
            ),
          )
          .format(date),
      '12/16/2021, Pacific Standard Time',
    );
    expect(
      intl
          .datetimeFormat(
            const DateTimeFormatOptions(
              timeZone: TimeZone.shortOffset(name: timeZone, offset: offset),
            ),
          )
          .format(date),
      '12/16/2021, GMT-8',
    );
    expect(
      intl
          .datetimeFormat(
            const DateTimeFormatOptions(
              timeZone: TimeZone.longOffset(name: timeZone, offset: offset),
            ),
          )
          .format(date),
      '12/16/2021, GMT-08:00',
    );
    expect(
      intl
          .datetimeFormat(
            const DateTimeFormatOptions(
              timeZone: TimeZone.shortGeneric(name: timeZone, offset: offset),
            ),
          )
          .format(date),
      '12/16/2021, PT',
    );
    expect(
      intl
          .datetimeFormat(
            const DateTimeFormatOptions(
              timeZone: TimeZone.longGeneric(name: timeZone, offset: offset),
            ),
          )
          .format(date),
      '12/16/2021, Pacific Time',
    );
  });

  testWithFormatting('day period', () {
    final date = DateTime.utc(2021, 12, 17, 4, 0, 42);
    expect(
      Intl(locale: const Locale(language: 'en', region: 'GB'))
          .datetimeFormat(
            const DateTimeFormatOptions(
              hour: TimeStyle.numeric,
              clockstyle: ClockStyle(is12Hour: true, startAtZero: false),
              dayPeriod: DayPeriod.short,
            ),
          )
          .format(date),
      '4 at night',
    );

    expect(
      Intl(locale: const Locale(language: 'fr'))
          .datetimeFormat(
            const DateTimeFormatOptions(
              hour: TimeStyle.numeric,
              clockstyle: ClockStyle(is12Hour: true, startAtZero: false),
              dayPeriod: DayPeriod.narrow,
            ),
          )
          .format(date),
      '4 mat.',
    );

    expect(
      Intl(locale: const Locale(language: 'fr'))
          .datetimeFormat(
            const DateTimeFormatOptions(
              hour: TimeStyle.numeric,
              clockstyle: ClockStyle(is12Hour: true, startAtZero: false),
              dayPeriod: DayPeriod.long,
            ),
          )
          .format(date),
      '4 du matin',
    );
  });

  testWithFormatting('style', () {
    final date = DateTime.utc(2021, 12, 17, 4, 0, 42);
    expect(
      Intl(locale: const Locale(language: 'en'))
          .datetimeFormat(
            const DateTimeFormatOptions(timeFormatStyle: TimeFormatStyle.short),
          )
          .format(date),
      matches('4:00\\sAM'),
    );
    expect(
      Intl(locale: const Locale(language: 'en'))
          .datetimeFormat(
            const DateTimeFormatOptions(dateFormatStyle: DateFormatStyle.short),
          )
          .format(date),
      '12/17/21',
    );
    expect(
      Intl(locale: const Locale(language: 'en'))
          .datetimeFormat(
            const DateTimeFormatOptions(
              timeFormatStyle: TimeFormatStyle.medium,
              dateFormatStyle: DateFormatStyle.short,
            ),
          )
          .format(date),
      matches('12/17/21, 4:00:42\\sAM'),
    );
  });
}
