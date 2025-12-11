// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:intl4x/plural_rules.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  testWithFormatting('en-US simple', () {
    final rules = PluralRules(locale: Locale.parse('en-US'));

    expect(rules.select(0), PluralCategory.other);
    expect(rules.select(1), PluralCategory.one);
    expect(rules.select(2), PluralCategory.other);
    expect(rules.select(3), PluralCategory.other);
  });

  testWithFormatting('ar-EG simple', () {
    final rules = PluralRules(locale: Locale.parse('ar-EG'));

    expect(rules.select(0), PluralCategory.zero);
    expect(rules.select(1), PluralCategory.one);
    expect(rules.select(2), PluralCategory.two);
    expect(rules.select(6), PluralCategory.few);
    expect(rules.select(18), PluralCategory.many);
  });

  testWithFormatting('en-US ordinal', () {
    final rules = PluralRules(
      locale: Locale.parse('en-US'),
      type: PluralType.ordinal,
    );

    expect(rules.select(0), PluralCategory.other);
    expect(rules.select(1), PluralCategory.one);
    expect(rules.select(2), PluralCategory.two);
    expect(rules.select(3), PluralCategory.few);
    expect(rules.select(4), PluralCategory.other);
    expect(rules.select(21), PluralCategory.one);
  });
}
