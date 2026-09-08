// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'first_day_of_week/first_day_of_week.dart';
import 'locale/locale.dart' show Locale;

/// Weekdays.
enum Weekday {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5),
  saturday(6),
  sunday(7);

  /// The ISO 8601 standard index, where Monday is 1 and Sunday is 7.
  final int isoIndex;

  const Weekday(this.isoIndex);

  /// Returns the first day of the week for the given [locale].
  factory Weekday.firstDayOfWeek([Locale? locale]) =>
      getFirstDayOfWeek(locale ?? Locale.system);

  /// Returns the [Weekday] corresponding to the given ISO 8601 index (1 for
  /// Monday, 7 for Sunday).
  factory Weekday.fromIsoIndex(int isoIndex) => switch (isoIndex) {
    1 => Weekday.monday,
    2 => Weekday.tuesday,
    3 => Weekday.wednesday,
    4 => Weekday.thursday,
    5 => Weekday.friday,
    6 => Weekday.saturday,
    7 => Weekday.sunday,
    _ => throw ArgumentError.value(
      isoIndex,
      'isoIndex',
      'Must be between 1 and 7',
    ),
  };
}

/// Calendar types for date and time formatting.
enum Calendar {
  /// The Buddhist calendar.
  buddhist,

  /// The traditional Chinese calendar.
  traditionalChinese,

  /// The Coptic calendar.
  coptic,

  /// The traditional Korean calendar (Dangi).
  traditionalKorean,

  /// The Ethiopic Amete Alem calendar.
  ethiopianAmeteAlem,

  /// The Ethiopic calendar.
  ethiopian,

  /// The Gregorian calendar.
  gregorian,

  /// The Hebrew calendar.
  hebrew,

  /// The Indian national calendar.
  indian,

  /// The Islamic Umm al-Qura calendar.
  hijriUmalqura,

  /// The Islamic tabular calendar.
  hijriTbla,

  /// The Islamic civil calendar.
  hijriCivil,

  /// The Japanese calendar.
  japanese,

  /// The Persian calendar.
  persian,

  /// The Minguo (Republic of China) calendar.
  minguo,
}

/// Numbering systems for number formatting.
enum NumberingSystem {
  /// Arabic-Indic digits.
  arabic,

  /// Extended Arabic-Indic digits.
  extendedarabicindic,

  /// Balinese digits.
  balinese,

  /// Bengali digits.
  bangla,

  /// Devanagari digits.
  devanagari,

  /// Full-width digits.
  ///
  /// Full-width digits (like ０１２３４５６７８９) are characters that occupy the full
  /// square space of East Asian characters, unlike standard half-width digits
  /// (0-9) that take half the space, designed for compatibility in systems
  /// handling both narrow Latin and wide CJK (Chinese, Japanese, Korean) text,
  /// often used in forms or Japanese contexts for uniform alignment.
  fullwidth,

  /// Gujarati digits.
  gujarati,

  /// Gurmukhi digits.
  gurmukhi,

  /// Hanja decimal digits.
  hanjadecimal,

  /// Khmer digits.
  khmer,

  /// Kannada digits.
  kannada,

  /// Lao digits.
  lao,

  /// Latin digits.
  latin,

  /// Limbu digits.
  limbu,

  /// Malayalam digits.
  malayalam,

  /// Mongolian digits.
  mongolian,

  /// Myanmar digits.
  myanmar,

  /// Oriya digits.
  odia,

  /// Tamil decimal digits.
  tamildecimal,

  /// Telugu digits.
  telugu,

  /// Thai digits.
  thai,

  /// Tibetan digits.
  tibetan,
}

/// Used for multiple option types which confirm to the triad of
/// narrow/short/long.
enum Style { narrow, short, long }
