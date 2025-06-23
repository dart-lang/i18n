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

  /// The formatting style used for day periods - only used when the
  /// [clockstyle] parameter is true.
  final DayPeriod? dayPeriod;
  final NumberingSystem? numberingSystem;

  /// Whether to use a 12- or 24-hour style clock.
  final ClockStyle? clockstyle;
  final WeekDayStyle? weekday;
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
    this.weekday,
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
      weekday: weekday ?? this.weekday,
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
  startZeroIs12Hour,
  startOneIs12Hour,
  startZeroIs24Hour;

  String get hourStyleExtensionString {
    // The three possible values are h11, h12, and h23.
    return switch (this) {
      ClockStyle.startZeroIs12Hour => 'h11',
      ClockStyle.startOneIs12Hour => 'h12',
      ClockStyle.startZeroIs24Hour => 'h23',
    };
  }
}

enum TimeFormatStyle { full, long, medium, short }

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

final class TimeZone {
  final String name;
  final TimeZoneType type;
  final String offset;
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
