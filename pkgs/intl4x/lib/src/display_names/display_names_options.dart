// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart' show Style;
export '../options.dart' show Calendar, Style;

class DisplayNamesOptions {
  final Style style;
  final LanguageDisplay languageDisplay;
  final Fallback fallback;

  const DisplayNamesOptions({
    required this.style,
    required this.languageDisplay,
    required this.fallback,
  });

  DisplayNamesOptions copyWith({
    Style? style,
    LanguageDisplay? languageDisplay,
    Fallback? fallback,
  }) => DisplayNamesOptions(
    style: style ?? this.style,
    languageDisplay: languageDisplay ?? this.languageDisplay,
    fallback: fallback ?? this.fallback,
  );
}

enum DisplayType { calendar, currency, dateTimeField, language, region, script }

enum LanguageDisplay {
  /// Display language names in their most common form, e.g., "English (US)".
  dialect,

  /// Display language names in a more standardized form, e.g.,
  /// "American English".
  standard,
}

enum Fallback {
  /// If a display name is not found, return the code itself.
  code,

  /// If a display name is not found, return null.
  none,
}
