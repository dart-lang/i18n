// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/intl4x.dart';
import 'package:intl4x/number_format.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('Some manual tests', () {
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
        final numberFormatOptions = intl.numberFormat(
            NumberFormatOptions.custom(useGrouping: Grouping.auto));
        expect(numberFormatOptions.format(1000), '1,000');
        expect(numberFormatOptions.format(10000), '10,000');
      });

      testWithFormatting('min2', () {
        final numberFormatOptions = intl.numberFormat(
            NumberFormatOptions.custom(useGrouping: Grouping.min2));
        expect(numberFormatOptions.format(1000), '1000');
        expect(numberFormatOptions.format(10000), '10,000');
      });
    });
  });
}
