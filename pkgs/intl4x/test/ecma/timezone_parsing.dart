// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('chrome')
library;

import 'package:intl4x/src/datetime_format/datetime_format_ecma.dart'
    show offsetForTimeZone;
import 'package:test/test.dart';

const Duration zeroOffset = Duration.zero;

final DateTime julyDate = DateTime.utc(2025, 7, 15, 12);
final DateTime januaryDate = DateTime.utc(2025, 1, 15, 12);

void main() {
  group('getTimeZone IANA to Duration (Standard Offsets)', () {
    test('should return zero duration for UTC/GMT IANA zones', () {
      expect(offsetForTimeZone(julyDate, 'UTC'), equals(zeroOffset));
      expect(offsetForTimeZone(julyDate, 'GMT'), equals(zeroOffset));
      expect(
        offsetForTimeZone(julyDate, 'Africa/Monrovia'),
        equals(zeroOffset),
      );
    });

    test(
      'should correctly parse Etc/GMT+8 (-08:00) - Reversed Sign Convention',
      () => expect(
        offsetForTimeZone(julyDate, 'Etc/GMT+8'),
        equals(const Duration(hours: -8)),
      ),
    );

    test(
      'should correctly parse Africa/Nairobi (+03:00) - No DST',
      () => expect(
        offsetForTimeZone(julyDate, 'Africa/Nairobi'),
        equals(const Duration(hours: 3)),
      ),
    );

    test(
      'should correctly parse Asia/Dubai (+04:00) - No DST',
      () => expect(
        offsetForTimeZone(julyDate, 'Asia/Dubai'),
        equals(const Duration(hours: 4)),
      ),
    );

    test(
      'should correctly parse Asia/Kolkata (+05:30) - Half hour offset',
      () => expect(
        offsetForTimeZone(julyDate, 'Asia/Kolkata'),
        equals(const Duration(hours: 5, minutes: 30)),
      ),
    );

    test(
      'should correctly parse Asia/Tokyo (+09:00) - No DST',
      () => expect(
        offsetForTimeZone(julyDate, 'Asia/Tokyo'),
        equals(const Duration(hours: 9)),
      ),
    );

    test(
      'should correctly parse America/Phoenix (-07:00) - No DST',
      () => expect(
        offsetForTimeZone(julyDate, 'America/Phoenix'),
        equals(const Duration(hours: -7)),
      ),
    );

    test(
      'should correctly parse Pacific/Honolulu (-10:00) - No DST',
      () => expect(
        offsetForTimeZone(julyDate, 'Pacific/Honolulu'),
        equals(const Duration(hours: -10)),
      ),
    );
  });

  group('getTimeZone IANA to Duration (DST Offsets)', () {
    test(
      'Europe/Paris (+01:00) in Winter (Standard Time)',
      () => expect(
        offsetForTimeZone(januaryDate, 'Europe/Paris'),
        equals(const Duration(hours: 1)),
      ),
    );

    test(
      'Europe/Paris (+02:00) in Summer (Daylight Time)',
      () => expect(
        offsetForTimeZone(julyDate, 'Europe/Paris'),
        equals(const Duration(hours: 2)),
      ),
    );

    test(
      'America/New_York (-05:00) in Winter (Standard Time)',
      () => expect(
        offsetForTimeZone(januaryDate, 'America/New_York'),
        equals(const Duration(hours: -5)),
      ),
    );

    test(
      'America/New_York (-04:00) in Summer (Daylight Time)',
      () => expect(
        offsetForTimeZone(julyDate, 'America/New_York'),
        equals(const Duration(hours: -4)),
      ),
    );

    test(
      'Africa/Cairo (+02:00) in Winter (Standard Time)',
      () => expect(
        offsetForTimeZone(januaryDate, 'Africa/Cairo'),
        equals(const Duration(hours: 2)),
      ),
    );

    test(
      'Africa/Cairo (+03:00) in Summer (Daylight Time)',
      () => expect(
        offsetForTimeZone(julyDate, 'Africa/Cairo'),
        equals(const Duration(hours: 3)),
      ),
    );
  });

  group('getTimeZone IANA Error Handling', () {
    test('should throw an error for an invalid/non-existent IANA string', () {
      expect(
        () => offsetForTimeZone(julyDate, 'Invalid/TimeZone'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => offsetForTimeZone(julyDate, 'iana'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => offsetForTimeZone(julyDate, ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
