// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('chrome')
library;

import 'package:intl4x/src/datetime_format/datetime_format_ecma.dart'
    show offsetForTimeZone;
import 'package:test/test.dart';

const Duration zeroOffset = Duration.zero;

final DateTime summerDate = DateTime.utc(2025, 7, 15, 12);
final DateTime winterDate = DateTime.utc(2025, 1, 15, 12);

void main() {
  group('getTimeZone IANA to Duration (Standard Offsets)', () {
    test('should return zero duration for UTC/GMT IANA zones', () {
      expect(offsetForTimeZone(summerDate, 'UTC'), equals(zeroOffset));
      expect(offsetForTimeZone(summerDate, 'GMT'), equals(zeroOffset));
      expect(
        offsetForTimeZone(summerDate, 'Africa/Monrovia'),
        equals(zeroOffset),
      );
    });

    test(
      'should correctly parse Africa/Nairobi (+03:00) - No DST',
      () => expect(
        offsetForTimeZone(summerDate, 'Africa/Nairobi'),
        equals(const Duration(hours: 3)),
      ),
    );

    test(
      'should correctly parse Asia/Dubai (+04:00) - No DST',
      () => expect(
        offsetForTimeZone(summerDate, 'Asia/Dubai'),
        equals(const Duration(hours: 4)),
      ),
    );

    test(
      'should correctly parse Asia/Kolkata (+05:30) - Half hour offset',
      () => expect(
        offsetForTimeZone(summerDate, 'Asia/Kolkata'),
        equals(const Duration(hours: 5, minutes: 30)),
      ),
    );

    test(
      'should correctly parse Asia/Tokyo (+09:00) - No DST',
      () => expect(
        offsetForTimeZone(summerDate, 'Asia/Tokyo'),
        equals(const Duration(hours: 9)),
      ),
    );

    test(
      'should correctly parse America/Phoenix (-07:00) - No DST',
      () => expect(
        offsetForTimeZone(summerDate, 'America/Phoenix'),
        equals(const Duration(hours: -7)),
      ),
    );

    test(
      'should correctly parse Pacific/Honolulu (-10:00) - No DST',
      () => expect(
        offsetForTimeZone(summerDate, 'Pacific/Honolulu'),
        equals(const Duration(hours: -10)),
      ),
    );
  });

  group('getTimeZone IANA to Duration (DST Offsets)', () {
    test(
      'Europe/Paris (+01:00) in Winter (Standard Time)',
      () => expect(
        offsetForTimeZone(winterDate, 'Europe/Paris'),
        equals(const Duration(hours: 1)),
      ),
    );

    test(
      'Europe/Paris (+02:00) in Summer (Daylight Time)',
      () => expect(
        offsetForTimeZone(summerDate, 'Europe/Paris'),
        equals(const Duration(hours: 2)),
      ),
    );

    test(
      'America/New_York (-05:00) in Winter (Standard Time)',
      () => expect(
        offsetForTimeZone(winterDate, 'America/New_York'),
        equals(const Duration(hours: -5)),
      ),
    );

    test(
      'America/New_York (-04:00) in Summer (Daylight Time)',
      () => expect(
        offsetForTimeZone(summerDate, 'America/New_York'),
        equals(const Duration(hours: -4)),
      ),
    );

    test(
      'Africa/Cairo (+02:00) in Winter (Standard Time)',
      () => expect(
        offsetForTimeZone(winterDate, 'Africa/Cairo'),
        equals(const Duration(hours: 2)),
      ),
    );

    test(
      'Africa/Cairo (+03:00) in Summer (Daylight Time)',
      () => expect(
        offsetForTimeZone(summerDate, 'Africa/Cairo'),
        equals(const Duration(hours: 3)),
      ),
    );
  });

  group('getTimeZone IANA Error Handling', () {
    test('should throw an error for an invalid/non-existent IANA string', () {
      expect(
        () => offsetForTimeZone(summerDate, 'Invalid/TimeZone'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => offsetForTimeZone(summerDate, 'iana'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => offsetForTimeZone(summerDate, ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
