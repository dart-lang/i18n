// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';

/// Display names options for the browser.
class DisplayNamesOptions {
  final DisplayType type;
  final Style style;
  final LanguageDisplay languageDisplay;
  final Fallback fallback;
  final LocaleMatcher localeMatcher;

  DisplayNamesOptions({
    required this.type,
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
