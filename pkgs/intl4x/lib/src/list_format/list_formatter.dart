// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl.dart';

import '../../intl_testutils.dart';
import 'list_format_options.dart';

abstract class ListFormatter {
  final Intl intl;
  final ListFormatOptions listFormatOptions;

  ListFormatter(this.intl, this.listFormatOptions);

  String format(List<String> list) {
    if (isInTest) {
      return '${list.join(', ')}-${intl.locale}';
    }
    return formatImpl(list);
  }

  String formatImpl(List<String> list);

  List<String> supportedLocalesOf(
    List<String> locales,
    LocaleMatcher localeMatcher,
  );
}

enum LocaleMatcher {
  lookup('lookup'),
  bestfit('best fit');

  final String jsName;
  const LocaleMatcher(this.jsName);
}
