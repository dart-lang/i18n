// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';

import 'number_formatter.dart';

NumberFormatter getNumberFormatter4X(Intl intl, NumberFormatOptions options) =>
    NumberFormat4X(intl, options);

class NumberFormat4X extends NumberFormatter {
  NumberFormat4X(super.intl, super.numberFormatterData);

  @override
  String formatImpl(Object number) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  List<String> supportedLocalesOf(List<String> locales) {
    return intl.icu4xDataKeys.entries
        .where((element) => element.value.contains('NumberFormat'))
        .map((e) => e.key)
        .toList();
  }
}
