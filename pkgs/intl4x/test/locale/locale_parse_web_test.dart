// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

void main() {
  test('Parsing different locales', () {
    expect(Locale.parse('de'), const Locale(language: 'de'));
    expect(Locale.parse('de-DE'), const Locale(language: 'de', region: 'DE'));
    expect(Locale.parse('zh-Hant-TW'),
        const Locale(language: 'zh', region: 'TW', variant: 'Hant'));
    expect(
        Locale.parse('zh-Hant'), const Locale(language: 'zh', variant: 'Hant'));
  });
}
