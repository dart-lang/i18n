// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../ecma/ecma_policy.dart';
import '../locale.dart';
import '../options.dart';
import '../utils.dart';
import 'collation_4x.dart';
import 'collation_options.dart';
import 'collation_stub.dart' if (dart.library.js) 'collation_ecma.dart';

/// Separated into a class to not clutter the public API with implementation
/// details.
abstract class CollationImpl {
  /// The current locale, selected by the localematcher
  final Locale locale;

  CollationImpl(this.locale);

  /// Factory to get the correct implementation, either calling on ICU4X or the
  /// in-built browser implementation.
  factory CollationImpl.build(
    Locale locales,
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

  /// Actual implementation of the [compare] method.
  int compareImpl(String a, String b, CollationOptions options);
}
