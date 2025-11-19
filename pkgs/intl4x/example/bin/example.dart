// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/number_format.dart';

void main(List<String> arguments) {
  final timeZone = 'Europe/Paris';
  final dateTime = DateTime.parse('2024-07-01T08:50:07');

  print(Locale.system);

  print(NumberFormat.compact().format(3.14));

  final formatter = DateTimeFormat.ymdt(
    locale: Locale.parse('en'),
    length: DateTimeLength.long,
  ).withTimeZoneLong();
  print(formatter.format(dateTime, timeZone));
}
