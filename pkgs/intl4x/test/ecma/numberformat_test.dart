// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/intl4x.dart';
import 'package:intl4x/number_format.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('NumberFormat options', () {
    final intl = Intl(defaultLocale: ['en_US']);
    testWithFormatting('significantDigits', () {
      String formatter(Object number) => intl.numberFormat.format(
            number,
            digits: Digits.withSignificantDigits(minimum: 1, maximum: 3),
          );
      expect(formatter(3), '3');
      expect(formatter(3.1), '3.1');
      expect(formatter(3.12), '3.12');
      expect(formatter(3.123), '3.12');
    });

    testWithFormatting('fractionDigits', () {
      String formatter(Object number) => intl.numberFormat.format(
            number,
            minimumIntegerDigits: 3,
            digits: Digits.withFractionDigits(minimum: 4),
          );
      expect(formatter(4.33), '004.3300');
    });

    testWithFormatting('percent', () {
      expect(intl.numberFormat.percent(4.33), '433%');
    });

    testWithFormatting('compact', () {
      expect(intl.numberFormat.compact(4.33), '4.3');
    });
  });
}
