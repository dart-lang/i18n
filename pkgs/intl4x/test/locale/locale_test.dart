// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

void main() {
  test('Default locale is set', () {
    expect(Intl().locale.language, isNotEmpty);
  });
  test(
    'Parsing different locales',
    () {
      expect(Locale.parse('de'), const Locale(language: 'de'));
      expect(Locale.parse('de-DE'), const Locale(language: 'de', region: 'DE'));
      expect(Locale.parse('zh-Hant-TW'),
          const Locale(language: 'zh', region: 'TW', script: 'Hant'));
      expect(Locale.parse('zh-Hant'),
          const Locale(language: 'zh', script: 'Hant'));
    },
  );

  test(
    'toLanguageTag',
    () {
      expect(const Locale(language: 'de').toLanguageTag(), 'de');
      expect(
          const Locale(language: 'de', region: 'DE').toLanguageTag(), 'de-DE');
      expect(
          const Locale(
            language: 'de',
            region: 'DE',
            script: 'Hant',
          ).toLanguageTag(),
          'de-Hant-DE');
      expect(
          const Locale(
            language: 'ko',
            script: 'Kore',
            region: 'KR',
            hourCycle: HourCycle.h24,
            calendar: Calendar.gregory,
          ).toLanguageTag(),
          'ko-Kore-KR-u-ca-gregory-hc-h24');
    },
  );

  test('Minimize', () {
    expect(Locale.parse('en-Latn-US').minimize(), const Locale(language: 'en'));
  }, testOn: 'browser' //Wait for ICU4X implementation for native
      );

  test('Maximize', () {
    expect(const Locale(language: 'en').maximize(), Locale.parse('en-Latn-US'));
  }, testOn: 'browser' //Wait for ICU4X implementation for native
      );
}
