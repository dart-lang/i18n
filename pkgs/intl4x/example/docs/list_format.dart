// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/list_format.dart';
import 'package:test/test.dart';

void main() {
  {
    // #region list_format
    expect(['A', 'B', 'C'].joinAnd(locale: Locale.parse('en')), 'A, B, and C');
    // #endregion list_format
  }
  {
    // #region join_and
    expect(['A', 'B', 'C'].joinAnd(locale: Locale.parse('en')), 'A, B, and C');
    // #endregion join_and
  }
  {
    // #region join_or
    expect(['A', 'B', 'C'].joinOr(locale: Locale.parse('en')), 'A, B, or C');
    // #endregion join_or
  }
  {
    // #region join_unit
    expect(['A', 'B', 'C'].joinUnit(locale: Locale.parse('en')), 'A, B, C');
    // #endregion join_unit
  }
  {
    // #region format
    expect(
      ListFormat(locale: Locale.parse('en')).format(['Dog', 'Cat']),
      'Dog and Cat',
    );
    // #endregion format
  }
}
