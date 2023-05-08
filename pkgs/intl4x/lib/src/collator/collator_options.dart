// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
