// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';
export '../options.dart';

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

  DisplayNamesOptions copyWith({
    Style? style,
    LanguageDisplay? languageDisplay,
    Fallback? fallback,
    LocaleMatcher? localeMatcher,
  }) {
    return DisplayNamesOptions(
      style: style ?? this.style,
      languageDisplay: languageDisplay ?? this.languageDisplay,
      fallback: fallback ?? this.fallback,
      localeMatcher: localeMatcher ?? this.localeMatcher,
    );
  }
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
