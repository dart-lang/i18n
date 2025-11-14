// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart';
import '../locale/locale.dart' show Locale;
import '../test_checker.dart';
import 'number_format_impl.dart';
import 'number_format_options.dart';

class NumberFormat {
  final NumberFormatImpl _impl;

  NumberFormat({Locale? locale, NumberFormatOptions? options})
    : _impl = NumberFormatImpl.build(
        locale ?? findSystemLocale(),
        options ?? NumberFormatOptions.custom(),
      );

  String format(Object number) {
    if (isInTest) {
      return '$number//${_impl.locale}';
    } else {
      return _impl.formatImpl(number);
    }
  }
}
