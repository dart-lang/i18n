// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../data.dart';
import '../ecma/ecma_policy.dart';
import '../locale/locale.dart';
import '../options.dart';
import '../utils.dart';
import 'number_format_options.dart';
import 'number_format_stub.dart' if (dart.library.js) 'number_format_ecma.dart';
import 'number_format_stub_4x.dart'
    if (dart.library.io) 'number_format_4x.dart';

/// This is an intermediate to defer to the actual implementations of
/// Number formatting.
abstract class NumberFormatImpl {
  final Locale locale;
  final NumberFormatOptions options;

  NumberFormatImpl(this.locale, this.options);

  String formatImpl(Object number);

  static NumberFormatImpl build(
    Locale locale,
    Data data,
    NumberFormatOptions options,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locale,
        data,
        options,
        localeMatcher,
        ecmaPolicy,
        getNumberFormatterECMA,
        getNumberFormatter4X,
      );
}
