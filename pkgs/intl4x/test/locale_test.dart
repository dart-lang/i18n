// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/locale.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('firstDayOfWeek', () {
    testWithFormatting('en-US', () {
      final locale = Locale.parse('en-US');
      expect(locale.firstDayOfWeek, Weekday.sunday);
    });

    testWithFormatting('fr-FR', () {
      final locale = Locale.parse('fr-FR');
      expect(locale.firstDayOfWeek, Weekday.monday);
    });

    testWithFormatting('ar-EG', () {
      final locale = Locale.parse('ar-EG');
      expect(locale.firstDayOfWeek, Weekday.saturday);
    });
  });

  group('Weekday ISO enum', () {
    test('values', () {
      expect(Weekday.monday.isoIndex, 1);
      expect(Weekday.tuesday.isoIndex, 2);
      expect(Weekday.wednesday.isoIndex, 3);
      expect(Weekday.thursday.isoIndex, 4);
      expect(Weekday.friday.isoIndex, 5);
      expect(Weekday.saturday.isoIndex, 6);
      expect(Weekday.sunday.isoIndex, 7);
    });

    test('fromIsoIndex', () {
      expect(Weekday.fromIsoIndex(1), Weekday.monday);
      expect(Weekday.fromIsoIndex(7), Weekday.sunday);
      expect(() => Weekday.fromIsoIndex(0), throwsArgumentError);
      expect(() => Weekday.fromIsoIndex(8), throwsArgumentError);
    });
  });
}
