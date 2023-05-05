// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';

import '../options.dart';
import 'list_format_4x.dart';
import 'list_format_stub.dart' if (dart.library.js) 'list_format_ecma.dart';
import 'list_formatter.dart';

class ListFormat {
  final Intl _intl;

  const ListFormat(this._intl);

  String format(
    List<String> list, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Type type = Type.conjunction,
    ListStyle style = ListStyle.long,
  }) {
    var options = ListFormatOptions(
      localeMatcher: localeMatcher,
      type: type,
      style: style,
    );
    ListFormatter listFormatter;
    if (_intl.ecmaPolicy.useFor(_intl.locale)) {
      listFormatter = getListFormatter(_intl, options);
    } else {
      listFormatter = getListFormatter4X(_intl, options);
    }
    return listFormatter.format(list);
  }
}
