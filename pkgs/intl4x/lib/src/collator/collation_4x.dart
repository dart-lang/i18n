// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale.dart';
import '../options.dart';
import 'collation.dart';
import 'collation_options.dart';

Collation getCollator4X(List<Locale> locales) => Collation(Collation4X(
      locales,
      LocaleMatcher.bestfit,
    ));

class Collation4X extends CollationImpl {
  Collation4X(super.locale, super.localeMatcher);

  @override
  int compareImpl(
    String a,
    String b, {
    Usage usage = Usage.sort,
    Sensitivity? sensitivity,
    bool ignorePunctuation = false,
    bool numeric = false,
    CaseFirst? caseFirst,
    String? collation,
  }) {
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
