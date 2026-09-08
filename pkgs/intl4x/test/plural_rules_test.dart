// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:intl4x/plural_rules.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  testWithFormatting('en-US simple', () {
    final s = getRules(PluralRules(locale: Locale.parse('en-US')));

    expect(s(0), 'other');
    expect(s(1), 'one');
    expect(s(2), 'other');
    expect(s(3), 'other');
  });

  testWithFormatting('ar-EG simple', () {
    final s = getRules(PluralRules(locale: Locale.parse('ar-EG')));

    expect(s(0), 'zero');
    expect(s(1), 'one');
    expect(s(2), 'two');
    expect(s(6), 'few');
    expect(s(18), 'many');
  });

  testWithFormatting('en-US ordinal', () {
    final s = getRules(
      PluralRules(locale: Locale.parse('en-US'), type: PluralType.ordinal),
    );

    expect(s(0), 'other');
    expect(s(1), 'one');
    expect(s(2), 'two');
    expect(s(3), 'few');
    expect(s(4), 'other');
    expect(s(21), 'one');
  });

  testWithFormatting('fallback to other', () {
    final rules = PluralRules(locale: Locale.parse('ar-EG'));

    expect(rules.select(0, other: 'fallback'), 'fallback');
    expect(rules.select(1, other: 'fallback'), 'fallback');
    expect(rules.select(2, other: 'fallback'), 'fallback');
  });
}

String Function(num n) getRules(PluralRules rules) =>
    (num n) => rules.select(
      n,
      zero: 'zero',
      one: 'one',
      two: 'two',
      few: 'few',
      many: 'many',
      other: 'other',
    );
