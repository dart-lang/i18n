// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:intl4x/intl4x.dart';
import 'package:intl4x/number_format.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  final intl = Intl(locale: const Locale(language: 'en', region: 'US'));
  group('grouping', () {
    testWithFormatting('always', () {
      final numberFormatOptions = intl.numberFormat(
          NumberFormatOptions.custom(useGrouping: Grouping.always));
      expect(numberFormatOptions.format(1000), '1,000');
      expect(numberFormatOptions.format(10000), '10,000');
    });

    testWithFormatting('never', () {
      final numberFormatOptions = intl.numberFormat(
          NumberFormatOptions.custom(useGrouping: Grouping.never));
      expect(numberFormatOptions.format(1000), '1000');
      expect(numberFormatOptions.format(10000), '10000');
    });

    testWithFormatting('auto', () {
      final numberFormatOptions = intl
          .numberFormat(NumberFormatOptions.custom(useGrouping: Grouping.auto));
      expect(numberFormatOptions.format(1000), '1,000');
      expect(numberFormatOptions.format(10000), '10,000');
    });

    testWithFormatting('min2', () {
      final numberFormatOptions = intl
          .numberFormat(NumberFormatOptions.custom(useGrouping: Grouping.min2));
      expect(numberFormatOptions.format(1000), '1000');
      expect(numberFormatOptions.format(10000), '10,000');
    });
  });

  group('digits', () {
    testWithFormatting('fractionDigits', () {
      String formatter(Object number) => intl
          .numberFormat(NumberFormatOptions.custom(
            minimumIntegerDigits: 5,
            useGrouping: Grouping.never,
          ))
          .format(number);
      expect(formatter(540), '00540');
    });

    testWithFormatting('fractionDigits', () {
      String formatter(Object number) => intl
          .numberFormat(NumberFormatOptions.custom(
            digits: const Digits.withSignificantDigits(maximum: 1),
            useGrouping: Grouping.never,
          ))
          .format(number);
      expect(formatter(540), '500');
    });

    testWithFormatting('significantDigits', () {
      final numberFormatOptions = intl.numberFormat(NumberFormatOptions.custom(
        digits: const Digits.withSignificantDigits(minimum: 1, maximum: 3),
      ));

      expect(numberFormatOptions.format(3), '3');
      expect(numberFormatOptions.format(3.1), '3.1');
      expect(numberFormatOptions.format(3.12), '3.12');
      expect(numberFormatOptions.format(3.123), '3.12');
    });

    testWithFormatting('fractionDigits min', () {
      String formatter(Object number) => intl
          .numberFormat(NumberFormatOptions.custom(
            minimumIntegerDigits: 3,
            digits: const Digits.withFractionDigits(minimum: 4),
          ))
          .format(number);
      expect(formatter(4.33), '004.3300');
    });

    testWithFormatting('fractionDigits max', () {
      String formatter(Object number) => intl
          .numberFormat(NumberFormatOptions.custom(
            minimumIntegerDigits: 3,
            digits: const Digits.withFractionDigits(
              maximum: 1,
            ),
          ))
          .format(number);
      expect(formatter(4.33), '004.3');
    });

    testWithFormatting('fractionDigits min < max', () {
      String formatter(Object number) => intl
          .numberFormat(NumberFormatOptions.custom(
            minimumIntegerDigits: 3,
            digits: const Digits.withFractionDigits(
              minimum: 4,
              maximum: 6,
            ),
          ))
          .format(number);
      expect(formatter(4.33), '004.3300');
    });
  });

  testWithFormatting('RoundingMode', () {
    for (final roundingMode in RoundingMode.values) {
      final expectation = switch (roundingMode) {
        RoundingMode.ceil => [2.3, 2.3, 2.3, -2.2, -2.2, -2.2],
        RoundingMode.floor => [2.2, 2.2, 2.2, -2.3, -2.3, -2.3],
        RoundingMode.expand => [2.3, 2.3, 2.3, -2.3, -2.3, -2.3],
        RoundingMode.trunc => [2.2, 2.2, 2.2, -2.2, -2.2, -2.2],
        RoundingMode.halfCeil => [2.2, 2.3, 2.3, -2.2, -2.2, -2.3],
        RoundingMode.halfFloor => [2.2, 2.2, 2.3, -2.2, -2.3, -2.3],
        RoundingMode.halfExpand => [2.2, 2.3, 2.3, -2.2, -2.3, -2.3],
        RoundingMode.halfTrunc => [2.2, 2.2, 2.3, -2.2, -2.2, -2.3],
        RoundingMode.halfEven => [2.2, 2.2, 2.3, -2.2, -2.2, -2.3],
      }
          .map((e) => e.toString())
          .toList();
      String formatter(Object number) => intl
          .numberFormat(NumberFormatOptions.custom(
              roundingMode: roundingMode,
              digits: const Digits.withSignificantDigits(maximum: 2)))
          .format(number);
      final inputs = [2.23, 2.25, 2.28, -2.23, -2.25, -2.28];
      for (final pairs in IterableZip([inputs, expectation])) {
        final input = pairs[0];
        final expectiation = pairs[1];
        expect(
          formatter(input),
          expectiation,
          reason: 'In rounding mode ${roundingMode.name}',
        );
      }
    }
  });
  group('RoundingPriority', () {
    String formatter(Object number, Digits digits) => intl
        .numberFormat(NumberFormatOptions.custom(digits: digits))
        .format(number);
    testWithFormatting('lessPrecision', () {
      expect(
          formatter(
              1.23456,
              const Digits.withSignificantAndFractionDigits(
                roundingPriority: RoundingPriority.lessPrecision,
                maximumSignificantDigits: 3,
                maximumFractionDigits: 3,
              )),
          '1.23');
    });

    testWithFormatting('morePrecision', () {
      expect(
          formatter(
              1.23456,
              const Digits.withSignificantAndFractionDigits(
                roundingPriority: RoundingPriority.morePrecision,
                maximumSignificantDigits: 3,
                maximumFractionDigits: 3,
              )),
          '1.235');
    });
  });
}
