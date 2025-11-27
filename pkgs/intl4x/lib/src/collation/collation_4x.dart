// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import '../utils.dart';
import 'collation_impl.dart';
import 'collation_options.dart';

CollationImpl getCollator4X(Locale locale, CollationOptions options) =>
    Collation4X(locale as Locale4x, options);

class Collation4X extends CollationImpl {
  final icu.Collator _collator;

  Collation4X(Locale4x super.locale, super.options)
    : _collator = icu.Collator(
        locale.get4X.clone()..setOptions(options),
        options.toX,
      );

  @override
  int compareImpl(String a, String b) => _collator.compare(a, b);
}

extension on icu.Locale {
  void setOptions(CollationOptions options) {
    options.numeric?.map(
      (numeric) => setUnicodeExtension('kn', numeric.toString()),
    );

    options.caseFirst?.map(
      (caseFirst) => setUnicodeExtension('kf', switch (caseFirst) {
        CaseFirst.upper => caseFirst.name,
        CaseFirst.lower => caseFirst.name,
        CaseFirst.localeDependent => 'false',
      }),
    );
  }
}

extension on CollationOptions {
  icu.CollatorOptions get toX {
    final icuStrength = switch (sensitivity) {
      Sensitivity.base => icu.CollatorStrength.primary,
      Sensitivity.accent => icu.CollatorStrength.secondary,
      Sensitivity.caseSensitivity => icu.CollatorStrength.primary,
      Sensitivity.variant => icu.CollatorStrength.tertiary,
      null => icu.CollatorStrength.tertiary,
    };

    final icuCaseLevel = sensitivity == Sensitivity.caseSensitivity
        ? icu.CollatorCaseLevel.on
        : icu.CollatorCaseLevel.off;

    return icu.CollatorOptions(
      strength: icuStrength,
      caseLevel: icuCaseLevel,
      alternateHandling: ignorePunctuation
          ? icu.CollatorAlternateHandling.shifted
          : icu.CollatorAlternateHandling.nonIgnorable,
      //TODO(mosum): maxVariable: Not supported in ECMA402
    );
  }
}
