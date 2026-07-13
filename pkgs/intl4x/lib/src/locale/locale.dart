// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../datetime_format/datetime_format_options.dart' show ClockStyle;
import '../find_locale.dart';
import '../options.dart' show Calendar, NumberingSystem;
import 'locale_4x.dart' if (dart.library.js_interop) 'locale_ecma.dart';

/// Representing a Unicode locale identifier.
///
/// It is composed of the primary `language` subtag for the locale, the
/// `region` (also referred to as 'country') subtag, and the script subtag.
///
/// Examples are `de-DE`, `es-419`, or `zh-Hant-TW`.
//TODO(mosum): Add RecordUse here somehow to record which locales are used.
abstract class Locale {
  /// Generate a language tag by joining the subtags with the [separator].
  String toLanguageTag([String separator = '-']);

  /// Constructs a [Locale] by parsing a BCP47 language tag.
  static Locale parse(String s) => parseLocale(s);

  /// Returns a new `Locale` with the given `calendar`.
  Locale withCalendar(Calendar calendar);

  /// Returns a new `Locale` with the given [system].
  Locale withNumberingSystem(NumberingSystem system);

  /// Returns a new `Locale` with the given [clockStyle].
  Locale withClockStyle(ClockStyle clockStyle);

  /// The system's current locale.
  static Locale get system => findSystemLocale();

  @override
  String toString() => toLanguageTag();
}

extension CalendarJsName on Calendar {
  /// Returns the JavaScript-compatible name for the calendar.
  ///
  /// This implementation uses a switch expression to map specific enum
  /// values to their corresponding JS names, falling back to the enum's
  /// `name` for others.
  String get jsName => switch (this) {
    Calendar.traditionalChinese => 'chinese',
    Calendar.traditionalKorean => 'dangi',
    Calendar.ethiopianAmeteAlem => 'ethioaa',
    Calendar.ethiopian => 'ethiopic',
    Calendar.gregorian => 'gregory',
    Calendar.hijriUmalqura => 'islamic-umalqura',
    Calendar.hijriTbla => 'islamic-tbla',
    Calendar.hijriCivil => 'islamic-civil',
    Calendar.minguo => 'roc',
    _ => name,
  };
}

extension NumberingSystemJsName on NumberingSystem {
  /// Returns the BCP 47/CLDR short name for the numbering system.
  String get jsName => switch (this) {
    NumberingSystem.arabic => 'arab',
    NumberingSystem.extendedarabicindic => 'arabext',
    NumberingSystem.balinese => 'bali',
    NumberingSystem.bangla => 'beng',
    NumberingSystem.devanagari => 'deva',
    NumberingSystem.fullwidth => 'fullwide',
    NumberingSystem.gujarati => 'gujr',
    NumberingSystem.gurmukhi => 'guru',
    NumberingSystem.hanjadecimal => 'hant',
    NumberingSystem.khmer => 'khmr',
    NumberingSystem.kannada => 'knda',
    NumberingSystem.lao => 'laoo',
    NumberingSystem.malayalam => 'mlym',
    NumberingSystem.mongolian => 'mong',
    NumberingSystem.myanmar => 'mymr',
    NumberingSystem.odia => 'orya',
    NumberingSystem.tamildecimal => 'taml',
    NumberingSystem.telugu => 'telu',
    NumberingSystem.thai => 'thai',
    NumberingSystem.tibetan => 'tibt',
    NumberingSystem.latin => 'latn',
    NumberingSystem.limbu => 'limb',
  };
}
