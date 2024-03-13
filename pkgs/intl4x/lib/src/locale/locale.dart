// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../collation/collation_options.dart';
import '../datetime_format/datetime_format_options.dart';
import 'locale_native.dart' if (dart.library.js) 'locale_ecma.dart';

/// Representing a Unicode locale identifier. It is composed of the primary
/// `language` subtag for the locale, the `region` (also referred to as
/// 'country') subtag, and the script subtag.
///
/// Examples are `de-DE`, `es-419`, or `zh-Hant-TW`.
class Locale {
  /// The language subtag, such as `en` for English.
  final String language;

  /// The script subtag, such as `Hant` for traditional chinese.
  final String? script;

  /// The region subtag, such as `US` for the United Status of America or `419`
  /// for Latin America.
  final String? region;

  final Calendar? calendar;
  final CaseFirst? caseFirst;
  final String? collation;
  final HourCycle? hourCycle;
  final String? numberingSystem;
  final bool? numeric;

  //TODO(mosum): Add ResourceIdentifier here, as soon as it is supported on
  //const constructors
  const Locale({
    required this.language,
    this.region,
    this.script,
    this.calendar,
    this.caseFirst,
    this.collation,
    this.hourCycle,
    this.numberingSystem,
    this.numeric,
  });

  /// Generate a language tag by joining the subtags with the [separator].
  String toLanguageTag([String separator = '-']) =>
      toLanguageTagImpl(this, separator);

  /// Try to remove tags which would be added by [maximize].
  Locale minimize() => minimizeImpl(this);

  /// Try to add the most likely language, script, and region tags.
  Locale maximize() => maximizeImpl(this);

  /// Parse a language tag by calling to web/ICU4X functionalities.
  static Locale parse(String s) => parseLocale(s);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Locale &&
        other.language == language &&
        other.script == script &&
        other.region == region &&
        other.calendar == calendar &&
        other.caseFirst == caseFirst &&
        other.collation == collation &&
        other.hourCycle == hourCycle &&
        other.numberingSystem == numberingSystem &&
        other.numeric == numeric;
  }

  @override
  int get hashCode {
    return language.hashCode ^
        script.hashCode ^
        region.hashCode ^
        calendar.hashCode ^
        caseFirst.hashCode ^
        collation.hashCode ^
        hourCycle.hashCode ^
        numberingSystem.hashCode ^
        numeric.hashCode;
  }
}

// TODO: add all locales which are supported by ICU4X / Browsers
const List<Locale> allLocales = [
  Locale(language: 'de', region: 'DE'),
  Locale(language: 'en', region: 'US'),
  Locale(language: 'zh', script: 'Hant'),
];
