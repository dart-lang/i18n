// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';

import '../options.dart';
import 'collator_4x.dart';
import 'collator_impl.dart';
import 'collator_options.dart';
import 'collator_stub.dart' if (dart.library.js) 'collator_ecma.dart';

class Collation {
  final Intl _intl;

  const Collation(this._intl);

  int compare(
    String a,
    String b, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Usage usage = Usage.sort,
    Sensitivity? sensitivity,
    bool ignorePunctuation = false,
    bool numeric = false,
    CaseFirst? caseFirst,
    String? collation,
  }) {
    var options = CollatorOptions(
      localeMatcher: localeMatcher,
      usage: usage,
      sensitivity: sensitivity,
      ignorePunctuation: ignorePunctuation,
      numeric: numeric,
      caseFirst: caseFirst,
      collation: collation,
    );
    Collator collator;
    if (_intl.useEcma) {
      collator = getCollator(_intl, options);
    } else {
      collator = getCollator4X(_intl, options);
    }
    return collator.compare(a, b);
  }
}
