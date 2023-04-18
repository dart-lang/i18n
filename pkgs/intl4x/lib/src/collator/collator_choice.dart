// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/intl.dart';

import 'collator_4x.dart';
import 'collator_options.dart';
import 'collator_stub.dart' if (dart.library.js) 'number_format_ecma.dart';
import 'collator_impl.dart';

class CollatorChoice {
  final Intl intl;

  const CollatorChoice(this.intl);

  Collator custom({
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
    if (intl.ecmaPolicy.useFor(intl.locale)) {
      return getCollator(intl, options);
    } else {
      return getCollator4X(intl, options);
    }
  }
}
