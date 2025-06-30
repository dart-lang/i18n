// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../test_checker.dart';
import 'number_format_impl.dart';

class NumberFormat {
  final NumberFormatImpl _impl;

  NumberFormat._(this._impl);

  String format(Object number) {
    if (isInTest) {
      return '$number//${_impl.locale}';
    } else {
      return _impl.formatImpl(number);
    }
  }
}

NumberFormat buildNumberFormat(NumberFormatImpl impl) => NumberFormat._(impl);
