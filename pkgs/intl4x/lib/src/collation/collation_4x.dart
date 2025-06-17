// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../bindings/lib.g.dart' as icu;
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'collation_impl.dart';
import 'collation_options.dart';

CollationImpl getCollator4X(Locale locale, CollationOptions options) =>
    Collation4X(locale, options);

class Collation4X extends CollationImpl {
  final icu.Collator _collator;

  Collation4X(super.locale, super.options)
    : _collator = icu.Collator(locale.toX..setOptions(options), options.toX);

  @override
  int compareImpl(String a, String b) => _collator.compare(a, b);
}

const _numericExtensionKey = 'kn';
final _caseFirstExtensionKey = 'kf';

extension on icu.Locale {
  void setOptions(CollationOptions options) {
    final icuNumeric = switch (options.numeric) {
      true => icu.CollatorNumericOrdering.on,
      false => icu.CollatorNumericOrdering.off,
      null => null,
    };
    if (icuNumeric != null &&
        getUnicodeExtension(_numericExtensionKey) != null) {
      setUnicodeExtension(_numericExtensionKey, icuNumeric.name);
    }

    final icuCaseFirst = switch (options.caseFirst) {
      CaseFirst.upper => icu.CollatorCaseFirst.upper,
      CaseFirst.lower => icu.CollatorCaseFirst.lower,
      CaseFirst.localeDependent => icu.CollatorCaseFirst.off,
      null => null,
    };
    if (icuCaseFirst != null) {
      setUnicodeExtension(_caseFirstExtensionKey, switch (icuCaseFirst) {
        icu.CollatorCaseFirst.lower => icuCaseFirst.name,
        icu.CollatorCaseFirst.upper => icuCaseFirst.name,
        icu.CollatorCaseFirst.off => 'false',
      });
    }
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

    final icuCaseLevel =
        sensitivity == Sensitivity.caseSensitivity
            ? icu.CollatorCaseLevel.on
            : icu.CollatorCaseLevel.off;

    return icu.CollatorOptions(
      strength: icuStrength,
      caseLevel: icuCaseLevel,
      alternateHandling:
          ignorePunctuation
              ? icu.CollatorAlternateHandling.shifted
              : icu.CollatorAlternateHandling.nonIgnorable,
      //TODO(mosum): maxVariable: Not supported in ECMA402
    );
  }
}
