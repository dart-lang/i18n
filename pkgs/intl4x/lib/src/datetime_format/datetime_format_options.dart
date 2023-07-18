// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';

typedef WeekDayRepresentation = Style;
typedef DayPeriod = Style;
typedef EraRepresentation = Style;
typedef DateStyle = TimeStyle;

/// datetime formatting functionality of the browser.
class DatetimeFormatOptions {
  final DateStyle? dateStyle;
  final TimeStyle? timeStyle;
  final Calendar? calendar;
  final DayPeriod? dayPeriod;
  final NumberingSystem? numberingSystem;
  final String? timeZone;
  final bool? hour12;
  final HourCycle? hourCycle;
  final WeekDayRepresentation? weekday;
  final EraRepresentation? era;
  final TimeRepresentation? year;
  final MonthRepresentation? month;
  final TimeRepresentation? day;
  final TimeRepresentation? hour;
  final TimeRepresentation? minute;
  final TimeRepresentation? second;
  final int? fractionalSecondDigits;
  final TimeZoneName? timeZoneName;
  final FormatMatcher formatMatcher;
  final LocaleMatcher localeMatcher;

  const DatetimeFormatOptions({
    this.dateStyle,
    this.timeStyle,
    this.calendar,
    this.dayPeriod,
    this.numberingSystem,
    this.timeZone,
    this.hour12,
    this.hourCycle,
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

enum TimeStyle {
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

enum MonthRepresentation {
  numeric,
  twodigit('2-digit'),
  long,
  short,
  narrow;

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const MonthRepresentation([this._jsName]);
}

enum TimeRepresentation {
  numeric,
  twodigit('2-digit');

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const TimeRepresentation([this._jsName]);
}

enum TimeZoneName {
  long,
  short,
  shortOffset,
  longOffset,
  shortGeneric,
  longGeneric;
}
