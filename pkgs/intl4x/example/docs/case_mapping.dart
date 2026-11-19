// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/case_mapping.dart';
import 'package:test/test.dart';

void main() {
  {
    // #region case_mapping
    final tr = Locale.parse('tr');
    final en = Locale.parse('en');

    final upper = 'TICKET';
    expect(upper.toLocaleLowerCase(en), 'ticket');
    expect(upper.toLocaleLowerCase(tr), 'tıcket');

    final lower = 'i';
    expect(lower.toLocaleUpperCase(en), 'I');
    expect(lower.toLocaleUpperCase(tr), 'İ');
    // #endregion case_mapping
  }
  {
    // #region to_locale_lower_case
    expect('İ'.toLocaleLowerCase(Locale.parse('en-US')), 'i̇');
    // #endregion to_locale_lower_case
  }
  {
    // #region to_locale_upper_case
    expect('i'.toLocaleUpperCase(Locale.parse('tr')), 'İ');
    // #endregion to_locale_upper_case
  }
  {
    // #region to_lower_case
    final caseMapping = CaseMapping(locale: Locale.parse('en-US'));
    expect(caseMapping.toLowerCase('İ'), 'i̇');
    // #endregion to_lower_case
  }
  {
    // #region to_upper_case
    final caseMapping = CaseMapping(locale: Locale.parse('tr'));
    expect(caseMapping.toUpperCase('i'), 'İ');
    // #endregion to_upper_case
  }
}
