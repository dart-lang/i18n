// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../test_checker.dart';
import 'number_format_impl.dart';
import 'number_format_options.dart';

class NumberFormat {
  final NumberFormatOptions _options;
  final NumberFormatImpl impl;

  NumberFormat(this._options, this.impl);

  String format(Object number) {
    if (isInTest) {
      return '$number//${impl.locale}';
    } else {
      return impl.formatImpl(number, _options);
    }
  }
}
