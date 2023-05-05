// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('List style options', () {
    var list = ['A', 'B', 'C'];
    var listFormat =
        Intl(ecmaPolicy: const AlwaysEcma(), locale: 'en_US').listFormat;
    testWithFormatting('long', () {
      expect(listFormat.format(list, style: ListStyle.long), 'A, B, and C');
    });
    testWithFormatting('short', () {
      expect(listFormat.format(list, style: ListStyle.short), 'A, B, & C');
    });
    testWithFormatting('narrow', () {
      expect(listFormat.format(list, style: ListStyle.narrow), 'A, B, C');
    });
  });

  group('List type options', () {
    var list = ['A', 'B', 'C'];
    var listFormat =
        Intl(ecmaPolicy: const AlwaysEcma(), locale: 'en_US').listFormat;
    testWithFormatting('long', () {
      var formatter = listFormat.format(list, type: Type.conjunction);
      expect(formatter, 'A, B, and C');
    });
    testWithFormatting('short', () {
      var formatter = listFormat.format(list, type: Type.disjunction);
      expect(formatter, 'A, B, or C');
    });
    testWithFormatting('narrow', () {
      var formatter = listFormat.format(list, type: Type.unit);
      expect(formatter, 'A, B, C');
    });
  });

  group('List style and type combinations', () {
    var list = ['A', 'B', 'C'];
    var listFormat =
        Intl(ecmaPolicy: const AlwaysEcma(), locale: 'en_US').listFormat;
    testWithFormatting('long', () {
      var formatter = listFormat.format(
        list,
        style: ListStyle.narrow,
        type: Type.conjunction,
      );
      expect(formatter, 'A, B, C');
    });
    testWithFormatting('short', () {
      var formatter = listFormat.format(
        list,
        style: ListStyle.short,
        type: Type.unit,
      );
      expect(formatter, 'A, B, C');
    });
  });
}
