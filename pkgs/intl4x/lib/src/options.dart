// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
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

enum NumberingSystem {
  /// Arabic-Indic digits.
  arab,

  /// Extended Arabic-Indic digits.
  arabext,

  /// Balinese digits.
  bali,

  /// Bengali digits.
  beng,

  /// Devanagari digits.
  deva,

  /// Full-width digits.
  ///
  /// Full-width digits (like ０１２３４５６７８９) are characters that occupy the full
  /// square space of East Asian characters, unlike standard half-width digits
  /// (0-9) that take half the space, designed for compatibility in systems
  /// handling both narrow Latin and wide CJK (Chinese, Japanese, Korean) text,
  /// often used in forms or Japanese contexts for uniform alignment.
  fullwide,

  /// Gujarati digits.
  gujr,

  /// Gurmukhi digits.
  guru,

  /// Hanja decimal digits.
  hanidec,

  /// Khmer digits.
  khmr,

  /// Kannada digits.
  knda,

  /// Lao digits.
  laoo,

  /// Latin digits.
  latn,

  /// Limbu digits.
  limb,

  /// Malayalam digits.
  mlym,

  /// Mongolian digits.
  mong,

  /// Myanmar digits.
  mymr,

  /// Oriya digits.
  orya,

  /// Tamil decimal digits.
  tamldec,

  /// Telugu digits.
  telu,

  /// Thai digits.
  thai,

  /// Tibetan digits.
  tibt,
}

/// Used for multiple option types which confirm to the triad of
/// narrow/short/long.
enum Style { narrow, short, long }
