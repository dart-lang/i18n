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
  Locale locale,
  Data data,
  CollationOptions options,
) => Collation4X(locale, data, options);

class Collation4X extends CollationImpl {
  final icu.Collator _collator;

  Collation4X(super.locale, Data? data, super.options)
    : _collator =
          data != null
              ? icu.Collator.createWithProvider(
                data.to4X(),
                locale.to4X(),
                options.to4xOptions(),
              )
              : icu.Collator(locale.to4X(), options.to4xOptions());

  @override
  int compareImpl(String a, String b) => _collator.compare(a, b);
}

extension on CollationOptions {
  icu.CollatorOptions to4xOptions() {
    final icuNumeric =
        numeric
            ? icu.CollatorNumericOrdering.on
            : icu.CollatorNumericOrdering.off;

    final icuCaseFirst = switch (caseFirst) {
      CaseFirst.upper => icu.CollatorCaseFirst.upper,
      CaseFirst.lower => icu.CollatorCaseFirst.lower,
      CaseFirst.localeDependent => icu.CollatorCaseFirst.off,
    };

    final icuStrength = switch (sensitivity) {
      Sensitivity.base => icu.CollatorStrength.primary,
      Sensitivity.accent => icu.CollatorStrength.secondary,
      Sensitivity.caseSensitivity => icu.CollatorStrength.primary,
      Sensitivity.variant => icu.CollatorStrength.tertiary,
      null => icu.CollatorStrength.tertiary,
    };

    final icuCaseLevel =
        sensitivity == Sensitivity.caseSensitivity
            ? icu.CollatorCaseLevel.on
            : icu.CollatorCaseLevel.off;

    return icu.CollatorOptions(
      strength: icuStrength,
      caseLevel: icuCaseLevel,
      alternateHandling: icu.CollatorAlternateHandling.nonIgnorable,
    );
  }
}
