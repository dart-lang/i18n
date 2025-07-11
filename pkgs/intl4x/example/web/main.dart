// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/intl4x.dart';
import 'package:intl4x/number_format.dart';

void main() {
  String nf(num number) => Intl()
      .numberFormat(NumberFormatOptions.custom(
        style: CurrencyStyle(currency: 'USD'),
        digits: const Digits.withFractionDigits(minimum: 0, maximum: 2),
        roundingMode: RoundingMode.halfCeil,
      ))
      .format(number);
  print(nf(11.21)); // "$11.20"
  print(nf(11.22)); // "$11.20"
  print(nf(11.224)); // "$11.20"
  print(nf(11.225)); // "$11.25"s
  print(nf(11.23));
  //TODO: Add examples for formatting.
}
