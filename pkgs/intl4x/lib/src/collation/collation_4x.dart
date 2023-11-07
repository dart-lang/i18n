// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu/icu.dart' as icu;

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
  final icu.ICU4XCollator _collator;

  Collation4X(Locale locale, Data data, CollationOptions options)
      : _collator = icu.ICU4XCollator.v1(
          data.to4X(),
          locale.to4X(),
          options.toDartOptions(),
        ),
        super(locale, options);

  @override
  int compareImpl(String a, String b) => _collator.compare(a, b).index;
}

extension on CollationOptions {
  icu.ICU4XCollatorOptionsV1 toDartOptions() {
    final icu4xOptions = icu.ICU4XCollatorOptionsV1();

    //Usage usage;
    //TODO: find matching

    //Sensitivity? sensitivity;
    //TODO: find matching

    //bool ignorePunctuation;
    //TODO: find matching

    //bool numeric;
    //TODO: what about auto?
    icu4xOptions.numeric =
        numeric ? icu.ICU4XCollatorNumeric.on : icu.ICU4XCollatorNumeric.off;

    //CaseFirst? caseFirst;
    //TODO: what about localeDependent? What about icu.off and icu.auto?
    final caseFirst4X = switch (caseFirst) {
      CaseFirst.upper => icu.ICU4XCollatorCaseFirst.upperFirst,
      CaseFirst.lower => icu.ICU4XCollatorCaseFirst.lowerFirst,
      CaseFirst.localeDependent => throw UnsupportedError(''),
      null => null,
    };
    if (caseFirst4X != null) {
      icu4xOptions.caseFirst = caseFirst4X;
    }

    //String? collation;
    //TODO: find matching

    return icu4xOptions;
  }
}
