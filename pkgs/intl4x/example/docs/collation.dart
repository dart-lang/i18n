// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/collation.dart';

void main() {
  // #region collation
  final collation = Collation(locale: Locale.parse('de'));
  final list = ['a', 'ä', 'b'];
  list.sort(collation.compare);
  print(list); // Prints [a, b, ä]
  // #endregion collation
}
