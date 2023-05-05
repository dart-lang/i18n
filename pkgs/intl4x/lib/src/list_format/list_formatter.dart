// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';
import '../intl4x_test_checker.dart';

abstract class ListFormatter {
  final Intl intl;
  final ListFormatOptions options;

  ListFormatter(this.intl, this.options);

  String format(List<String> list) {
    if (isInTest) {
      return '${list.join(', ')}-${intl.locale}';
    }
    return formatImpl(list);
  }

  String formatImpl(List<String> list);

  List<String> supportedLocalesOf(List<String> locales);
}
