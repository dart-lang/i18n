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
      ).dateTimeFormat().ymd(DateTime(2012, 12, 20, 3, 0, 0)),
      '12/20/2012',
    );
  });

  group('timezone', () {
    final date = DateTime(2021, 12, 17, 3, 0, 42);
    final intl = Intl(locale: const Locale(language: 'en', region: 'US'));
    const timeZone = 'America/Los_Angeles';
    const offset = '-08:00';
    testWithFormatting(
      'short',
      () => expect(
        intl.dateTimeFormat().ymd(
          date,
          timeZone: const TimeZone.short(name: timeZone, offset: offset),
        ),
        matches(r'12/17/2021[,]? PST'),
      ),
    );
    testWithFormatting(
      'long',
      () => expect(
        intl.dateTimeFormat().ymd(
          date,
          timeZone: const TimeZone.long(name: timeZone, offset: offset),
        ),
        matches(r'12/17/2021[,]? Pacific Standard Time'),
      ),
    );
    testWithFormatting(
      'shortOffset',
      () => expect(
        intl
            .dateTimeFormat(const DateTimeFormatOptions())
            .ymd(
              date,
              timeZone: const TimeZone.shortOffset(
                name: timeZone,
                offset: offset,
              ),
            ),
        matches(r'12/17/2021[,]? GMT-8'),
      ),
    );
    testWithFormatting(
      'longOffset',
      () => expect(
        intl.dateTimeFormat().ymd(
          date,
          timeZone: const TimeZone.longOffset(name: timeZone, offset: offset),
        ),
        matches(r'12/17/2021[,]? GMT-08:00'),
      ),
    );
    testWithFormatting(
      'shortGeneric',
      () => expect(
        intl.dateTimeFormat().ymd(
          date,
          timeZone: const TimeZone.shortGeneric(name: timeZone, offset: offset),
        ),
        matches(r'12/17/2021[,]? PT'),
      ),
    );
    testWithFormatting(
      'longGeneric',
      () => expect(
        intl.dateTimeFormat().ymd(
          date,
          timeZone: const TimeZone.longGeneric(name: timeZone, offset: offset),
        ),
        matches(r'12/17/2021[,]? Pacific Time'),
      ),
    );
  });

  group('day period', () {
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    testWithFormatting(
      'short',
      () => expect(
        Intl(locale: const Locale(language: 'en', region: 'GB'))
            .dateTimeFormat(
              const DateTimeFormatOptions(
                clockstyle: ClockStyle.startOneIs12Hour,
                dayPeriod: DayPeriod.short,
              ),
            )
            .time(date),
        '4 at night',
      ),
    );

    testWithFormatting(
      'narrow',
      () => expect(
        Intl(locale: const Locale(language: 'fr'))
            .dateTimeFormat(
              const DateTimeFormatOptions(
                clockstyle: ClockStyle.startOneIs12Hour,
                dayPeriod: DayPeriod.narrow,
              ),
            )
            .time(date),
        '4 mat.',
      ),
    );

    testWithFormatting(
      'long',
      () => expect(
        Intl(locale: const Locale(language: 'fr'))
            .dateTimeFormat(
              const DateTimeFormatOptions(
                clockstyle: ClockStyle.startOneIs12Hour,
                dayPeriod: DayPeriod.long,
              ),
            )
            .time(date),
        '4 du matin',
      ),
    );
  }, tags: ['icu4xUnimplemented']);

  group('date style', () {
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    testWithFormatting(
      'short',
      () => expect(
        Intl(locale: const Locale(language: 'en'))
            .dateTimeFormat(
              const DateTimeFormatOptions(
                dateFormatStyle: DateFormatStyle.short,
              ),
            )
            .ymd(date),
        '12/17/21',
      ),
    );
    testWithFormatting(
      'medium',
      () => expect(
        Intl(locale: const Locale(language: 'en'))
            .dateTimeFormat(
              const DateTimeFormatOptions(
                dateFormatStyle: DateFormatStyle.medium,
              ),
            )
            .ymd(date),
        'Dec 17, 2021',
      ),
    );
    testWithFormatting(
      'long',
      () => expect(
        Intl(locale: const Locale(language: 'en'))
            .dateTimeFormat(
              const DateTimeFormatOptions(
                dateFormatStyle: DateFormatStyle.long,
              ),
            )
            .ymd(date),
        'December 17, 2021',
      ),
    );
  });

  group('time style', () {
    final date = DateTime(2021, 12, 17, 4, 0, 0);
    final intl = Intl(locale: const Locale(language: 'en'));

    testWithFormatting(
      'short',
      () => expect(
        intl
            .dateTimeFormat(
              const DateTimeFormatOptions(
                timeFormatStyle: TimeFormatStyle.short,
              ),
            )
            .time(date),
        matches(r'^4:00\sAM$'),
      ),
    );
    testWithFormatting(
      'medium',
      () => expect(
        intl
            .dateTimeFormat(
              const DateTimeFormatOptions(
                timeFormatStyle: TimeFormatStyle.medium,
              ),
            )
            .time(date),
        matches(r'^4:00:00\sAM$'),
      ),
    );
    testWithFormatting(
      'long',
      () => expect(
        intl
            .dateTimeFormat(
              const DateTimeFormatOptions(
                timeFormatStyle: TimeFormatStyle.long,
              ),
            )
            .time(date),

        matches(r'^4:00:00\sAM GMT\+1$'),
      ),
      tags: ['icu4xUnimplemented'],
    );
  });

  group('datetime style', () {
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    final intl = Intl(locale: const Locale(language: 'en'));
    testWithFormatting(
      'medium short',
      () => expect(
        intl
            .dateTimeFormat(
              const DateTimeFormatOptions(
                timeFormatStyle: TimeFormatStyle.medium,
                dateFormatStyle: DateFormatStyle.short,
              ),
            )
            .ymdt(date),
        matches(r'^12/17/21, 4:00:42\sAM$'),
      ),
    );
  });

  group('individual options', () {
    final date = DateTime(2025, 6, 18, 10, 30, 45, 123);
    final intlEnUS = Intl(locale: const Locale(language: 'en', region: 'US'));

    group('calendar', () {
      testWithFormatting(
        'calendar - chinese',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  calendar: Calendar.chinese,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .ymd(date),
          '5/23/2025',
        ),
      );

      testWithFormatting(
        'calendar - japanese',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  calendar: Calendar.japanese,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .ymd(date),
          '6/18/7 R',
        ),
      );

      testWithFormatting(
        'calendar - islamic',
        () => expect(
          Intl(locale: const Locale(language: 'ar'))
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  calendar: Calendar.islamicCivil,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .ymd(date),
          // Dhu al-Hijjah 12, 1446 AH
          '21‏/12‏/1446 هـ', // 12/11/1446 AH
        ),
      );
    });

    group('numberingSystem', () {
      testWithFormatting(
        'numberingSystem - arab',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  numberingSystem: NumberingSystem.arab,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .ymd(DateTime(2025, 6, 18)),
          '٦/١٨/٢٥', // 18/6/25 in Arabic numerals
        ),
      );

      testWithFormatting(
        'numberingSystem - devanagari',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  numberingSystem: NumberingSystem.deva,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .ymd(DateTime(2025, 6, 18)),
          '६/१८/२५', // 18/6/25 in Devanagari numerals
        ),
      );

      testWithFormatting(
        'numberingSystem - thai',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  numberingSystem: NumberingSystem.thai,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .ymd(DateTime(2025, 6, 18)),
          '๖/๑๘/๒๕', // 18/6/25 in Thai numerals
        ),
      );
    });

    group('clockstyle', () {
      testWithFormatting(
        'clockstyle - 24-hour',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  timestyle: TimeStyle.twodigit,
                  clockstyle: ClockStyle.startZeroIs24Hour,
                ),
              )
              .time(DateTime(2025, 6, 18, 15, 30, 0)),
          '15:30',
        ),
      );

      testWithFormatting(
        'clockstyle - 12-hour, startAtZero true (0 AM)',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  timestyle: TimeStyle.twodigit,
                  clockstyle: ClockStyle.startOneIs12Hour,
                  dayPeriod: DayPeriod.short,
                ),
              )
              .time(DateTime(2025, 6, 18, 0, 30, 0)),
          '12:30 at night',
        ),
        tags: ['icu4xUnimplemented'],
      );

      testWithFormatting(
        'clockstyle - 12-hour, startAtZero false (12 AM)',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  timestyle: TimeStyle.twodigit,
                  clockstyle: ClockStyle.startOneIs12Hour,
                  dayPeriod: DayPeriod.short,
                ),
              )
              .time(DateTime(2025, 6, 18, 0, 30, 0)),
          '12:30 at night',
        ),
        tags: ['icu4xUnimplemented'],
      );
    });

    group('year, month, day, hour, minute, second', () {
      testWithFormatting(
        'year - numeric',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(timestyle: TimeStyle.numeric),
              )
              .y(date),
          '2025',
        ),
      );

      testWithFormatting(
        'month - twodigit',
        () => expect(
          intlEnUS
              .dateTimeFormat(const DateTimeFormatOptions())
              .md(DateTime(2025, 6, 18)),
          '6/18',
        ),
      );

      testWithFormatting(
        'month - narrow',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(timestyle: TimeStyle.numeric),
              )
              .md(DateTime(2025, 1, 18)), // January
          '1/18',
        ),
      );

      testWithFormatting(
        'day - twodigit',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(timestyle: TimeStyle.twodigit),
              )
              .md(DateTime(2025, 6, 8)),
          '06/08',
        ),
      );

      testWithFormatting(
        'hour - twodigit',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(timestyle: TimeStyle.twodigit),
              )
              .time(DateTime(2025, 6, 18, 7, 30, 0)),
          matches(r'7:30\sAM'),
        ),
      );

      testWithFormatting(
        'minute - twodigit',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(timestyle: TimeStyle.twodigit),
              )
              .time(DateTime(2025, 6, 18, 7, 5, 0)),
          matches(r'7:05\sAM'),
        ),
      );
    });

    group('fractionalSecondDigits', () {
      testWithFormatting(
        'fractionalSecondDigits - 1 digit',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  timestyle: TimeStyle.numeric,
                  fractionalSecondDigits: 1,
                ),
              )
              .time(DateTime(2025, 6, 18, 10, 30, 45, 123)),
          matches(r'10:30:45.1\sAM'),
        ),
      );

      testWithFormatting(
        'fractionalSecondDigits - 3 digits',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  timestyle: TimeStyle.numeric,
                  fractionalSecondDigits: 3,
                ),
              )
              .time(DateTime(2025, 6, 18, 10, 30, 45, 123)),
          matches(r'10:30:45.123\sAM'),
        ),
      );
    });

    group('formatMatcher and localeMatcher', () {
      testWithFormatting(
        'formatMatcher - basic',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  formatMatcher: FormatMatcher.basic,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .ymd(DateTime(2025, 6, 18)),
          '6/18/25',
        ),
      );

      testWithFormatting(
        'localeMatcher - lookup',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  localeMatcher: LocaleMatcher.lookup,
                  dateFormatStyle: DateFormatStyle.short,
                ),
              )
              .ymd(DateTime(2025, 6, 18)),
          '6/18/25',
        ),
      );
    });
  });

  group('combinations of options', () {
    final date = DateTime(2025, 6, 18, 10, 30, 45, 123);
    final intlEnUS = Intl(locale: const Locale(language: 'en', region: 'US'));

    group('Time Zone + Date/Time Components', () {
      testWithFormatting(
        'timeZone long + hour numeric + minute twodigit',
        () => expect(
          intlEnUS
              .dateTimeFormat(
                const DateTimeFormatOptions(timestyle: TimeStyle.numeric),
              )
              .time(
                DateTime(2025, 6, 18, 10, 30, 0),
                timeZone: const TimeZone.long(
                  name: 'America/New_York',
                  offset: '-04:00',
                ),
              ), // 10:30 AM UTC
          // This should convert to 5:30 AM New York time (UTC-4)
          matches(r'^10:30\sAM Eastern Daylight Time$'),
        ),
      );
    }, tags: ['icu4xUnimplemented']);

    group('Locale Specific Behavior', () {
      testWithFormatting(
        'French locale - long date, short time',
        () => expect(
          Intl(locale: const Locale(language: 'fr', region: 'FR'))
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  dateFormatStyle: DateFormatStyle.long,
                  timeFormatStyle: TimeFormatStyle.short,
                ),
              )
              .ymdt(date),
          // Example: 18 juin 2025 à 10:30
          matches(r'^18 juin 2025 à 10:30$'),
        ),
        tags: ['icu4xUnimplemented'],
      );

      testWithFormatting(
        'German locale - full date, medium time, 24-hour clock ECMA',
        () => expect(
          Intl(locale: const Locale(language: 'de', region: 'DE'))
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  dateFormatStyle: DateFormatStyle.full,
                  timeFormatStyle: TimeFormatStyle.medium,
                  clockstyle: ClockStyle.startZeroIs24Hour,
                ),
              )
              .ymdet(date),
          'Mittwoch, 18. Juni 2025 um 10:30:45',
        ),
        testOn: 'chrome',
      );

      testWithFormatting(
        'German locale - full date, medium time, 24-hour clock ICU4X',
        () => expect(
          Intl(locale: const Locale(language: 'de', region: 'DE'))
              .dateTimeFormat(
                const DateTimeFormatOptions(
                  dateFormatStyle: DateFormatStyle.full,
                  timeFormatStyle: TimeFormatStyle.medium,
                  clockstyle: ClockStyle.startZeroIs24Hour,
                ),
              )
              .ymdet(date),
          'Mittwoch, 18. Juni 2025, 10:30:45',
        ),
        testOn: 'vm',
      );
    });
  });
}
