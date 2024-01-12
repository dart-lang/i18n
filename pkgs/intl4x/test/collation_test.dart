// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/collation.dart';
import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test(
    'Does not compare in tests',
    () {
      final unsorted = ['Z', 'a', 'z', 'ä'];
      final collationGerman =
          Intl(locale: const Locale(language: 'de', region: 'DE')).collation();
      expect(unsorted..sort(collationGerman.compare), orderedEquals(unsorted));
    },
  );

  testWithFormatting('Simple EN', () {
    final list = ['A', 'B', 'C'];
    final intl = Intl(locale: const Locale(language: 'en', region: 'US'));
    final collation = intl.collation();
    expect(list..sort(collation.compare), orderedEquals(list));
  });

  testWithFormatting('Simple DE', () {
    final list = ['Z', 'a', 'z', 'ä'];
    final expected = ['a', 'ä', 'z', 'Z'];
    final collationGerman =
        Intl(locale: const Locale(language: 'de', region: 'DE')).collation();
    expect(list..sort(collationGerman.compare), orderedEquals(expected));
  });

  testWithFormatting('Search vs. Sort', () {
    final intl = Intl(locale: const Locale(language: 'de'));
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
