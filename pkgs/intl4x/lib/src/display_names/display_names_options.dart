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
}

/// The types of display names that can be requested.
enum DisplayType { calendar, currency, dateTimeField, language, region, script }

/// How to display language names.
enum LanguageDisplay {
  /// Display language names in their most common form, e.g., "English (US)".
  dialect,

  /// Display language names in a more standardized form, e.g.,
  /// "American English".
  standard,
}

/// What to do if a display name is not found.
enum Fallback {
  /// If a display name is not found, return the code itself.
  code,

  /// If a display name is not found, return null.
  none,
}
