// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/case_mapping.dart';

void main() {
  // #region case_mapping
  final tr = Locale.parse('tr');
  final en = Locale.parse('en');

  final upper = 'TICKET';
  print(upper.toLocaleLowerCase(en)); // ticket
  print(upper.toLocaleLowerCase(tr)); // tıcket

  final lower = 'i';
  print(lower.toLocaleUpperCase(en)); // I
  print(lower.toLocaleUpperCase(tr)); // İ
  // #endregion case_mapping
}
