// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../data.dart';
import '../locale/locale.dart';
import 'number_format_impl.dart';
import 'number_format_options.dart';

NumberFormatImpl getNumberFormatter4X(
        Locale locale, Data data, NumberFormatOptions options) =>
    NumberFormat4X(locale, data, options);

class NumberFormat4X extends NumberFormatImpl {
  NumberFormat4X(super.locale, Data data, super.options);

  @override
  String formatImpl(Object number) {
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
