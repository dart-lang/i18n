// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../test_checker.dart';
import 'plural_rules_impl.dart';

class PluralRules {
  final PluralRulesImpl _pluralRulesImpl;

  const PluralRules(this._pluralRulesImpl);

  /// Locale-dependant pluralization, for example in English:
  ///
  /// select(2) == PluralCategory.other
  PluralCategory select(num number) {
    if (isInTest) {
      return PluralCategory.other;
    } else {
      return _pluralRulesImpl.selectImpl(number);
    }
  }
}

enum PluralCategory { zero, one, two, few, many, other }
