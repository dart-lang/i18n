// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('chrome')
library;

import 'package:intl4x/src/datetime_format/datetime_format_ecma.dart'
    show getTimeZone;
import 'package:test/test.dart';

const Duration kZeroOffset = Duration.zero;

const Duration kNairobiOffset = Duration(hours: 3);
const Duration kDubaiOffset = Duration(hours: 4);
const Duration kKolkataOffset = Duration(hours: 5, minutes: 30);
const Duration kTokyoOffset = Duration(hours: 9);
const Duration kPhoenixOffset = Duration(hours: -7);
const Duration kHonoluluOffset = Duration(hours: -10);

void main() {
  group('getTimeZone IANA to Duration (Standard Offsets)', () {
    test('should return zero duration for UTC/GMT IANA zones', () {
      expect(getTimeZone('UTC'), equals(kZeroOffset));
      expect(getTimeZone('GMT'), equals(kZeroOffset));
      expect(getTimeZone('Africa/Monrovia'), equals(kZeroOffset));
    });

    test('should correctly parse Europe/Paris (+01:00)', () {
      expect(getTimeZone('Europe/Paris'), isA<Duration>());
    });

    test('should correctly parse Africa/Cairo (+02:00)', () {
      expect(getTimeZone('Africa/Cairo'), isA<Duration>());
    });

    test('should correctly parse Africa/Nairobi (+03:00) - No DST', () {
      expect(getTimeZone('Africa/Nairobi'), equals(kNairobiOffset));
    });

    test('should correctly parse Asia/Dubai (+04:00) - No DST', () {
      expect(getTimeZone('Asia/Dubai'), equals(kDubaiOffset));
    });

    test('should correctly parse Asia/Kolkata (+05:30) - Half hour offset', () {
      expect(getTimeZone('Asia/Kolkata'), equals(kKolkataOffset));
    });

    test('should correctly parse Asia/Tokyo (+09:00) - No DST', () {
      expect(getTimeZone('Asia/Tokyo'), equals(kTokyoOffset));
    });

    test('should correctly parse America/New_York (-05:00)', () {
      expect(getTimeZone('America/New_York'), isA<Duration>());
    });

    test('should correctly parse America/Phoenix (-07:00) - No DST', () {
      expect(getTimeZone('America/Phoenix'), equals(kPhoenixOffset));
    });

    test('should correctly parse Pacific/Honolulu (-10:00) - No DST', () {
      expect(getTimeZone('Pacific/Honolulu'), equals(kHonoluluOffset));
    });

    test('should throw an error for an invalid/non-existent IANA string', () {
      expect(
        () => getTimeZone('Invalid/TimeZone'),
        throwsA(isA<ArgumentError>()),
      );
      expect(() => getTimeZone('iana'), throwsA(isA<ArgumentError>()));
      expect(() => getTimeZone(''), throwsA(isA<ArgumentError>()));
    });
  });
}
