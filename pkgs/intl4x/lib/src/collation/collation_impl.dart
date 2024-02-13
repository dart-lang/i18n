// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart' show ResourceIdentifier;

import '../data.dart';
import '../ecma/ecma_policy.dart';
import '../locale/locale.dart';
import '../options.dart';
import '../utils.dart';
import 'collation.dart';
import 'collation_options.dart';
import 'collation_stub.dart' if (dart.library.js) 'collation_ecma.dart';
import 'collation_stub_4x.dart' if (dart.library.io) 'collation_4x.dart';

/// Separated into a class to not clutter the public API with implementation
/// details.
abstract class CollationImpl {
  /// The current locale, selected by the localematcher
  final Locale locale;
  final CollationOptions options;

  CollationImpl(this.locale, this.options);

  /// Factory to get the correct implementation, either calling on ICU4X or the
  /// in-built browser implementation.
  @ResourceIdentifier('Collation')
  static CollationImpl build(
    Locale locale,
    Data data,
    CollationOptions options,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locale,
        data,
        options,
        localeMatcher,
        ecmaPolicy,
        getCollatorECMA,
        getCollator4X,
      );

  /// Actual implementation of the [Collation.compare] method.
  int compareImpl(String a, String b);
}
