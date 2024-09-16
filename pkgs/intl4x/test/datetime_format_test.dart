// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  testWithFormatting(
    'Basic',
    () {
      expect(
          Intl(locale: const Locale(language: 'en', region: 'US'))
              .datetimeFormat()
              .format(DateTime.utc(2012, 12, 20, 3, 0, 0)),
          '12/20/2012');
    },
    tags: ['icu4xUnimplemented'],
  );

  testWithFormatting(
    'timezone',
    () {
      final date = DateTime.utc(2021, 12, 17, 3, 0, 42);
      final intl = Intl(locale: const Locale(language: 'en', region: 'US'));
      final timeZone = 'America/Los_Angeles';
      expect(
        intl
            .datetimeFormat(DateTimeFormatOptions(
              timeZone: timeZone,
              timeZoneName: TimeZoneName.short,
            ))
            .format(date),
        '12/16/2021, PST',
      );
      expect(
        intl
            .datetimeFormat(DateTimeFormatOptions(
              timeZone: timeZone,
              timeZoneName: TimeZoneName.long,
            ))
            .format(date),
        '12/16/2021, Pacific Standard Time',
      );
      expect(
        intl
            .datetimeFormat(DateTimeFormatOptions(
              timeZone: timeZone,
              timeZoneName: TimeZoneName.shortOffset,
            ))
            .format(date),
        '12/16/2021, GMT-8',
      );
      expect(
        intl
            .datetimeFormat(DateTimeFormatOptions(
              timeZone: timeZone,
              timeZoneName: TimeZoneName.longOffset,
            ))
            .format(date),
        '12/16/2021, GMT-08:00',
      );
      expect(
        intl
            .datetimeFormat(DateTimeFormatOptions(
              timeZone: timeZone,
              timeZoneName: TimeZoneName.shortGeneric,
            ))
            .format(date),
        '12/16/2021, PT',
      );
      expect(
        intl
            .datetimeFormat(DateTimeFormatOptions(
              timeZone: timeZone,
              timeZoneName: TimeZoneName.longGeneric,
            ))
            .format(date),
        '12/16/2021, Pacific Time',
      );
    },
    tags: ['icu4xUnimplemented'],
  );

  testWithFormatting(
    'day period',
    () {
      final date = DateTime.utc(2021, 12, 17, 4, 0, 42);
      expect(
          Intl(locale: const Locale(language: 'en', region: 'GB'))
              .datetimeFormat(const DateTimeFormatOptions(
                hour: TimeStyle.numeric,
                clockstyle: ClockStyle(
                  is12Hour: true,
                  startAtZero: false,
                ),
                dayPeriod: DayPeriod.short,
                timeZone: 'UTC',
              ))
              .format(date),
          '4 at night');

      expect(
          Intl(locale: const Locale(language: 'fr'))
              .datetimeFormat(const DateTimeFormatOptions(
                hour: TimeStyle.numeric,
                clockstyle: ClockStyle(
                  is12Hour: true,
                  startAtZero: false,
                ),
                dayPeriod: DayPeriod.narrow,
                timeZone: 'UTC',
              ))
              .format(date),
          '4 mat.');

      expect(
          Intl(locale: const Locale(language: 'fr'))
              .datetimeFormat(const DateTimeFormatOptions(
                hour: TimeStyle.numeric,
                clockstyle: ClockStyle(
                  is12Hour: true,
                  startAtZero: false,
                ),
                dayPeriod: DayPeriod.long,
                timeZone: 'UTC',
              ))
              .format(date),
          '4 du matin');
    },
    tags: ['icu4xUnimplemented'],
  );

  testWithFormatting(
    'style',
    () {
      final date = DateTime.utc(2021, 12, 17, 4, 0, 42);
      expect(
          Intl(locale: const Locale(language: 'en'))
              .datetimeFormat(const DateTimeFormatOptions(
                timeFormatStyle: TimeFormatStyle.short,
                timeZone: 'UTC',
              ))
              .format(date),
          '4:00 AM');
      expect(
          Intl(locale: const Locale(language: 'en'))
              .datetimeFormat(const DateTimeFormatOptions(
                dateFormatStyle: DateFormatStyle.short,
                timeZone: 'UTC',
              ))
              .format(date),
          '12/17/21');
      expect(
          Intl(locale: const Locale(language: 'en'))
              .datetimeFormat(const DateTimeFormatOptions(
                timeFormatStyle: TimeFormatStyle.medium,
                dateFormatStyle: DateFormatStyle.short,
                timeZone: 'UTC',
              ))
              .format(date),
          '12/17/21, 4:00:42 AM');
    },
    tags: ['icu4xUnimplemented'],
  );
  testWithFormatting(
    'Extension',
    () {
      expect(
          DateTime.utc(2012, 12, 20, 3, 0, 0)
              .toLocaleDateString(const Locale(language: 'en', region: 'US')),
          '12/20/2012');
    },
    tags: ['icu4xUnimplemented'],
  );
}
