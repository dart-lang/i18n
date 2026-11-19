// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/collation.dart';
import 'package:test/test.dart';

void main() {
  {
    // #region collation
    final collation = Collation(locale: Locale.parse('de'));
    final list = ['a', 'b', 'ä'];
    list.sort(collation.compare);
    expect(list, ['a', 'ä', 'b']);
    // #endregion collation
  }
  {
    // #region compare_locale
    expect('a'.compareLocale('b', locale: Locale.parse('en')), lessThan(0));
    expect('ä'.compareLocale('z', locale: Locale.parse('de')), lessThan(0));
    expect('ä'.compareLocale('z', locale: Locale.parse('sv')), greaterThan(0));
    // #endregion compare_locale
  }
}
