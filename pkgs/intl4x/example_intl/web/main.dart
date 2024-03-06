// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:intl/intl.dart';

void main() {
  num number = 300000;
  var nf = NumberFormat.currency(name: 'USD', decimalDigits: 2).format;
  querySelector('#output')?.text = 'Format $number: ${nf(number)}';
  print(nf(11.21)); // "$11.20"
  print(nf(11.22)); // "$11.20"
  print(nf(11.224)); // "$11.20"
  print(nf(11.225)); // "$11.25"s
  print(nf(11.23));
  //TODO: Add examples for formatting.
}
