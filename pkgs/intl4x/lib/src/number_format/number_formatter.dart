// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';
import '../intl4x_test_checker.dart';

abstract class NumberFormatter {
  final Intl intl;
  final NumberFormatOptions options;

  const NumberFormatter(this.intl, this.options);

  String format(Object number) {
    if (isInTest) {
      return '$number//${intl.locale}';
    }
    return formatImpl(number);
  }

  String formatImpl(Object number);

  List<String> supportedLocalesOf(List<String> locales);
}
