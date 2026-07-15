// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/number_format.dart';

void main() {
  // #region number_format
  final numberFormat = NumberFormat(
    locale: Locale.parse('en'),
    roundingMode: RoundingMode.ceil,
    digits: const Digits.withFractionDigits(maximum: 1),
  );
  print(numberFormat.format(3.14)); // prints '3.2'
  // #endregion number_format

  // #region number_format_compact
  print(NumberFormat.compact().format(1234567));
  // #endregion number_format_compact
}
