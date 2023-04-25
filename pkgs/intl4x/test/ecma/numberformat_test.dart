// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/ecma_policy.dart';
import 'package:intl4x/intl.dart';
import 'package:intl4x/src/number_format/number_format_options.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('NumberFormat options', () {
    var intl = Intl(ecmaPolicy: AlwaysEcma(), locale: 'en_US');
    testWithFormatting('significantDigits', () {
      var formatter = intl.numberFormat.custom(
        significantDigits: SignificantDigits(minimum: 1, maximum: 3),
      );
      expect(formatter.format(3), '3');
      expect(formatter.format(3.1), '3.1');
      expect(formatter.format(3.12), '3.12');
      expect(formatter.format(3.123), '3.12');
    });

    testWithFormatting('fractionDigits', () {
      var formatter = intl.numberFormat.custom(
        minimumIntegerDigits: 3,
        fractionDigits: FractionDigits(minimum: 4),
      );
      expect(formatter.format(4.33), '004.3300');
    });
  });
}
