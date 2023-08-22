// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';

class CollationOptions {
  final Usage usage;
  final Sensitivity? sensitivity;
  final bool ignorePunctuation;
  final bool numeric;
  final CaseFirst? caseFirst;
  final String? collation;
  final LocaleMatcher localeMatcher;

  const CollationOptions({
    this.localeMatcher = LocaleMatcher.bestfit,
    this.usage = Usage.sort,
    this.sensitivity,
    this.ignorePunctuation = false,
    this.numeric = false,
    this.caseFirst,
    this.collation,
  });

  CollationOptions copyWith({
    Usage? usage,
    Sensitivity? sensitivity,
    bool? ignorePunctuation,
    bool? numeric,
    CaseFirst? caseFirst,
    String? collation,
    LocaleMatcher? localeMatcher,
  }) {
    return CollationOptions(
      usage: usage ?? this.usage,
      sensitivity: sensitivity ?? this.sensitivity,
      ignorePunctuation: ignorePunctuation ?? this.ignorePunctuation,
      numeric: numeric ?? this.numeric,
      caseFirst: caseFirst ?? this.caseFirst,
      collation: collation ?? this.collation,
      localeMatcher: localeMatcher ?? this.localeMatcher,
    );
  }
}

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
  caseSensitivity('case'),

  /// Strings that differ in base letters, accents and other diacritic
  /// marks, or case compare as unequal. Other differences may also be taken
  /// into consideration. Examples: a ≠ b, a ≠ á, a ≠ A.
  variant;

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Sensitivity([this._jsName]);
}

/// How upper case or lower case letters should be sorted.
enum CaseFirst {
  upper,
  lower,
  localeDependent('false');

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const CaseFirst([this._jsName]);
}
