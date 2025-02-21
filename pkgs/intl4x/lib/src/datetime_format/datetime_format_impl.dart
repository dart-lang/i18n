// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../data.dart';
import '../ecma/ecma_policy.dart';
import '../locale/locale.dart';
import '../options.dart';
import '../utils.dart';
import 'datetime_format_options.dart';
import 'datetime_format_stub.dart'
    if (dart.library.js) 'datetime_format_ecma.dart';
import 'datetime_format_stub_4x.dart'
    if (dart.library.io) 'datetime_format_4x.dart';

/// This is an intermediate to defer to the actual implementations of
/// datetime formatting.
abstract class DateTimeFormatImpl {
  final Locale locale;
  final DateTimeFormatOptions options;

  DateTimeFormatImpl(this.locale, this.options);

  String formatImpl(DateTime datetime);

  static DateTimeFormatImpl build(
    Locale locale,
    Data data,
    DateTimeFormatOptions options,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locale,
        data,
        options,
        localeMatcher,
        ecmaPolicy,
        getDateTimeFormatterECMA,
        getDateTimeFormatter4X,
      );
}
