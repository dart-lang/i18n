// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  final dateTimeFormatBuilder = DateTimeFormat(locale: Locale.parse('en-US'));
  group('Basic', () {
    final dateTime = DateTime(2012, 12, 20, 3, 0, 0);
    testWithFormatting(
      'd',
      () => expect(dateTimeFormatBuilder.d().format(dateTime), '20'),
    );
    testWithFormatting(
      'm',
      () => expect(dateTimeFormatBuilder.m().format(dateTime), '12'),
    );
    testWithFormatting(
      'y',
      () => expect(dateTimeFormatBuilder.y().format(dateTime), '2012'),
    );
    testWithFormatting(
      'md',
      () => expect(dateTimeFormatBuilder.md().format(dateTime), '12/20'),
    );
    testWithFormatting(
      'ymd',
      () => expect(dateTimeFormatBuilder.ymd().format(dateTime), '12/20/2012'),
    );
    testWithFormatting(
      'ymdt',
      () => expect(
        dateTimeFormatBuilder.ymdt().format(dateTime),
        matches(r'12/20/2012[,]? 3\sAM'),
      ),
    );
    testWithFormatting(
      'ymdet',
      () => expect(
        dateTimeFormatBuilder.ymdet().format(dateTime),
        matches(r'Thu, 12/20/2012[,]? 3\sAM'),
      ),
    );
    testWithFormatting(
      'time',
      () =>
          expect(dateTimeFormatBuilder.t().format(dateTime), matches(r'3\sAM')),
    );
  });

  group('timezone ymd', () {
    final dateTime = DateTime(2021, 12, 17, 3, 0, 42);
    const timeZone = 'America/Los_Angeles';

    testWithFormatting('short', () {
      return expect(
        dateTimeFormatBuilder.ymd().withTimeZoneShort().format(
          dateTime,
          timeZone,
        ),
        matches(r'12/17/2021[,]? PST'),
      );
    });

    testWithFormatting('short with era', () {
      return expect(
        dateTimeFormatBuilder
            .ymd(withEra: true)
            .withTimeZoneShort()
            .format(dateTime, timeZone),
        matches(r'12/17/2021 AD[,]? PST'),
      );
    });

    testWithFormatting(
      'long',
      () => expect(
        dateTimeFormatBuilder.ymd().withTimeZoneLong().format(
          dateTime,
          timeZone,
        ),
        matches(r'12/17/2021[,]? Pacific Standard Time'),
      ),
    );

    testWithFormatting(
      'shortOffset',
      () => expect(
        dateTimeFormatBuilder.ymd().withTimeZoneShortOffset().format(
          dateTime,
          timeZone,
        ),
        matches(r'12/17/2021[,]? GMT-8'),
      ),
    );

    testWithFormatting(
      'longOffset',
      () => expect(
        dateTimeFormatBuilder.ymd().withTimeZoneLongOffset().format(
          dateTime,
          timeZone,
        ),
        matches(r'12/17/2021[,]? GMT-08:00'),
      ),
    );

    testWithFormatting(
      'shortGeneric',
      () => expect(
        dateTimeFormatBuilder.ymd().withTimeZoneShortGeneric().format(
          dateTime,
          timeZone,
        ),
        matches(r'12/17/2021[,]? PT'),
      ),
    );

    testWithFormatting(
      'longGeneric',
      () => expect(
        dateTimeFormatBuilder.ymd().withTimeZoneLongGeneric().format(
          dateTime,
          timeZone,
        ),
        matches(r'12/17/2021[,]? Pacific Time'),
      ),
    );

    testWithFormatting('fixed timezone', () {
      return expect(
        dateTimeFormatBuilder.ymd().withTimeZoneLongGeneric().format(
          dateTime,
          'Etc/GMT+8',
        ),
        matches(r'12/17/2021[,]? GMT-08:00'),
      );
    });

    testWithFormatting(
      'fixed timezone',
      () => expect(
        dateTimeFormatBuilder.ymd().withTimeZoneShort().format(
          dateTime,
          'Etc/GMT+8',
        ),
        matches(r'12/17/2021[,]? GMT-8'),
      ),
    );

    testWithFormatting(
      'invalid timezone',
      () => expect(
        dateTimeFormatBuilder.ymd().withTimeZoneLongGeneric().format(
          dateTime,
          'invalidTimeZoneString',
        ),
        matches(r'12/17/2021[,]? GMT+?'),
      ),
    );
  });

  group('timezone ymdt', () {
    final dateTime = DateTime(2021, 12, 17, 3, 0, 42);
    const timeZone = 'America/Los_Angeles';
    testWithFormatting(
      'short',
      () => expect(
        dateTimeFormatBuilder.ymdt().withTimeZoneShort().format(
          dateTime,
          timeZone,
        ),
        matches(r'12/17/2021[,]? 3\sAM PST'),
      ),
    );
    testWithFormatting(
      'long',
      () => expect(
        dateTimeFormatBuilder.ymdt().withTimeZoneLong().format(
          dateTime,
          timeZone,
        ),
        matches(r'12/17/2021[,]? 3\sAM Pacific Standard Time'),
      ),
    );
    testWithFormatting(
      'shortOffset',
      () => expect(
        dateTimeFormatBuilder.ymdt().withTimeZoneShortOffset().format(
          dateTime,
          timeZone,
        ),
        matches(r'12/17/2021[,]? 3\sAM GMT-8'),
      ),
    );
    testWithFormatting(
      'longOffset',
      () => expect(
        dateTimeFormatBuilder.ymdt().withTimeZoneLongOffset().format(
          dateTime,
          timeZone,
        ),
        matches(r'12/17/2021[,]? 3\sAM GMT-08:00'),
      ),
    );
    testWithFormatting(
      'shortGeneric',
      () => expect(
        dateTimeFormatBuilder.ymdt().withTimeZoneShortGeneric().format(
          dateTime,
          timeZone,
        ),
        matches(r'12/17/2021[,]? 3\sAM PT'),
      ),
    );
    testWithFormatting(
      'longGeneric',
      () => expect(
        dateTimeFormatBuilder.ymdt().withTimeZoneLongGeneric().format(
          dateTime,
          timeZone,
        ),
        matches(r'12/17/2021[,]? 3\sAM Pacific Time'),
      ),
    );
  });

  group('day period', () {
    final dateTime = DateTime(2021, 12, 17, 4, 0, 42);
    testWithFormatting(
      'short',
      () => expect(
        DateTimeFormat(
          locale: Locale.parse('en-GB'),
          options: const DateTimeFormatOptions(
            clockstyle: ClockStyle.oneToTwelve,
            dayPeriod: DayPeriod.short,
          ),
        ).t().format(dateTime),
        '4 at night',
      ),
    );

    testWithFormatting(
      'narrow',
      () => expect(
        DateTimeFormat(
          locale: Locale.parse('fr'),
          options: const DateTimeFormatOptions(
            clockstyle: ClockStyle.oneToTwelve,
            dayPeriod: DayPeriod.narrow,
          ),
        ).t().format(dateTime),
        '4 mat.',
      ),
    );

    testWithFormatting(
      'long',
      () => expect(
        DateTimeFormat(
          locale: Locale.parse('fr'),
          options: const DateTimeFormatOptions(
            clockstyle: ClockStyle.oneToTwelve,
            dayPeriod: DayPeriod.long,
          ),
        ).t().format(dateTime),
        '4 du matin',
      ),
    );
  }, tags: ['icu4xUnimplemented']);

  group('date style', () {
    final dateTime = DateTime(2021, 12, 17, 4, 0, 42);
    testWithFormatting(
      'short',
      () => expect(
        dateTimeFormatBuilder
            .ymd(dateStyle: DateFormatStyle.short)
            .format(dateTime),
        '12/17/21',
      ),
    );
    testWithFormatting(
      'medium',
      () => expect(
        dateTimeFormatBuilder
            .ymd(dateStyle: DateFormatStyle.medium)
            .format(dateTime),
        'Dec 17, 2021',
      ),
    );
    testWithFormatting(
      'long',
      () => expect(
        dateTimeFormatBuilder
            .ymd(dateStyle: DateFormatStyle.long)
            .format(dateTime),
        'December 17, 2021',
      ),
    );
  });

  group('time style', () {
    final dateTime = DateTime(2021, 12, 17, 4, 0, 0);

    testWithFormatting(
      'short',
      () => expect(
        dateTimeFormatBuilder.t(style: TimeFormatStyle.short).format(dateTime),
        matches(r'^4:00\sAM$'),
      ),
    );
    testWithFormatting(
      'medium',
      () => expect(
        dateTimeFormatBuilder.t(style: TimeFormatStyle.medium).format(dateTime),
        matches(r'^4:00:00\sAM$'),
      ),
    );
  });

  group('datetime style', () {
    final dateTime = DateTime(2021, 12, 17, 4, 0, 42);
    testWithFormatting(
      'medium short',
      () => expect(
        dateTimeFormatBuilder
            .ymdt(
              dateStyle: DateFormatStyle.short,
              timeStyle: TimeFormatStyle.medium,
            )
            .format(dateTime),
        matches(r'^12/17/21, 4:00:42\sAM$'),
      ),
    );
  });

  group('individual options', () {
    final dateTime = DateTime(2025, 6, 18, 10, 30, 45, 123);

    group('calendar', () {
      testWithFormatting(
        'calendar - chinese',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(calendar: Calendar.chinese),
          ).ymd(dateStyle: DateFormatStyle.short).format(dateTime),
          '5/23/2025',
        ),
      );

      testWithFormatting(
        'calendar - japanese',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(calendar: Calendar.japanese),
          ).ymd(dateStyle: DateFormatStyle.short).format(dateTime),
          '6/18/7 R',
        ),
      );

      testWithFormatting(
        'calendar - islamic',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('ar'),
            options: const DateTimeFormatOptions(
              calendar: Calendar.islamicCivil,
            ),
          ).ymd(dateStyle: DateFormatStyle.short).format(dateTime),
          // Dhu al-Hijjah 12, 1446 AH
          '21‏/12‏/1446 هـ', // 12/11/1446 AH
        ),
      );
    });

    group('numberingSystem', () {
      testWithFormatting(
        'numberingSystem - arab',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(
              numberingSystem: NumberingSystem.arab,
            ),
          ).ymd(dateStyle: DateFormatStyle.short).format(DateTime(2025, 6, 18)),
          '٦/١٨/٢٥', // 18/6/25 in Arabic numerals
        ),
      );

      testWithFormatting(
        'numberingSystem - devanagari',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(
              numberingSystem: NumberingSystem.deva,
            ),
          ).ymd(dateStyle: DateFormatStyle.short).format(DateTime(2025, 6, 18)),
          '६/१८/२५', // 18/6/25 in Devanagari numerals
        ),
      );

      testWithFormatting(
        'numberingSystem - devanagari in locale',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US-u-nu-deva'),
          ).ymd(dateStyle: DateFormatStyle.short).format(DateTime(2025, 6, 18)),
          '६/१८/२५', // 18/6/25 in Devanagari numerals
        ),
      );

      testWithFormatting(
        'numberingSystem - thai',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(
              numberingSystem: NumberingSystem.thai,
            ),
          ).ymd(dateStyle: DateFormatStyle.short).format(DateTime(2025, 6, 18)),
          '๖/๑๘/๒๕', // 18/6/25 in Thai numerals
        ),
      );
    });

    group('clockstyle', () {
      testWithFormatting(
        'clockstyle - 24-hour',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(
              timestyle: TimeStyle.twodigit,
              clockstyle: ClockStyle.zeroToTwentyThree,
            ),
          ).t().format(DateTime(2025, 6, 18, 15, 30, 0)),
          '15:30',
        ),
      );

      testWithFormatting(
        'clockstyle - 12-hour',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(
              timestyle: TimeStyle.twodigit,
              clockstyle: ClockStyle.zeroToEleven,
            ),
          ).t().format(DateTime(2025, 6, 18, 15, 30, 0)),
          matches(r'03:30\sPM'),
        ),
      );

      testWithFormatting(
        'clockstyle - 12-hour, startAtZero true (0 AM)',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(
              timestyle: TimeStyle.twodigit,
              clockstyle: ClockStyle.oneToTwelve,
              dayPeriod: DayPeriod.short,
            ),
          ).t().format(DateTime(2025, 6, 18, 0, 30, 0)),
          '12:30 at night',
        ),
        tags: ['icu4xUnimplemented'],
      );

      testWithFormatting(
        'clockstyle - 12-hour, startAtZero false (12 AM)',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(
              timestyle: TimeStyle.twodigit,
              clockstyle: ClockStyle.oneToTwelve,
              dayPeriod: DayPeriod.short,
            ),
          ).t().format(DateTime(2025, 6, 18, 0, 30, 0)),
          '12:30 at night',
        ),
        tags: ['icu4xUnimplemented'],
      );
    });

    group('year, month, day, hour, minute, second', () {
      testWithFormatting(
        'year - numeric',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(timestyle: TimeStyle.numeric),
          ).y().format(dateTime),
          '2025',
        ),
      );

      testWithFormatting(
        'month - twodigit',
        () => expect(
          dateTimeFormatBuilder.md().format(DateTime(2025, 6, 18)),
          '6/18',
        ),
      );

      testWithFormatting(
        'month - narrow',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(timestyle: TimeStyle.numeric),
          ).md().format(DateTime(2025, 1, 18)), // January
          '1/18',
        ),
      );

      testWithFormatting(
        'day - twodigit',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(timestyle: TimeStyle.twodigit),
          ).md().format(DateTime(2025, 6, 8)),
          '06/08',
        ),
      );

      testWithFormatting(
        'hour - twodigit',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(timestyle: TimeStyle.twodigit),
          ).t().format(DateTime(2025, 6, 18, 7, 30, 0)),
          matches(r'7:30\sAM'),
        ),
      );

      testWithFormatting(
        'minute - twodigit',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(timestyle: TimeStyle.twodigit),
          ).t().format(DateTime(2025, 6, 18, 7, 5, 0)),
          matches(r'7:05\sAM'),
        ),
      );
    });

    group('fractionalSecondDigits', () {
      testWithFormatting(
        'fractionalSecondDigits - 1 digit',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(
              timestyle: TimeStyle.numeric,
              fractionalSecondDigits: 1,
            ),
          ).t().format(DateTime(2025, 6, 18, 10, 30, 45, 123)),
          matches(r'10:30:45.1\sAM'),
        ),
      );

      testWithFormatting(
        'fractionalSecondDigits - 3 digits',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(
              timestyle: TimeStyle.numeric,
              fractionalSecondDigits: 3,
            ),
          ).t().format(DateTime(2025, 6, 18, 10, 30, 45, 123)),
          matches(r'10:30:45.123\sAM'),
        ),
      );
    });

    group('formatMatcher', () {
      testWithFormatting(
        'formatMatcher - basic',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(
              formatMatcher: FormatMatcher.basic,
            ),
          ).ymd(dateStyle: DateFormatStyle.short).format(DateTime(2025, 6, 18)),
          '6/18/25',
        ),
      );
    });
  });

  group('combinations of options', () {
    final dateTime = DateTime(2025, 6, 18, 10, 30, 45, 123);

    group('Time Zone + Date/Time Components', () {
      testWithFormatting(
        'timeZone long + hour numeric + minute twodigit',
        () => expect(
          DateTimeFormat(
            locale: Locale.parse('en-US'),
            options: const DateTimeFormatOptions(timestyle: TimeStyle.numeric),
          ).t().withTimeZoneLong().format(
            DateTime.utc(2025, 6, 18, 10, 30, 0),
            'America/New_York',
          ),
          matches(r'^10:30\sAM Eastern Daylight Time$'),
        ),
      );
    }, tags: ['icu4xUnimplemented']);

    group('Locale Specific Behavior', () {
      testWithFormatting(
        'French locale - long date, short time',
        () => expect(
          DateTimeFormat(locale: Locale.parse('fr-FR'))
              .ymdt(
                dateStyle: DateFormatStyle.long,
                timeStyle: TimeFormatStyle.short,
              )
              .format(dateTime),
          matches(r'^18 juin 2025 à 10:30$'),
        ),
      );

      testWithFormatting(
        'German locale - full date, medium time, 24-hour clock ECMA',
        () => expect(
          DateTimeFormat(
                locale: Locale.parse('de-DE'),
                options: const DateTimeFormatOptions(
                  clockstyle: ClockStyle.zeroToTwentyThree,
                ),
              )
              .ymdet(
                dateStyle: DateFormatStyle.full,
                timeStyle: TimeFormatStyle.medium,
              )
              .format(dateTime),
          'Mittwoch, 18. Juni 2025 um 10:30:45',
        ),
      );

      testWithFormatting(
        'German locale - full date, medium time, 24-hour clock ICU4X',
        () => expect(
          DateTimeFormat(
                locale: Locale.parse('de-DE'),
                options: const DateTimeFormatOptions(
                  clockstyle: ClockStyle.zeroToTwentyThree,
                ),
              )
              .ymdet(
                dateStyle: DateFormatStyle.full,
                timeStyle: TimeFormatStyle.medium,
              )
              .format(dateTime),
          'Mittwoch, 18. Juni 2025 um 10:30:45',
        ),
      );
    });
  });
}
