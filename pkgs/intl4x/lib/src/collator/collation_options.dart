// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Whether to use collation for searching for strings in an array, or rather
/// sorting an array of strings.
///
/// Example: For the `de` locale, `['AE', 'Ä']` is the correct order for
/// [Usage.search], but `['Ä', 'AE']` for [Usage.sort].
enum Usage {
  search,
  sort;
}

/// Which differences in the strings should lead to non-zero result values.
/// * [base] Only strings that differ in base letters compare as unequal.
/// Examples: a ≠ b, a = á, a = A.
/// * [accent] Only strings that differ in base letters or accents and other
/// diacritic marks compare as unequal. Examples: a ≠ b, a ≠ á, a = A.
/// * [case] Only strings that differ in base letters or case compare as
/// unequal. Examples: a ≠ b, a = á, a ≠ A.
/// * [variant] Strings that differ in base letters, accents and other diacritic
/// marks, or case compare as unequal. Other differences may also be taken into
/// consideration. Examples: a ≠ b, a ≠ á, a ≠ A.
///
/// The default is [variant] for usage [Usage.sort]; it's locale dependent for
/// [Usage.search].
enum Sensitivity {
  base,
  accent,
  caseSensitivity('case'),
  variant;

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Sensitivity([this._jsName]);
}

enum CaseFirst {
  upper,
  lower,
  no('false');

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const CaseFirst([this._jsName]);
}
