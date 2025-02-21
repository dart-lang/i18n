// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../bindings/lib.g.dart' as icu;
import '../data.dart';
import '../data_4x.dart';
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'plural_rules.dart';
import 'plural_rules_impl.dart';
import 'plural_rules_options.dart';

PluralRulesImpl getPluralSelect4X(
  Locale locale,
  Data data,
  PluralRulesOptions options,
) =>
    PluralRules4X(locale, data, options);

class PluralRules4X extends PluralRulesImpl {
  final icu.PluralRules _pluralRules;

  PluralRules4X(super.locale, Data data, super.options)
      : _pluralRules = switch (options.type) {
          Type.cardinal => icu.PluralRules.cardinal(data.to4X(), locale.to4X()),
          Type.ordinal => icu.PluralRules.ordinal(data.to4X(), locale.to4X()),
        };

  @override
  PluralCategory selectImpl(num number) {
    final operand = icu.PluralOperands.fromString(number.toString());
    return _pluralRules.categoryFor(operand).toDart();
  }
}

extension on icu.PluralCategory {
  PluralCategory toDart() => switch (this) {
        icu.PluralCategory.zero => PluralCategory.zero,
        icu.PluralCategory.one => PluralCategory.one,
        icu.PluralCategory.two => PluralCategory.two,
        icu.PluralCategory.few => PluralCategory.few,
        icu.PluralCategory.many => PluralCategory.many,
        icu.PluralCategory.other => PluralCategory.other,
      };
}
