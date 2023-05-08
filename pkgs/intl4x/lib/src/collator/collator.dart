// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../intl4x_test_checker.dart';
import '../options.dart';
import 'collator_options.dart';

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
