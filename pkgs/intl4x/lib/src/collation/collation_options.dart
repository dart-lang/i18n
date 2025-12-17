// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class CollationOptions {
  final Usage usage;
  final Sensitivity? sensitivity;
  final bool ignorePunctuation;
  final bool? numeric;
  final CaseFirst? caseFirst;
  final String? collation;

  const CollationOptions({
    required this.usage,
    this.sensitivity,
    required this.ignorePunctuation,
    this.numeric,
    this.caseFirst,
    this.collation,
  });
}

/// Whether to use collation for searching for strings in an array, or rather
/// sorting an array of strings.
///
/// Example: For the `de` locale, `['AE', 'Ä']` is the correct order for
/// [Usage.search], but `['Ä', 'AE']` for [Usage.sort].
enum Usage {
  /// The collation is used for searching for strings in an array.
  search,

  /// The collation is used for sorting an array of strings.
  sort,
}

/// Which differences in the strings should lead to non-zero result values.
/// The default is [Sensitivity.variant] for usage [Usage.sort]; it's locale
/// dependent for [Usage.search].
enum Sensitivity {
  /// Only strings that differ in base letters compare as unequal.
  /// Examples: a ≠ b, a = á, a = A.
  base,

  /// Only strings that differ in base letters or accents and other
  /// diacritic marks compare as unequal. Examples: a ≠ b, a ≠ á, a = A.
  accent,

  /// Only strings that differ in base letters or case compare as
  /// unequal. Examples: a ≠ b, a = á, a ≠ A.
  caseSensitivity,

  /// Strings that differ in base letters, accents and other diacritic
  /// marks, or case compare as unequal. Other differences may also be taken
  /// into consideration. Examples: a ≠ b, a ≠ á, a ≠ A.
  variant,
}

/// How upper case or lower case letters should be sorted.
enum CaseFirst {
  /// Sort upper case letters before lower case letters.
  upper,

  /// Sort lower case letters before upper case letters.
  lower,

  /// Sort based on the locale's default.
  localeDependent,
}
