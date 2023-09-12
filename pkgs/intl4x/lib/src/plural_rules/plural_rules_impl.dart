// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../ecma_policy.dart';
import '../ecma/ecma_policy.dart';
import '../locale/locale.dart';
import '../options.dart';
import '../utils.dart';
import 'plural_rules.dart';
import 'plural_rules_4x.dart';
import 'plural_rules_options.dart';
import 'plural_rules_stub.dart' if (dart.library.js) 'plural_rules_ecma.dart';

abstract class PluralRulesImpl {
  final Locale locale;

  PluralRulesImpl(this.locale);

  PluralCategory selectImpl(num number, PluralRulesOptions options);

  factory PluralRulesImpl.build(
    Locale locales,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locales,
        localeMatcher,
        ecmaPolicy,
        getPluralSelectECMA,
        getPluralSelect4X,
      );
}
