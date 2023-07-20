// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/ecma_policy.dart';
import 'package:intl4x/intl4x.dart';
import 'package:intl4x/src/list_format/list_format_options.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('List style options', () {
    final list = ['A', 'B', 'C'];
    final intl = Intl(locale: const Locale(language: 'en', region: 'US'));
    testWithFormatting('long', () {
      final listFormat =
          intl.listFormat(const ListFormatOptions(style: ListStyle.long));
      expect(listFormat.format(list), 'A, B, and C');
    });
    testWithFormatting('short', () {
      final listFormat =
          intl.listFormat(const ListFormatOptions(style: ListStyle.short));
      expect(listFormat.format(list), 'A, B, & C');
    });
    testWithFormatting('narrow', () {
      final listFormat =
          intl.listFormat(const ListFormatOptions(style: ListStyle.narrow));
      expect(listFormat.format(list), 'A, B, C');
    });
  });

  group('List type options', () {
    final list = ['A', 'B', 'C'];
    final intl = Intl(locale: const Locale(language: 'en', region: 'US'));
    testWithFormatting('long', () {
      final listFormat =
          intl.listFormat(const ListFormatOptions(type: Type.conjunction));
      expect(listFormat.format(list), 'A, B, and C');
    });
    testWithFormatting('short', () {
      final listFormat =
          intl.listFormat(const ListFormatOptions(type: Type.disjunction));
      expect(listFormat.format(list), 'A, B, or C');
    });
    testWithFormatting('narrow', () {
      final listFormat =
          intl.listFormat(const ListFormatOptions(type: Type.unit));
      expect(listFormat.format(list), 'A, B, C');
    });
  });

  group('List style and type combinations', () {
    final list = ['A', 'B', 'C'];
    final intl = Intl(
        ecmaPolicy: const AlwaysEcma(),
        locale: const Locale(language: 'en', region: 'US'));
    testWithFormatting('long', () {
      final formatter = intl.listFormat(const ListFormatOptions(
          style: ListStyle.narrow, type: Type.conjunction));
      expect(formatter.format(list), 'A, B, C');
    });
    testWithFormatting('short', () {
      final formatter = intl.listFormat(
          const ListFormatOptions(style: ListStyle.short, type: Type.unit));
      expect(formatter.format(list), 'A, B, C');
    });
  });
}
