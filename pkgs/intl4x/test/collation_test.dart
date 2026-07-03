// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/collation.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test('Does not compare in tests', () {
    final unsorted = ['Z', 'a', 'z', 'ä'];
    final collationGerman = Collation(locale: Locale.parse('de-DE'));
    expect(unsorted..sort(collationGerman.compare), orderedEquals(unsorted));
  });

  testWithFormatting('Simple EN', () {
    final list = ['A', 'B', 'C'];
    final collation = Collation(locale: Locale.parse('en-US'));
    expect(list..sort(collation.compare), orderedEquals(list));
  });

  testWithFormatting('Simple DE', () {
    final list = ['Z', 'a', 'z', 'ä'];
    final expected = ['a', 'ä', 'z', 'Z'];
    final collationGerman = Collation(locale: Locale.parse('de-DE'));
    expect(list..sort(collationGerman.compare), orderedEquals(expected));
  });
  testWithFormatting('Numeric', () {
    expect(
      ['0', '1', '10', '2']
        ..sort(Collation(locale: Locale.parse('en-US'), numeric: true).compare),
      orderedEquals(['0', '1', '2', '10']),
    );
  });

  testWithFormatting('Search vs. Sort', () {
    final list = ['AE', 'Ä'];

    final searchCollation = Collation(
      locale: Locale.parse('de'),
      usage: Usage.search,
    );
    expect(list..sort(searchCollation.compare), orderedEquals(list));

    final sortCollation = Collation(
      locale: Locale.parse('de'),
      usage: Usage.sort,
    );
    expect(
      list..sort(sortCollation.compare),
      orderedEquals(list.reversed),
      skip: 'This should pass, see https://github.com/tc39/ecma402/issues/256',
    );
  });
}
