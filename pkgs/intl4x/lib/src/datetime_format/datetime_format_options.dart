// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';

typedef WeekDayStyle = Style;
typedef DayPeriod = Style;
typedef EraStyle = Style;

/// DateTime formatting functionality of the browser.
class DateTimeFormatOptions {
  /// The date formatting style.
  final DateFormatStyle? dateFormatStyle;

  /// The time formatting style.
  final TimeFormatStyle? timeFormatStyle;

  final Calendar? calendar;

  /// The formatting style used for day periods - only used when the
  /// [clockstyle] parameter is true.
  final DayPeriod? dayPeriod;
  final NumberingSystem? numberingSystem;

  /// Whether to use a 12- or 24-hour style clock.
  final ClockStyle? clockstyle;
  final EraStyle? era;
  final TimeStyle? timestyle;

  /// The number of digits used to represent fractions of a second.
  final int? fractionalSecondDigits;

  /// The localized representation of the time zone name.
  final FormatMatcher formatMatcher;
  final LocaleMatcher localeMatcher;

  const DateTimeFormatOptions({
    this.dateFormatStyle,
    this.timeFormatStyle,
    this.calendar,
    this.dayPeriod,
    this.numberingSystem,
    this.clockstyle,
    this.era,
    this.timestyle,
    this.fractionalSecondDigits,
    this.formatMatcher = FormatMatcher.bestfit,
    this.localeMatcher = LocaleMatcher.bestfit,
  });

  DateTimeFormatOptions copyWith({
    DateFormatStyle? dateFormatStyle,
    TimeFormatStyle? timeFormatStyle,
    Calendar? calendar,
    DayPeriod? dayPeriod,
    NumberingSystem? numberingSystem,
    ClockStyle? clockstyle,
    WeekDayStyle? weekday,
    EraStyle? era,
    TimeStyle? timestyle,
    int? fractionalSecondDigits,
    FormatMatcher? formatMatcher,
    LocaleMatcher? localeMatcher,
  }) {
    return DateTimeFormatOptions(
      dateFormatStyle: dateFormatStyle ?? this.dateFormatStyle,
      timeFormatStyle: timeFormatStyle ?? this.timeFormatStyle,
      calendar: calendar ?? this.calendar,
      dayPeriod: dayPeriod ?? this.dayPeriod,
      numberingSystem: numberingSystem ?? this.numberingSystem,
      clockstyle: clockstyle ?? this.clockstyle,
      era: era ?? this.era,
      timestyle: timestyle ?? this.timestyle,
      fractionalSecondDigits:
          fractionalSecondDigits ?? this.fractionalSecondDigits,
      formatMatcher: formatMatcher ?? this.formatMatcher,
      localeMatcher: localeMatcher ?? this.localeMatcher,
    );
  }
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
}

enum TimeFormatStyle { full, medium, short }

enum DateFormatStyle { full, long, medium, short }

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
  tibt,
}

enum FormatMatcher {
  basic,
  bestfit('best fit');

  final String? _jsName;

  String? get jsName => _jsName ?? name;

  const FormatMatcher([this._jsName]);
}

enum TimeStyle {
  numeric,
  twodigit('2-digit');

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const TimeStyle([this._jsName]);
}

class Offset {
  final Duration duration;
  final int sign;

  const Offset.negative(this.duration) : sign = -1;

  const Offset.positive(this.duration) : sign = 1;

  int get inSeconds => duration.inSeconds * sign;
}

final class TimeZone {
  final String name;
  final TimeZoneType type;
  final Offset offset;

  final bool inferVariant;

  const TimeZone.short({required this.name, required this.offset})
    : type = TimeZoneType.short,
      inferVariant = true;

  const TimeZone.long({required this.name, required this.offset})
    : type = TimeZoneType.long,
      inferVariant = true;

  const TimeZone.shortOffset({required this.name, required this.offset})
    : type = TimeZoneType.shortOffset,
      inferVariant = true;

  const TimeZone.longOffset({required this.name, required this.offset})
    : type = TimeZoneType.longOffset,
      inferVariant = true;

  const TimeZone.shortGeneric({required this.name, required this.offset})
    : type = TimeZoneType.shortGeneric,
      inferVariant = false;

  const TimeZone.longGeneric({required this.name, required this.offset})
    : type = TimeZoneType.longGeneric,
      inferVariant = false;
}

enum TimeZoneType {
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
  longGeneric,
}
