// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../ecma/ecma_policy.dart';
import '../locale.dart';
import '../options.dart';
import '../utils.dart';
import 'datetime_format_4x.dart';
import 'datetime_format_options.dart';
import 'datetime_format_stub.dart'
    if (dart.library.js) 'datetime_format_ecma.dart';

/// This is an intermediate to defer to the actual implementations of
/// datetime formatting.
abstract class DatetimeFormatImpl {
  final String locale;

  DatetimeFormatImpl(this.locale);

  String formatImpl(DateTime datetime, DatetimeFormatOptions options);

  factory DatetimeFormatImpl.build(
    Locale locale,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locale,
        localeMatcher,
        ecmaPolicy,
        getDatetimeFormatterECMA,
        getDatetimeFormatter4X,
      );
}
