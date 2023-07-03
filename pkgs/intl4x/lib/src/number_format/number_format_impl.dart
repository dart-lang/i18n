// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../ecma/ecma_policy.dart';
import '../locale.dart';
import '../options.dart';
import '../utils.dart';
import 'number_format_4x.dart';
import 'number_format_options.dart';
import 'number_format_stub.dart' if (dart.library.js) 'number_format_ecma.dart';

/// Number formatting functionality of the browser.

abstract class NumberFormatImpl {
  final List<String> locales;

  NumberFormatImpl(this.locales);

  String formatImpl(Object number, NumberFormatOptions options);

  factory NumberFormatImpl.build(
    List<Locale> locales,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locales,
        localeMatcher,
        ecmaPolicy,
        getNumberFormatterECMA,
        getNumberFormatter4X,
      );
}
