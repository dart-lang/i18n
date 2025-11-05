// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('chrome')
library;

import 'package:intl4x/src/datetime_format/datetime_format_ecma.dart'
    show offsetForTimeZone;
import 'package:test/test.dart';

const Duration kZeroOffset = Duration.zero;

const Duration kNairobiOffset = Duration(hours: 3);
const Duration kDubaiOffset = Duration(hours: 4);
const Duration kKolkataOffset = Duration(hours: 5, minutes: 30);
const Duration kTokyoOffset = Duration(hours: 9);
const Duration kPhoenixOffset = Duration(hours: -7);
const Duration kHonoluluOffset = Duration(hours: -10);

final DateTime kSummerDate = DateTime.utc(2025, 7, 15, 12);
final DateTime kWinterDate = DateTime.utc(2025, 1, 15, 12);

const Duration kParisStandardOffset = Duration(hours: 1);
const Duration kNewYorkStandardOffset = Duration(hours: -5);

const Duration kParisDaylightOffset = Duration(hours: 2);
const Duration kNewYorkDaylightOffset = Duration(hours: -4);

void main() {
  group('getTimeZone IANA to Duration (Standard Offsets)', () {
    test('should return zero duration for UTC/GMT IANA zones', () {
      expect(offsetForTimeZone(kSummerDate, 'UTC'), equals(kZeroOffset));
      expect(offsetForTimeZone(kSummerDate, 'GMT'), equals(kZeroOffset));
      expect(
        offsetForTimeZone(kSummerDate, 'Africa/Monrovia'),
        equals(kZeroOffset),
      );
    });

    test(
      'should correctly parse Africa/Nairobi (+03:00) - No DST',
      () => expect(
        offsetForTimeZone(kSummerDate, 'Africa/Nairobi'),
        equals(kNairobiOffset),
      ),
    );

    test(
      'should correctly parse Asia/Dubai (+04:00) - No DST',
      () => expect(
        offsetForTimeZone(kSummerDate, 'Asia/Dubai'),
        equals(kDubaiOffset),
      ),
    );

    test(
      'should correctly parse Asia/Kolkata (+05:30) - Half hour offset',
      () => expect(
        offsetForTimeZone(kSummerDate, 'Asia/Kolkata'),
        equals(kKolkataOffset),
      ),
    );

    test(
      'should correctly parse Asia/Tokyo (+09:00) - No DST',
      () => expect(
        offsetForTimeZone(kSummerDate, 'Asia/Tokyo'),
        equals(kTokyoOffset),
      ),
    );

    test(
      'should correctly parse America/Phoenix (-07:00) - No DST',
      () => expect(
        offsetForTimeZone(kSummerDate, 'America/Phoenix'),
        equals(kPhoenixOffset),
      ),
    );

    test(
      'should correctly parse Pacific/Honolulu (-10:00) - No DST',
      () => expect(
        offsetForTimeZone(kSummerDate, 'Pacific/Honolulu'),
        equals(kHonoluluOffset),
      ),
    );
  });

  group('getTimeZone IANA to Duration (DST Offsets)', () {
    test(
      'Europe/Paris (+01:00) in Winter (Standard Time)',
      () => expect(
        offsetForTimeZone(kWinterDate, 'Europe/Paris'),
        equals(kParisStandardOffset),
      ),
    );

    test(
      'Europe/Paris (+02:00) in Summer (Daylight Time)',
      () => expect(
        offsetForTimeZone(kSummerDate, 'Europe/Paris'),
        equals(kParisDaylightOffset),
      ),
    );

    test(
      'America/New_York (-05:00) in Winter (Standard Time)',
      () => expect(
        offsetForTimeZone(kWinterDate, 'America/New_York'),
        equals(kNewYorkStandardOffset),
      ),
    );

    test(
      'America/New_York (-04:00) in Summer (Daylight Time)',
      () => expect(
        offsetForTimeZone(kSummerDate, 'America/New_York'),
        equals(kNewYorkDaylightOffset),
      ),
    );

    test(
      'Africa/Cairo (+02:00) in Winter (Standard Time)',
      () => expect(
        offsetForTimeZone(kWinterDate, 'Africa/Cairo'),
        equals(const Duration(hours: 2)),
      ),
    );

    test(
      'Africa/Cairo (+03:00) in Summer (Daylight Time)',
      () => expect(
        offsetForTimeZone(kSummerDate, 'Africa/Cairo'),
        equals(const Duration(hours: 3)),
      ),
    );
  });

  group('getTimeZone IANA Error Handling', () {
    test('should throw an error for an invalid/non-existent IANA string', () {
      expect(
        () => offsetForTimeZone(kSummerDate, 'Invalid/TimeZone'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => offsetForTimeZone(kSummerDate, 'iana'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => offsetForTimeZone(kSummerDate, ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
