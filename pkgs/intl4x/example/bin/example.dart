// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/intl4x.dart';

void main(List<String> arguments) {
  const timeZone = TimeZone(name: 'Europe/Paris', offset: Duration(hours: 2));
  final dateTime = DateTime.parse('2024-07-01T08:50:07Z');

  print(Intl().locale.toString());

  print(Intl().dateTimeFormat().d().format(DateTime.now()));

  ZonedFormatter withTimeZoneLong = Intl(locale: Locale.parse('en'))
      .dateTimeFormat()
      .ymdt(dateStyle: DateFormatStyle.full, timeStyle: TimeFormatStyle.short)
      .withTimeZoneLong();
  print(withTimeZoneLong.format(dateTime, timeZone));
}
