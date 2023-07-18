// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  testWithFormatting('Basic', () {
    expect(
        Intl(defaultLocale: 'en_US')
            .datetimeFormat()
            .format(DateTime.utc(2012, 11, 20, 3, 0, 0)),
        '12/20/2012');
  });
}
