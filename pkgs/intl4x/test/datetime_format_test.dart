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

  group('timezone', () {
    final date = DateTime.utc(2021, 12, 17, 3, 0, 42);
    final intl = Intl(locale: const Locale(language: 'en', region: 'US'));
    const timeZone = 'America/Los_Angeles';
    const offset = '-08:00';
    testWithFormatting(
      'short',
      () => expect(
        intl
            .datetimeFormat(
              const DateTimeFormatOptions(
                timeZone: TimeZone.short(name: timeZone, offset: offset),
              ),
            )
            .format(date),
        '12/16/2021, PST',
      ),
    );
    testWithFormatting(
      'long',
      () => expect(
        intl
            .datetimeFormat(
              const DateTimeFormatOptions(
                timeZone: TimeZone.long(name: timeZone, offset: offset),
              ),
            )
            .format(date),
        '12/16/2021, Pacific Standard Time',
      ),
    );
    testWithFormatting(
      'shortOffset',
      () => expect(
        intl
            .datetimeFormat(
              const DateTimeFormatOptions(
                timeZone: TimeZone.shortOffset(name: timeZone, offset: offset),
              ),
            )
            .format(date),
        '12/16/2021, GMT-8',
      ),
    );
    testWithFormatting(
      'longOffset',
      () => expect(
        intl
            .datetimeFormat(
              const DateTimeFormatOptions(
                timeZone: TimeZone.longOffset(name: timeZone, offset: offset),
              ),
            )
            .format(date),
        '12/16/2021, GMT-08:00',
      ),
    );
    testWithFormatting(
      'shortGeneric',
      () => expect(
        intl
            .datetimeFormat(
              const DateTimeFormatOptions(
                timeZone: TimeZone.shortGeneric(name: timeZone, offset: offset),
              ),
            )
            .format(date),
        '12/16/2021, PT',
      ),
    );
    testWithFormatting(
      'longGeneric',
      () => expect(
        intl
            .datetimeFormat(
              const DateTimeFormatOptions(
                timeZone: TimeZone.longGeneric(name: timeZone, offset: offset),
              ),
            )
            .format(date),
        '12/16/2021, Pacific Time',
      ),
    );
  });

  group('day period', () {
    final date = DateTime.utc(2021, 12, 17, 4, 0, 42);
    testWithFormatting(
      'short',
      () => expect(
        Intl(locale: const Locale(language: 'en', region: 'GB'))
            .datetimeFormat(
              const DateTimeFormatOptions(
                hour: TimeStyle.numeric,
                clockstyle: ClockStyle.startOneIs12Hour,
                dayPeriod: DayPeriod.short,
              ),
            )
            .format(date),
        '4 at night',
      ),
    );

    testWithFormatting(
      'narrow',
      () => expect(
        Intl(locale: const Locale(language: 'fr'))
            .datetimeFormat(
              const DateTimeFormatOptions(
                hour: TimeStyle.numeric,
                clockstyle: ClockStyle.startOneIs12Hour,
                dayPeriod: DayPeriod.narrow,
              ),
            )
            .format(date),
        '4 mat.',
      ),
    );

    testWithFormatting(
      'long',
      () => expect(
        Intl(locale: const Locale(language: 'fr'))
            .datetimeFormat(
              const DateTimeFormatOptions(
                hour: TimeStyle.numeric,
                clockstyle: ClockStyle.startOneIs12Hour,
                dayPeriod: DayPeriod.long,
              ),
            )
            .format(date),
        '4 du matin',
      ),
    );
  }, tags: ['icu4xUnimplemented']);

  group('date style', () {
    final date = DateTime.utc(2021, 12, 17, 4, 0, 42);
    testWithFormatting(
      'short',
      () => expect(
        Intl(locale: const Locale(language: 'en'))
            .datetimeFormat(
              const DateTimeFormatOptions(
                dateFormatStyle: DateFormatStyle.short,
              ),
            )
            .format(date),
        '12/17/21',
      ),
    );
    testWithFormatting(
      'medium',
      () => expect(
        Intl(locale: const Locale(language: 'en'))
            .datetimeFormat(
              const DateTimeFormatOptions(
                dateFormatStyle: DateFormatStyle.medium,
              ),
            )
            .format(date),
        'Dec 17, 2021',
      ),
    );
    testWithFormatting(
      'long',
      () => expect(
        Intl(locale: const Locale(language: 'en'))
            .datetimeFormat(
              const DateTimeFormatOptions(
                dateFormatStyle: DateFormatStyle.long,
              ),
            )
            .format(date),
        'December 17, 2021',
      ),
    );
  });

  group('time style', () {
    final date = DateTime.utc(2021, 12, 17, 4, 0, 00);
    final intl = Intl(locale: const Locale(language: 'en'));

    testWithFormatting(
      'short',
      () => expect(
        intl
            .datetimeFormat(
              const DateTimeFormatOptions(
                timeFormatStyle: TimeFormatStyle.short,
              ),
            )
            .format(date),
        matches(r'^4:00\sAM$'),
      ),
    );
    testWithFormatting(
      'medium',
      () => expect(
        intl
            .datetimeFormat(
              const DateTimeFormatOptions(
                timeFormatStyle: TimeFormatStyle.medium,
              ),
            )
            .format(date),
        matches(r'^4:00:00\sAM$'),
      ),
    );
    testWithFormatting(
      'long',
      () => expect(
        intl
            .datetimeFormat(
              const DateTimeFormatOptions(
                timeFormatStyle: TimeFormatStyle.long,
              ),
            )
            .format(date),

        matches(r'^4:00:00\sAM GMT\+1$'),
      ),
      tags: ['icu4xUnimplemented'],
    );
  });

  group('datetime style', () {
    final date = DateTime.utc(2021, 12, 17, 4, 0, 42);
    final intl = Intl(locale: const Locale(language: 'en'));
    testWithFormatting(
      'medium short',
      () => expect(
        intl
            .datetimeFormat(
              const DateTimeFormatOptions(
                timeFormatStyle: TimeFormatStyle.medium,
                dateFormatStyle: DateFormatStyle.short,
              ),
            )
            .format(date),
        matches(r'^12/17/21, 4:00:42\sAM$'),
      ),
    );
  });

  group('individual options', () {
    final date = DateTime.utc(2025, 6, 18, 10, 30, 45, 123);
    final intlEnUS = Intl(locale: const Locale(language: 'en', region: 'US'));

    group('calendar', () {
      testWithFormatting(
        'calendar - chinese',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  calendar: Calendar.chinese,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .format(date),
          '5/23/2025',
        ),
      );

      testWithFormatting(
        'calendar - japanese',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  calendar: Calendar.japanese,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .format(date),
          '6/18/7 R',
        ),
      );

      testWithFormatting(
        'calendar - islamic',
        () => expect(
          Intl(locale: const Locale(language: 'ar'))
              .datetimeFormat(
                const DateTimeFormatOptions(
                  calendar: Calendar.islamic,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .format(date),
          // Dhu al-Hijjah 12, 1446 AH
          '22‏/12‏/1446 هـ', // 12/11/1446 AH
        ),
      );
    });

    group('numberingSystem', () {
      testWithFormatting(
        'numberingSystem - arab',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  numberingSystem: NumberingSystem.arab,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .format(DateTime.utc(2025, 6, 18)),
          '٦/١٨/٢٥', // 18/6/25 in Arabic numerals
        ),
      );

      testWithFormatting(
        'numberingSystem - devanagari',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  numberingSystem: NumberingSystem.deva,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .format(DateTime.utc(2025, 6, 18)),
          '६/१८/२५', // 18/6/25 in Devanagari numerals
        ),
      );

      testWithFormatting(
        'numberingSystem - thai',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  numberingSystem: NumberingSystem.thai,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .format(DateTime.utc(2025, 6, 18)),
          '๖/๑๘/๒๕', // 18/6/25 in Thai numerals
        ),
      );
    });

    group('clockstyle', () {
      testWithFormatting(
        'clockstyle - 24-hour',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  hour: TimeStyle.numeric,
                  minute: TimeStyle.twodigit,
                  clockstyle: ClockStyle.startZeroIs24Hour,
                ),
              )
              .format(DateTime.utc(2025, 6, 18, 15, 30, 0)),
          '15:30',
        ),
      );

      testWithFormatting(
        'clockstyle - 12-hour, startAtZero true (0 AM)',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  hour: TimeStyle.numeric,
                  minute: TimeStyle.twodigit,
                  clockstyle: ClockStyle.startOneIs12Hour,
                  dayPeriod: DayPeriod.short,
                ),
              )
              .format(DateTime.utc(2025, 6, 18, 0, 30, 0)),
          '12:30 at night',
        ),
      );

      testWithFormatting(
        'clockstyle - 12-hour, startAtZero false (12 AM)',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  hour: TimeStyle.numeric,
                  minute: TimeStyle.twodigit,
                  clockstyle: ClockStyle.startOneIs12Hour,
                  dayPeriod: DayPeriod.short,
                ),
              )
              .format(DateTime.utc(2025, 6, 18, 0, 30, 0)),
          '12:30 at night',
        ),
      );
    });

    group('year, month, day, hour, minute, second', () {
      testWithFormatting(
        'year - numeric',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(year: TimeStyle.numeric),
              )
              .format(date),
          '2025',
        ),
      );

      testWithFormatting(
        'month - twodigit',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  month: MonthStyle.twodigit,
                  day: TimeStyle.numeric,
                ),
              )
              .format(DateTime.utc(2025, 6, 18)),
          '06/18',
        ),
      );

      testWithFormatting(
        'month - narrow',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  month: MonthStyle.narrow,
                  day: TimeStyle.numeric,
                ),
              )
              .format(DateTime.utc(2025, 1, 18)), // January
          'J 18',
        ),
      );

      testWithFormatting(
        'day - twodigit',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  day: TimeStyle.twodigit,
                  month: MonthStyle.numeric,
                ),
              )
              .format(DateTime.utc(2025, 6, 8)),
          '6/08',
        ),
      );

      testWithFormatting(
        'hour - twodigit',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  hour: TimeStyle.twodigit,
                  minute: TimeStyle.numeric,
                ),
              )
              .format(DateTime.utc(2025, 6, 18, 7, 30, 0)),
          matches(r'7:30\sAM'),
        ),
      );

      testWithFormatting(
        'minute - twodigit',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  minute: TimeStyle.twodigit,
                  hour: TimeStyle.numeric,
                ),
              )
              .format(DateTime.utc(2025, 6, 18, 7, 5, 0)),
          matches(r'7:05\sAM'),
        ),
      );

      testWithFormatting(
        'second - twodigit',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  second: TimeStyle.twodigit,
                  minute: TimeStyle.numeric,
                ),
              )
              .format(DateTime.utc(2025, 6, 18, 7, 30, 5)),
          '30:05',
        ),
      );
    });

    group('fractionalSecondDigits', () {
      testWithFormatting(
        'fractionalSecondDigits - 1 digit',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  hour: TimeStyle.numeric,
                  minute: TimeStyle.numeric,
                  second: TimeStyle.numeric,
                  fractionalSecondDigits: 1,
                ),
              )
              .format(DateTime.utc(2025, 6, 18, 10, 30, 45, 123)),
          matches(r'10:30:45.1\sAM'),
        ),
      );

      testWithFormatting(
        'fractionalSecondDigits - 3 digits',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  hour: TimeStyle.numeric,
                  minute: TimeStyle.numeric,
                  second: TimeStyle.numeric,
                  fractionalSecondDigits: 3,
                ),
              )
              .format(DateTime.utc(2025, 6, 18, 10, 30, 45, 123)),
          matches(r'10:30:45.123\sAM'),
        ),
      );
    });

    group('formatMatcher and localeMatcher', () {
      testWithFormatting(
        'formatMatcher - basic',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  formatMatcher: FormatMatcher.basic,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .format(DateTime.utc(2025, 6, 18)),
          '6/18/25',
        ),
      );

      testWithFormatting(
        'localeMatcher - lookup',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  localeMatcher: LocaleMatcher.lookup,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .format(DateTime.utc(2025, 6, 18)),
          '6/18/25',
        ),
      );
    });
  });

  group('combinations of options', () {
    final date = DateTime.utc(2025, 6, 18, 10, 30, 45, 123);
    final intlEnUS = Intl(locale: const Locale(language: 'en', region: 'US'));

    group('Time Zone + Date/Time Components', () {
      testWithFormatting(
        'timeZone long + hour numeric + minute twodigit',
        () => expect(
          intlEnUS
              .datetimeFormat(
                const DateTimeFormatOptions(
                  timeZone: TimeZone.long(
                    name: 'America/New_York',
                    offset: '-05:00',
                  ),
                  hour: TimeStyle.numeric,
                  minute: TimeStyle.twodigit,
                ),
              )
              .format(DateTime.utc(2025, 6, 18, 10, 30, 0)), // 10:30 AM UTC
          // This should convert to 5:30 AM New York time (UTC-4)
          matches(r'^4:30\sAM Eastern Daylight Time$'),
        ),
      );
    });

    group('Locale Specific Behavior', () {
      testWithFormatting(
        'French locale - long date, short time',
        () => expect(
          Intl(locale: const Locale(language: 'fr', region: 'FR'))
              .datetimeFormat(
                const DateTimeFormatOptions(
                  dateFormatStyle: DateFormatStyle.long,
                  timeFormatStyle: TimeFormatStyle.short,
                ),
              )
              .format(date),
          // Example: 18 juin 2025 à 10:30
          matches(r'^18 juin 2025 à 10:30$'),
        ),
        tags: ['icu4xUnimplemented'],
      );

      testWithFormatting(
        'German locale - full date, medium time, 24-hour clock',
        () => expect(
          Intl(locale: const Locale(language: 'de', region: 'DE'))
              .datetimeFormat(
                const DateTimeFormatOptions(
                  dateFormatStyle: DateFormatStyle.full,
                  timeFormatStyle: TimeFormatStyle.medium,
                  clockstyle: ClockStyle.startZeroIs24Hour,
                ),
              )
              .format(date),

          // Example: Mittwoch, 18. Juni 2025 um 10:30:45 Uhr
          'Mittwoch, 18. Juni 2025 um 10:30:45',
        ),
        tags: ['icu4xUnimplemented'],
      );
    });
  });
}
