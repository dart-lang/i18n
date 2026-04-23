// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  test('Test currencyFullName with ¤¤¤ pattern', () {
    var f = NumberFormat.currency(
      locale: 'en_US',
      fullName: 'US Dollars',
      customPattern: '¤¤¤#,##0.00',
    );
    expect(f.format(1234.56), 'US Dollars1,234.56');

    var f2 = NumberFormat.currency(
      locale: 'en_US',
      fullName: 'Euros',
      customPattern: '#,##0.00 ¤¤¤',
    );
    expect(f2.format(1234.56), '1,234.56 Euros');
  });

  test('Test currencyFullName lookup from data', () {
    // English
    var fEn = NumberFormat.currency(
      locale: 'en',
      name: 'USD',
      customPattern: '¤¤¤ #,##0.00',
    );
    expect(fEn.format(1234.56), 'US Dollar 1,234.56');

    // Spanish
    var fEs = NumberFormat.currency(
      locale: 'es',
      name: 'EUR',
      customPattern: '#,##0.00 ¤¤¤',
    );
    expect(fEs.format(1234.56), '1.234,56 euro');

    // Hindi
    var fHi = NumberFormat.currency(
      locale: 'hi',
      name: 'INR',
      customPattern: '¤¤¤ #,##,##0.00',
    );
    expect(fHi.format(1234.56), 'भारतीय रुपया 1,234.56');
  });
}
