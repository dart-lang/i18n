// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../bindings/lib.g.dart' as icu;
import '../data.dart';
import '../data_4x.dart';
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'collation_impl.dart';
import 'collation_options.dart';

CollationImpl getCollator4X(
        Locale locale, Data data, CollationOptions options) =>
    Collation4X(locale, data, options);

class Collation4X extends CollationImpl {
  final icu.Collator _collator;

  Collation4X(Locale locale, Data data, CollationOptions options)
      : _collator = icu.Collator.v1(
          data.to4X(),
          locale.to4X(),
          options.to4xOptions(),
        ),
        super(locale, options);

  @override
  int compareImpl(String a, String b) => _collator.compare(a, b).index;
}

extension on CollationOptions {
  icu.CollatorOptionsV1 to4xOptions() {
    final icu4xOptions = icu.CollatorOptionsV1();

    icu4xOptions.numeric =
        numeric ? icu.CollatorNumeric.on : icu.CollatorNumeric.off;

    icu4xOptions.caseFirst = switch (caseFirst) {
      CaseFirst.upper => icu.CollatorCaseFirst.upperFirst,
      CaseFirst.lower => icu.CollatorCaseFirst.lowerFirst,
      CaseFirst.localeDependent => icu.CollatorCaseFirst.off,
    };

    return icu4xOptions;
  }
}
