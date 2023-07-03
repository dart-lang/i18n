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
    final intl = Intl(defaultLocale: 'en_US');

    testWithFormatting('significantDigits', () {
      final numberFormatOptions = intl.numberFormat(NumberFormatOptions.custom(
        digits: Digits.withSignificantDigits(minimum: 1, maximum: 3),
      ));

      expect(numberFormatOptions.format(3), '3');
      expect(numberFormatOptions.format(3.1), '3.1');
      expect(numberFormatOptions.format(3.12), '3.12');
      expect(numberFormatOptions.format(3.123), '3.12');
    });

    testWithFormatting('fractionDigits', () {
      String formatter(Object number) => intl
          .numberFormat(NumberFormatOptions.custom(
            minimumIntegerDigits: 3,
            digits: Digits.withFractionDigits(minimum: 4),
          ))
          .format(number);
      expect(formatter(4.33), '004.3300');
    });

    testWithFormatting('percent', () {
      expect(intl.numberFormat(NumberFormatOptions.percent()).format(4.33),
          '433%');
    });

    testWithFormatting('compact', () {
      expect(
          intl.numberFormat(NumberFormatOptions.compact()).format(4.33), '4.3');
    });
  });

  //TODO: Add more tests
}
