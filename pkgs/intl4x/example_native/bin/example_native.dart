// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/intl4x.dart';

void main(List<String> arguments) {
  const timeZone = TimeZone.long(
    name: 'Europe/Paris',
    offset: Duration(hours: 2),
  );
  print(Intl().locale.toString());
  print(Intl().dateTimeFormat().time(DateTime.now(), timeZone: timeZone));
}
