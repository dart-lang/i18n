// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';

/// Display names options for the browser.
class DisplayNamesOptions {
  final Style style;
  final LanguageDisplay languageDisplay;
  final Fallback fallback;
  final LocaleMatcher localeMatcher;

  const DisplayNamesOptions({
    this.style = Style.long,
    this.languageDisplay = LanguageDisplay.dialect,
    this.fallback = Fallback.code,
    this.localeMatcher = LocaleMatcher.bestfit,
  });
}

enum Style {
  narrow,
  short,
  long,
}

enum DisplayType {
  calendar,
  currency,
  dateTimeField,
  language,
  region,
  script,
}

enum LanguageDisplay {
  dialect,
  standard,
}

enum Fallback {
  code,
  none,
}

enum DateTimeField {
  era,
  year,
  month,
  quarter,
  weekOfYear,
  weekday,
  dayPeriod,
  day,
  hour,
  minute,
  second,
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
