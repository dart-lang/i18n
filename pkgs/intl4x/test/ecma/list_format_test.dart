// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/ecma_policy.dart';
import 'package:intl4x/intl.dart';
import 'package:intl4x/src/list_format/list_format_options.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('List style options', () {
    var list = ['A', 'B', 'C'];
    var listFormat = Intl(ecmaPolicy: AlwaysEcma(), locale: 'en_US').listFormat;
    testWithFormatting('long', () {
      var formatter = listFormat.custom(style: Style.long);
      expect(formatter.format(list), 'A, B, and C');
    });
    testWithFormatting('short', () {
      var formatter = listFormat.custom(style: Style.short);
      expect(formatter.format(list), 'A, B, & C');
    });
    testWithFormatting('narrow', () {
      var formatter = listFormat.custom(style: Style.narrow);
      expect(formatter.format(list), 'A, B, C');
    });
  });

  group('List type options', () {
    var list = ['A', 'B', 'C'];
    var listFormat = Intl(ecmaPolicy: AlwaysEcma(), locale: 'en_US').listFormat;
    testWithFormatting('long', () {
      var formatter = listFormat.custom(type: Type.conjunction);
      expect(formatter.format(list), 'A, B, and C');
    });
    testWithFormatting('short', () {
      var formatter = listFormat.custom(type: Type.disjunction);
      expect(formatter.format(list), 'A, B, or C');
    });
    testWithFormatting('narrow', () {
      var formatter = listFormat.custom(type: Type.unit);
      expect(formatter.format(list), 'A, B, C');
    });
  });

  group('List style and type combinations', () {
    var list = ['A', 'B', 'C'];
    var listFormat = Intl(ecmaPolicy: AlwaysEcma(), locale: 'en_US').listFormat;
    testWithFormatting('long', () {
      var formatter = listFormat.custom(
        style: Style.narrow,
        type: Type.conjunction,
      );
      expect(formatter.format(list), 'A, B, C');
    });
    testWithFormatting('short', () {
      var formatter = listFormat.custom(
        style: Style.short,
        type: Type.unit,
      );
      expect(formatter.format(list), 'A, B, C');
    });
  });
}
