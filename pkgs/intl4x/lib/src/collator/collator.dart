// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../ecma/ecma_policy.dart';
import '../locale.dart';
import '../options.dart';
import '../test_checker.dart';
import '../utils.dart';
import 'collator_4x.dart';
import 'collator_options.dart';
import 'collator_stub.dart' if (dart.library.js) 'collator_ecma.dart';

Collator getFormatter(
  List<Locale> locales,
  LocaleMatcher localeMatcher,
  EcmaPolicy ecmaPolicy,
) =>
    buildFormatter(
      locales,
      localeMatcher,
      ecmaPolicy,
      getCollatorECMA,
      getCollator4X,
    );

abstract class Collator {
  final String locale;
  const Collator(this.locale);

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
    if (isInTest) {
      return a.compareTo(b);
    } else {
      return compareImpl(a, b);
    }
  }

  int compareImpl(
    String a,
    String b, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Usage usage = Usage.sort,
    Sensitivity? sensitivity,
    bool ignorePunctuation = false,
    bool numeric = false,
    CaseFirst? caseFirst,
    String? collation,
  });
}
