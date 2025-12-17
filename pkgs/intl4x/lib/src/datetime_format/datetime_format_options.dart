// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

export '../options.dart' show Calendar, NumberingSystem;

/// Styles for formatting the year component of a date.
enum YearStyle {
  /// The year is formatted with an appropriate length for the locale.
  auto,

  /// The year is formatted with all digits.
  full,

  /// The year is formatted with the era (e.g., "AD").
  withEra,
}

/// Precision of time formatting.
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

/// Provides comparison operators for [TimePrecision] enum values.
extension EnumComparisonOperators on TimePrecision {
  /// Less-than operator for [TimePrecision].
  bool operator <(TimePrecision other) => index < other.index;

  /// Less-than-or-equal operator for [TimePrecision].
  bool operator <=(TimePrecision other) => index <= other.index;

  /// Greater-than operator for [TimePrecision].
  bool operator >(TimePrecision other) => index > other.index;

  /// Greater-than-or-equal operator for [TimePrecision].
  bool operator >=(TimePrecision other) => index >= other.index;
}

/// Alignment of date/time formatting.
enum DateTimeAlignment {
  /// The alignment of date time components is automatically determined.
  auto,

  /// The alignment of date time components is columnar.
  column,
}

/// Length of date/time formatting.
enum DateTimeLength {
  /// Long format, e.g. "January 1, 2020"
  long,

  /// Medium format, e.g. "Jan 1, 2020"
  medium,

  /// Short format, e.g. "1/1/20"
  short,
}

/// Types of time zone formatting.
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

/// Clock styles for hour formatting.
enum ClockStyle {
  /// Clock style from 0 to 11 (e.g., 0 AM to 11 AM).
  zeroToEleven,

  /// Clock style from 1 to 12 (e.g., 1 AM to 12 PM).
  oneToTwelve,

  /// Clock style from 0 to 23 (e.g., 0:00 to 23:00).
  zeroToTwentyThree;

  /// The extension string used in ICU locale identifiers for this clock style.
  ///
  /// The three possible values are h11, h12, and h23.
  String get hourStyleExtensionString => switch (this) {
    ClockStyle.zeroToEleven => 'h11',
    ClockStyle.oneToTwelve => 'h12',
    ClockStyle.zeroToTwentyThree => 'h23',
  };

  /// Whether this clock style represents a 12-hour clock.
  bool get is12Hour =>
      this == ClockStyle.zeroToEleven || this == ClockStyle.oneToTwelve;
}
