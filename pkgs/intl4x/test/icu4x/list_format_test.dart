// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'package:intl4x/intl4x.dart';
import 'package:intl4x/list_format.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  final list = ['A', 'B', 'C'];
  test('Does not compare in tests', () {
    final locale = const Locale(language: 'de', region: 'DE');
    final listFormatGerman = Intl(locale: locale)
        .listFormat(const ListFormatOptions(style: ListStyle.long));
    expect(listFormatGerman.format(list), '${list.join(', ')}//$locale');
  });

  testWithFormatting('long', () {
    final intl = Intl(locale: const Locale(language: 'en', region: 'US'));
    final listFormat =
        intl.listFormat(const ListFormatOptions(style: ListStyle.long));
    expect(() => listFormat.format(list), throwsA(isA<UnimplementedError>()));
  });
}
