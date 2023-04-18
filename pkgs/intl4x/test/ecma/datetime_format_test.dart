// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')

import 'package:intl4x/ecma_policy.dart';
import 'package:intl4x/intl.dart';
import 'package:intl4x/src/datetime_format/datetime_format_options.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('Datetime options', () {
    var intl = Intl(ecmaPolicy: AlwaysEcma(), locale: 'en_US');
    testWithFormatting('fractionDigits', () {
      var formatter = intl.datetimeFormat.custom();
      expect(formatter.format(DateTime(2020, 4, 1, 15)), '4/1/2020');
    });
  });

  testWithFormatting('complex', () {
    var formatter =
        Intl(ecmaPolicy: AlwaysEcma(), locale: 'en_US').datetimeFormat.custom(
              year: Year.numeric,
              month: Month.numeric,
              day: Day.numeric,
              hour: Hour.numeric,
              minute: Minute.numeric,
              second: Second.numeric,
              hour12: false,
              timeZone: 'America/Los_Angeles',
            );
    expect(formatter.format(DateTime.utc(2012, 12, 20, 3, 0, 0, 200)),
        '12/19/2012, 19:00:00');
  });
}
