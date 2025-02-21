// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:intl4x/intl4x.dart';
import 'package:intl4x/plural_rules.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  testWithFormatting('en-US simple', () {
    final numberFormatOptions = Intl(
      locale: const Locale(language: 'en', region: 'US'),
    ).plural(PluralRulesOptions());

    expect(numberFormatOptions.select(0), PluralCategory.other);
    expect(numberFormatOptions.select(1), PluralCategory.one);
    expect(numberFormatOptions.select(2), PluralCategory.other);
    expect(numberFormatOptions.select(3), PluralCategory.other);
  });

  testWithFormatting('ar-EG simple', () {
    final numberFormatOptions = Intl(
      locale: const Locale(language: 'ar', region: 'EG'),
    ).plural(PluralRulesOptions());

    expect(numberFormatOptions.select(0), PluralCategory.zero);
    expect(numberFormatOptions.select(1), PluralCategory.one);
    expect(numberFormatOptions.select(2), PluralCategory.two);
    expect(numberFormatOptions.select(6), PluralCategory.few);
    expect(numberFormatOptions.select(18), PluralCategory.many);
  });

  testWithFormatting('en-US ordinal', () {
    final numberFormatOptions = Intl(
      locale: const Locale(language: 'en', region: 'US'),
    ).plural(PluralRulesOptions(type: Type.ordinal));

    expect(numberFormatOptions.select(0), PluralCategory.other);
    expect(numberFormatOptions.select(1), PluralCategory.one);
    expect(numberFormatOptions.select(2), PluralCategory.two);
    expect(numberFormatOptions.select(3), PluralCategory.few);
    expect(numberFormatOptions.select(4), PluralCategory.other);
    expect(numberFormatOptions.select(21), PluralCategory.one);
  });
}
