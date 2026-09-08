// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;

import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import '../options.dart';

Weekday getFirstDayOfWeek4X(Locale locale) {
  final weekInfo = icu.WeekInformation((locale as Locale4x).get4X);
  return switch (weekInfo.firstWeekday) {
    icu.Weekday.monday => Weekday.monday,
    icu.Weekday.tuesday => Weekday.tuesday,
    icu.Weekday.wednesday => Weekday.wednesday,
    icu.Weekday.thursday => Weekday.thursday,
    icu.Weekday.friday => Weekday.friday,
    icu.Weekday.saturday => Weekday.saturday,
    icu.Weekday.sunday => Weekday.sunday,
  };
}
