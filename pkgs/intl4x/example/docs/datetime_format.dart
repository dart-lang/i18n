// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';

void main() {
  // #region datetime_format
  final timeZone = 'Europe/Paris';
  final dateTime = DateTime.parse('2024-07-01T08:50:07');
  // Showcase dot shorthand
  // ignore: omit_local_variable_types
  final DateTimeFormat formatter = .yearMonthDayTime(
    locale: Locale.parse('en'),
    length: DateTimeLength.long,
  );
  print(
    formatter.withTimeZoneLong().format(dateTime, timeZone),
  ); // July 1, 2024 at 8:50:07 AM Central European Summer Time
  // #endregion datetime_format

  final formatter2 = DateTimeFormat.month(
    locale: Locale.parse('en'),
    length: DateTimeLength.long,
  );
  print(
    formatter2.format(dateTime),
  ); // July 1, 2024 at 8:50:07 AM Central European Summer Time
}
