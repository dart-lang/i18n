// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/case_mapping.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  testWithFormatting('test name', () {
    const enUS = Locale(language: 'en', region: 'US');
    expect('İstanbul'.toLocaleLowerCase(enUS), 'i̇stanbul');
    expect('ALPHABET'.toLocaleLowerCase(enUS), 'alphabet');

    expect('\u0130'.toLocaleLowerCase(const Locale(language: 'tr')), 'i');
    expect('\u0130'.toLocaleLowerCase(enUS), isNot('i'));

    final locales = ['tr', 'TR', 'tr-TR', 'tr-u-co-search', 'tr-x-turkish']
        .map(Locale.parse);
    for (final locale in locales) {
      expect('\u0130'.toLocaleLowerCase(locale), 'i');
    }
  });
}
