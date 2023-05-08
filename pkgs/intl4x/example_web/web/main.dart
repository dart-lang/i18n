// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:intl4x/intl4x.dart';

void main() {
  num number = 300000;
  var intl = Intl(
    defaultLocale: ['en'],
    ecmaPolicy: AlwaysEcma(),
  );
  String nf(num number) => intl.numberFormat.format(
        number,
        style: CurrencyStyle(currency: 'USD'),
        digits: Digits.withFractionDigits(minimum: 0, maximum: 2),
        roundingMode: RoundingMode.halfCeil,
      );
  querySelector('#output')?.text = 'Format $number: ${nf(number)}';
  print(nf(11.21)); // "$11.20"
  print(nf(11.22)); // "$11.20"
  print(nf(11.224)); // "$11.20"
  print(nf(11.225)); // "$11.25"s
  print(nf(11.23));
}
