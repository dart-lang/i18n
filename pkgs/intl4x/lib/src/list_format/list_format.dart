// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';
import '../test_checker.dart';
import 'list_format_options.dart';

abstract class ListFormat {
  final String locale;

  const ListFormat(this.locale);

  String format(
    List<String> list, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Type type = Type.conjunction,
    ListStyle style = ListStyle.long,
  }) {
    if (isInTest) {
      return '${list.join(', ')}-$locale';
    } else {
      return formatImpl(
        list,
        localeMatcher: localeMatcher,
        type: type,
        style: style,
      );
    }
  }

  String formatImpl(
    List<String> list, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Type type = Type.conjunction,
    ListStyle style = ListStyle.long,
  });
}
