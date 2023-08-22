// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'locale_native.dart' if (dart.library.js) 'locale_browser.dart';

/// Representing a Unicode locale identifier. It is composed of the primary
/// `language` subtag for the locale, the `region` (also referred to as
/// 'country') subtag, and the script subtag.
///
/// Examples are `de-DE`, `es-419`, or `zh-Hant-TW`.
class Locale {
  /// The language subtag, such as `en` for English.
  final String language;

  /// The script subtag, such as `Hant` for traditional chinese.
  final String script;

  /// The region subtag, such as `US` for the United Status of America or `419`
  /// for Latin America.
  final String region;

  const Locale({
    required this.language,
    this.region = '',
    this.script = '',
  });

  /// Generate a language tag by joining the subtags with the [separator].
  String toLanguageTag([String separator = '-']) {
    return [
      language,
      if (script.isNotEmpty) script,
      if (region.isNotEmpty) region,
    ].join(separator);
  }

  /// Parse a language tag by calling to web/ICU4X functionalities.
  static Locale parse(String s) => parseLocale(s);

  @override
  bool operator ==(covariant Locale other) {
    if (identical(this, other)) return true;

    return other.language == language &&
        other.script == script &&
        other.region == region;
  }

  @override
  int get hashCode => language.hashCode ^ script.hashCode ^ region.hashCode;
}

// TODO: add all locales which are supported by ICU4X / Browsers
const List<Locale> allLocales = [
  Locale(language: 'de', region: 'DE'),
  Locale(language: 'en', region: 'US'),
  Locale(language: 'zh', script: 'Hant'),
];