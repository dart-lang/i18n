// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:intl4x/intl4x.dart';

void main() {
  num number = 300000;
  var intl = Intl(
    locale: 'en',
    ecmaPolicy: AlwaysEcma(),
  );
  var nf = intl.numberFormat.custom(
    style: CurrencyStyle(currency: 'USD'),
    digits: Digits.withFractionDigits(minimum: 0, maximum: 2),
    // roundingIncrement: 5,
    roundingMode: RoundingMode.halfCeil,
  );
  querySelector('#output')?.text = 'Format $number: ${nf.formatImpl(number)}';
  print(nf.formatImpl(11.21)); // "$11.20"
  print(nf.formatImpl(11.22)); // "$11.20"
  print(nf.formatImpl(11.224)); // "$11.20"
  print(nf.formatImpl(11.225)); // "$11.25"s
  print(nf.formatImpl(11.23));
}
