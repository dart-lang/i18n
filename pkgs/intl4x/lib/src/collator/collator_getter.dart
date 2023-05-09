// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../ecma/ecma_policy.dart';
import '../locale.dart';
import '../options.dart';
import '../utils.dart';
import 'collator.dart';
import 'collator_4x.dart';
import 'collator_stub.dart' if (dart.library.js) 'collator_ecma.dart';

Collator getFormatter(
  List<Locale> locales,
  LocaleMatcher localeMatcher,
  EcmaPolicy ecmaPolicy,
) =>
    buildFormatter(
      locales,
      localeMatcher,
      ecmaPolicy,
      getCollatorECMA,
      getCollator4X,
    );
