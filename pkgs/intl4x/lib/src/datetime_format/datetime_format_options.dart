// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

export '../options.dart' show Calendar, NumberingSystem;

enum YearStyle {
  /// The year is formatted with an appropriate length for the locale.
  auto,

  /// The year is formatted with all digits.
  full,

  /// The year is formatted with the era (e.g., "AD").
  withEra,
}

enum TimePrecision {
  /// Hour precision.
  hour,

  /// Minute precision.
  minute,

  /// Minute precision, with optional seconds if they are zero.
  minuteOptional,

  /// Second precision.
  second,

  /// First subsecond digit precision.
  subsecond1,

  /// Second subsecond digit precision.
  subsecond2,

  /// Third subsecond digit precision.
  subsecond3,
}

extension EnumComparisonOperators on TimePrecision {
  bool operator <(TimePrecision other) => index < other.index;

  bool operator <=(TimePrecision other) => index <= other.index;

  bool operator >(TimePrecision other) => index > other.index;

  bool operator >=(TimePrecision other) => index >= other.index;
}

enum DateTimeAlignment {
  /// The alignment of date time components is automatically determined.
  auto,

  /// The alignment of date time components is columnar.
  column,
}

enum DateTimeLength {
  /// Long format, e.g. "January 1, 2020"
  long,

  /// Medium format, e.g. "Jan 1, 2020"
  medium,

  /// Short format, e.g. "1/1/20"
  short,
}

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
  /// Clock style from 0 to 11 (e.g., 0 AM to 11 AM).
  zeroToEleven,

  /// Clock style from 1 to 12 (e.g., 1 AM to 12 PM).
  oneToTwelve,

  /// Clock style from 0 to 23 (e.g., 0:00 to 23:00).
  zeroToTwentyThree;

  // The three possible values are h11, h12, and h23.
  String get hourStyleExtensionString => switch (this) {
    ClockStyle.zeroToEleven => 'h11',
    ClockStyle.oneToTwelve => 'h12',
    ClockStyle.zeroToTwentyThree => 'h23',
  };

  bool get is12Hour =>
      this == ClockStyle.zeroToEleven || this == ClockStyle.oneToTwelve;
}
