// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart' show ResourceIdentifier;

import '../../ecma_policy.dart';
import '../data.dart';
import '../ecma/ecma_policy.dart';
import '../locale/locale.dart';
import '../utils.dart';
import 'plural_rules.dart';
import 'plural_rules_options.dart';
import 'plural_rules_stub.dart' if (dart.library.js) 'plural_rules_ecma.dart';
import 'plural_rules_stub_4x.dart' if (dart.library.io) 'plural_rules_4x.dart';

abstract class PluralRulesImpl {
  final Locale locale;
  final PluralRulesOptions options;

  PluralRulesImpl(this.locale, this.options);

  PluralCategory selectImpl(num number);

  @ResourceIdentifier('PluralRules')
  static PluralRulesImpl build(
    Locale locales,
    Data data,
    PluralRulesOptions options,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locales,
        data,
        options,
        localeMatcher,
        ecmaPolicy,
        getPluralSelectECMA,
        getPluralSelect4X,
      );
}
