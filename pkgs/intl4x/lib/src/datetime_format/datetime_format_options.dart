// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum YearStyle { auto, full, withEra }

enum TimePrecision {
  hour,

  minute,

  minuteOptional,

  second,

  subsecond1,

  subsecond2,

  subsecond3,

  subsecond4,

  subsecond5,

  subsecond6,

  subsecond7,

  subsecond8,

  subsecond9,
}

enum DateTimeAlignment { auto, column }

enum DateTimeLength { long, medium, short }

enum TimeZoneType {
  /// Example: `Pacific Standard Time`
  long,

  /// Example: `PST`
  short,

  /// Example: `GMT-8`
  shortOffset,

  /// Example: `GMT-08:00`
  longOffset,

  /// Example: `PT`
  shortGeneric,

  /// Example: `Pacific Time`
  longGeneric,
}

enum ClockStyle {
  zeroToEleven,
  oneToTwelve,
  zeroToTwentyThree;

  String get hourStyleExtensionString {
    // The three possible values are h11, h12, and h23.
    return switch (this) {
      ClockStyle.zeroToEleven => 'h11',
      ClockStyle.oneToTwelve => 'h12',
      ClockStyle.zeroToTwentyThree => 'h23',
    };
  }

  bool get is12Hour =>
      this == ClockStyle.zeroToEleven || this == ClockStyle.oneToTwelve;
}
