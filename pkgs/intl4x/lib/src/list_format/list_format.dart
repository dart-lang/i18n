// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';
import '../test_checker.dart';
import 'list_format_impl.dart';
import 'list_format_options.dart';

class ListFormat {
  final ListFormatOptions _options;
  final ListFormatImpl _listFormatImpl;

  const ListFormat(this._options, this._listFormatImpl);

  /// Locale-dependant concatenation of lists, for example in `en-US` locale
  /// ```dart
  /// format(['A', 'B', 'C']) == 'A, B, and C'
  /// ```
  String format(
    List<String> list, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Type type = Type.conjunction,
    ListStyle style = ListStyle.long,
  }) {
    if (isInTest) {
      return '${list.join(', ')}-${_listFormatImpl.locale}';
    } else {
      return _listFormatImpl.formatImpl(list, _options);
    }
  }
}
