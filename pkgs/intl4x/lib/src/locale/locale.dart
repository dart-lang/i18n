// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'locale_4x.dart' if (dart.library.js) 'locale_ecma.dart';

/// Representing a Unicode locale identifier. It is composed of the primary
/// `language` subtag for the locale, the `region` (also referred to as
/// 'country') subtag, and the script subtag.
///
/// Examples are `de-DE`, `es-419`, or `zh-Hant-TW`.
abstract class Locale {
  /// The language subtag, such as `en` for English.
  String get language;

  /// The script subtag, such as `Hant` for traditional chinese.
  String? get script;

  /// The region subtag, such as `US` for the United Status of America or `419`
  /// for Latin America.
  String? get region;

  //TODO(mosum): Add RecordUse here, as soon as it is supported on
  //const constructors

  /// Generate a language tag by joining the subtags with the [separator].
  String toLanguageTag([String separator = '-']);

  /// Parse a language tag by calling to web/ICU4X functionalities.
  static Locale parse(String s) => parseLocale(s);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Locale &&
        other.language == language &&
        other.script == script &&
        other.region == region;
  }

  @override
  int get hashCode {
    return language.hashCode ^ script.hashCode ^ region.hashCode;
  }

  @override
  String toString() => toLanguageTag();
}
