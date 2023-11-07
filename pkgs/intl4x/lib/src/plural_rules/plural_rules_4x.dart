// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../data.dart';
import '../locale/locale.dart';
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
  PluralRules4X(super.locale, Data data, super.options);

  @override
  PluralCategory selectImpl(num number) {
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
