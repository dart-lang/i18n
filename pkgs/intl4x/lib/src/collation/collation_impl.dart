// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale/locale.dart';
import '../utils.dart';
import 'collation.dart';
import 'collation_options.dart';
import 'collation_stub.dart' if (dart.library.js_interop) 'collation_ecma.dart';
import 'collation_stub_4x.dart' if (dart.library.ffi) 'collation_4x.dart';

/// Separated into a class to not clutter the public API with implementation
/// details.
abstract class CollationImpl {
  final Locale locale;
  final CollationOptions options;

  CollationImpl(this.locale, this.options);

  /// Factory to get the correct implementation, either calling on ICU4X or the
  /// in-built browser implementation.
  static CollationImpl build(Locale locale, CollationOptions options) =>
      buildFormatter(locale, options, getCollatorECMA, getCollator4X);

  /// Actual implementation of the [Collation.compare] method.
  int compareImpl(String a, String b);
}
