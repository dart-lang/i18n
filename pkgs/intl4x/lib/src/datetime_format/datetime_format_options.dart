// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';

typedef WeekDayStyle = Style;
typedef DayPeriod = Style;
typedef EraStyle = Style;
typedef DateFormatStyle = TimeFormatStyle;

/// DateTime formatting functionality of the browser.
class DateTimeFormatOptions {
  /// The date formatting style.
  final DateFormatStyle? dateFormatStyle;

  /// The time formatting style.
  final TimeFormatStyle? timeFormatStyle;

  final Calendar? calendar;

  /// The formatting style used for day periods - only used when the [clockstyle]
  /// parameter is true.
  final DayPeriod? dayPeriod;
  final NumberingSystem? numberingSystem;
  final String? timeZone;

  /// Whether to use a 12- or 24-hour style clock.
  final ClockStyle? clockstyle;
  final WeekDayStyle? weekday;
  final EraStyle? era;
  final TimeStyle? year;
  final MonthStyle? month;
  final TimeStyle? day;
  final TimeStyle? hour;
  final TimeStyle? minute;
  final TimeStyle? second;

  /// The number of digits used to represent fractions of a second.
  final int? fractionalSecondDigits;

  /// The localized representation of the time zone name.
  final TimeZoneName? timeZoneName;
  final FormatMatcher formatMatcher;
  final LocaleMatcher localeMatcher;

  const DateTimeFormatOptions({
    this.dateFormatStyle,
    this.timeFormatStyle,
    this.calendar,
    this.dayPeriod,
    this.numberingSystem,
    this.timeZone,
    this.clockstyle,
    this.weekday,
    this.era,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.fractionalSecondDigits,
    this.timeZoneName,
    this.formatMatcher = FormatMatcher.bestfit,
    this.localeMatcher = LocaleMatcher.bestfit,
  });
}

class ClockStyle {
  final bool is12Hour;
  final bool? startAtZero;

  const ClockStyle({required this.is12Hour, this.startAtZero});
}

enum TimeFormatStyle {
  full,
  long,
  medium,
  short,
}

enum NumberingSystem {
  arab,
  arabext,
  bali,
  beng,
  deva,
  fullwide,
  gujr,
  guru,
  hanidec,
  khmr,
  knda,
  laoo,
  latn,
  limb,
  mlym,
  mong,
  mymr,
  orya,
  tamldec,
  telu,
  thai,
  tibt;
}

enum HourCycle {
  h11,
  h12,
  h23,
  h24;
}

enum FormatMatcher {
  basic,
  bestfit('best fit');

  final String? _jsName;

  String? get jsName => _jsName ?? name;

  const FormatMatcher([this._jsName]);
}

enum MonthStyle {
  numeric,
  twodigit('2-digit'),
  long,
  short,
  narrow;

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const MonthStyle([this._jsName]);
}

enum TimeStyle {
  numeric,
  twodigit('2-digit');

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const TimeStyle([this._jsName]);
}

enum TimeZoneName {
  /// Example: `Pacific Standard Time`
  long,

  /// Example: `PST`
  short,

  /// Example: `GMT-8`
  shortOffset,

  /// Example: `GMT-0800`
  longOffset,

  /// Example: `PT`
  shortGeneric,

  /// Example: `Pacific Time`
  longGeneric;
}
