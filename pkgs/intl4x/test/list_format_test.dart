// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/intl4x.dart';
import 'package:intl4x/list_format.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  final list = ['A', 'B', 'C'];
  final enUS = Locale.parse('en-US');
  final intl = Intl(locale: enUS);
  group('List style options', () {
    testWithFormatting('long', () {
      final listFormat = intl.listFormat(
        const ListFormatOptions(style: ListStyle.long),
      );
      expect(listFormat.format(list), 'A, B, and C');
    });
    testWithFormatting('short', () {
      final listFormat = intl.listFormat(
        const ListFormatOptions(style: ListStyle.short),
      );
      expect(listFormat.format(list), 'A, B, & C');
    });
    testWithFormatting('narrow', () {
      final listFormat = intl.listFormat(
        const ListFormatOptions(style: ListStyle.narrow),
      );
      expect(listFormat.format(list), 'A, B, C');
    });
  });

  group('List type options', () {
    testWithFormatting('long', () {
      final listFormat = intl.listFormat(
        const ListFormatOptions(type: Type.and),
      );
      expect(listFormat.format(list), 'A, B, and C');
    });
    testWithFormatting('short', () {
      final listFormat = intl.listFormat(
        const ListFormatOptions(type: Type.or),
      );
      expect(listFormat.format(list), 'A, B, or C');
    });
    testWithFormatting('narrow', () {
      final listFormat = intl.listFormat(
        const ListFormatOptions(type: Type.unit),
      );
      expect(listFormat.format(list), 'A, B, C');
    });
  });

  group('List style and type combinations', () {
    testWithFormatting('long', () {
      final formatter = intl.listFormat(
        const ListFormatOptions(style: ListStyle.narrow, type: Type.and),
      );
      expect(formatter.format(list), 'A, B, C');
    });
    testWithFormatting('short', () {
      final formatter = intl.listFormat(
        const ListFormatOptions(style: ListStyle.short, type: Type.unit),
      );
      expect(formatter.format(list), 'A, B, C');
    });
  });

  testWithFormatting('extension', () {
    expect(list.joinAnd(locale: enUS), 'A, B, and C');
    expect(list.joinOr(locale: enUS), 'A, B, or C');
    expect(list.joinUnit(locale: enUS), 'A, B, C');
  });
}
