// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/case_mapping.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  testWithFormatting('test name', () {
    final enUS = Locale.parse('en-US');
    final trTR = Locale.parse('tr-TR');
    final ltLT = Locale.parse('lt-LT');

    expect('İstanbul'.toLocaleLowerCase(enUS), 'i̇stanbul');
    expect('İstanbul'.toLocaleLowerCase(trTR), 'istanbul');
    expect('ALPHABET'.toLocaleLowerCase(enUS), 'alphabet');

    expect('\u0130'.toLocaleLowerCase(Locale.parse('tr')), 'i');
    expect('\u0130'.toLocaleLowerCase(enUS), isNot('i'));

    final locales = [
      'tr',
      'TR',
      'tr-TR',
      'tr-u-co-search',
      'tr-x-turkish',
    ].map(Locale.parse);
    for (final locale in locales) {
      expect('\u0130'.toLocaleLowerCase(locale), 'i');
    }

    // --- Lithuanian Testing ---
    // Here, 'I' should lowercase to 'i' and 'i' should uppercase to 'I'.
    // The dotless 'i' (U+0131) and dotted 'I' (U+0130) are not typically used
    // in standard Lithuanian orthography in the same way as Turkish.
    // So, we expect standard Unicode casing behavior.

    expect('Lietuva'.toLocaleLowerCase(ltLT), 'lietuva');
    expect('lietuva'.toLocaleUpperCase(ltLT), 'LIETUVA');

    // Test a common character that might have locale-specific casing rules
    // in other languages but should be standard in Lithuanian.
    expect('Ė'.toLocaleLowerCase(ltLT), 'ė'); // Ė (U+0116) to ė (U+0117)
    expect('ė'.toLocaleUpperCase(ltLT), 'Ė');

    // Ensure that Turkish-specific behavior does NOT apply to Lithuanian
    expect(
      '\u0130'.toLocaleLowerCase(ltLT),
      '\u0130'.toLocaleLowerCase(enUS),
    ); // Dotted I should behave like in English
    expect('I'.toLocaleLowerCase(ltLT), 'i'); // Regular I to i
    expect('i'.toLocaleUpperCase(ltLT), 'I'); // Regular i to I
  });
}
