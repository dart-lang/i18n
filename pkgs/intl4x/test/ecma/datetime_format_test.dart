// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  var intl = Intl(ecmaPolicy: const AlwaysEcma(), locale: 'en_US');

  testWithFormatting('fractionDigits', () {
    var formatted = intl.datetimeFormat.format(DateTime(2020, 4, 1, 15));
    expect(formatted, '4/1/2020');
  });

  testWithFormatting('complex', () {
    var formatted = intl.datetimeFormat.format(
      DateTime.utc(2012, 12, 20, 3, 0, 0, 200),
      year: Year.numeric,
      month: Month.numeric,
      day: Day.numeric,
      hour: Hour.numeric,
      minute: Minute.numeric,
      second: Second.numeric,
      hour12: false,
      timeZone: 'America/Los_Angeles',
    );
    expect(formatted, '12/19/2012, 19:00:00');
  });
}
