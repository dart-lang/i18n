// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/collation.dart';
import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('List style options', () {
    testWithFormatting('long', () {
      final list = ['A', 'B', 'C'];
      final collation = Intl(defaultLocale: ['en_US']).collation;
      expect(list..sort(collation.compare), orderedEquals(list));
    });

    testWithFormatting('long', () {
      final collation = Intl(defaultLocale: ['de']).collation;
      final list = ['AE', 'Ä'];
      expect(
        list
          ..sort(
            (a, b) => collation.compare(a, b, usage: Usage.search),
          ),
        orderedEquals(list),
      );
      expect(
        list
          ..sort(
            (a, b) => collation.compare(a, b, usage: Usage.sort),
          ),
        orderedEquals(list.reversed),
        skip:
            'This should pass, see https://github.com/tc39/ecma402/issues/256',
      );
    });
  });
}
