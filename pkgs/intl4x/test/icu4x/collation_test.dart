// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('Does not compare in tests', () {
    final unsorted = ['Z', 'a', 'z', 'ä'];
    final collationGerman =
        Intl(locale: const Locale(language: 'de', region: 'DE')).collation();
    expect(unsorted..sort(collationGerman.compare), orderedEquals(unsorted));
  });

  testWithFormatting('Simple EN', () {
    final list = ['A', 'B', 'C'];
    final intl = Intl(locale: const Locale(language: 'en', region: 'US'));
    final collation = intl.collation();
    expect(() => list..sort(collation.compare),
        throwsA(isA<UnimplementedError>()));
  });
}
