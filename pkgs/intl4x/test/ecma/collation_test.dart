// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/intl4x.dart';
import 'package:intl4x/src/collation/collation_options.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  testWithFormatting('Simple', () {
    final list = ['A', 'B', 'C'];
    final intl = Intl(defaultLocale: 'en_US');
    final collation = intl.collation();
    expect(list..sort(collation.compare), orderedEquals(list));
  });

  testWithFormatting('Search vs. Sort', () {
    final intl = Intl(defaultLocale: 'de');
    final list = ['AE', 'Ä'];

    final searchCollation =
        intl.collation(const CollationOptions(usage: Usage.search));
    expect(
      list..sort(searchCollation.compare),
      orderedEquals(list),
    );

    final sortCollation =
        intl.collation(const CollationOptions(usage: Usage.sort));
    expect(
      list..sort(sortCollation.compare),
      orderedEquals(list.reversed),
      skip: 'This should pass, see https://github.com/tc39/ecma402/issues/256',
    );
  });
}
