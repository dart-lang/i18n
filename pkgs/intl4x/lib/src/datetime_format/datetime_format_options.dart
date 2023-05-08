// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum DateStyle {
  full,
  long,
  medium,
  short;
}

enum TimeStyle {
  full,
  long,
  medium,
  short;
}

enum Calendar {
  buddhist,
  chinese,
  coptic,
  dangi,
  ethioaa,
  ethiopic,
  gregory,
  hebrew,
  indian,
  islamic,
  islamicUmalqura('islamic-umalqura'),
  islamicTbla('islamic-tbla'),
  islamicCivil('islamic-civil'),
  islamicRgsa('islamic-rgsa'),
  iso8601,
  japanese,
  persian,
  roc;

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Calendar([this._jsName]);
}

enum DayPeriod {
  narrow,
  short,
  long;
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
  tib;
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

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const FormatMatcher([this._jsName]);
}

enum Weekday {
  long,
  short,
  narrow;
}

enum Era {
  long,
  short,
  narrow;
}

enum Year {
  numeric,
  twoDigit('2-digit');

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Year([this._jsName]);
}

enum Month {
  numeric,
  twoDigit('2-digit'),
  long,
  short,
  narrow;

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Month([this._jsName]);
}

enum Day {
  numeric,
  twoDigit('2-digit');

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Day([this._jsName]);
}

enum Hour {
  numeric,
  twoDigit('2-digit');

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Hour([this._jsName]);
}

enum Minute {
  numeric,
  twoDigit('2-digit');

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Minute([this._jsName]);
}

enum Second {
  numeric,
  twoDigit('2-digit');

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Second([this._jsName]);
}

enum TimeZoneName {
  long,
  short,
  shortOffset,
  longOffset,
  shortGeneric,
  longGeneric;
}
