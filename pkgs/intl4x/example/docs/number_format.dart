// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/number_format.dart';
import 'package:test/test.dart';

void main({bool webOnly = false}) {
  {
    // #region number_format
    final numberFormat = NumberFormat(
      locale: Locale.parse('en'),
      roundingMode: RoundingMode.ceil,
      digits: const Digits.withFractionDigits(maximum: 1),
    );
    expect(numberFormat.format(3.14), '3.2');
    // #endregion number_format
  }
  {
    // #region format
    expect(
      NumberFormat(locale: Locale.parse('en')).format(123456.789),
      '123,456.789',
    );
    // #endregion format
  }
  {
    // #region custom
    expect(
      NumberFormat(
        locale: Locale.parse('de'),
        digits: const Digits.withFractionDigits(minimum: 2, maximum: 2),
      ).format(1234.567),
      '1.234,57',
    );
    // #endregion custom
  }
  if (webOnly) {
    // #region number_format_compact
    expect(
      NumberFormat.compact(locale: Locale.parse('en')).format(1234567),
      '1.2M',
    );
    // #endregion number_format_compact
  }
  if (webOnly) {
    // #region number_format_percent
    expect(NumberFormat.percent(locale: Locale.parse('en')).format(0.5), '50%');
    // #endregion number_format_percent
  }
  if (webOnly) {
    // #region number_format_currency
    expect(
      NumberFormat.currency(
        locale: Locale.parse('en-US'),
        currency: 'USD',
      ).format(123.45),
      r'$123.45',
    );
    // #endregion number_format_currency
  }
}
