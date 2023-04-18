// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'collator_impl.dart';

class CollatorOptions {
  final LocaleMatcher localeMatcher;
  final Usage usage;
  final Sensitivity? sensitivity;
  final bool ignorePunctuation;
  final bool numeric;
  final CaseFirst? caseFirst;
  final String? collation;

  CollatorOptions({
    required this.localeMatcher,
    required this.usage,
    required this.sensitivity,
    required this.ignorePunctuation,
    required this.numeric,
    required this.caseFirst,
    required this.collation,
  });
}

enum Usage {
  search,
  sort;
}

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
