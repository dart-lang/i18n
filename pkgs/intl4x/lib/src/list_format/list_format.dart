// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart' show findSystemLocale;
import '../locale/locale.dart' show Locale;
import '../test_checker.dart';
import 'list_format_impl.dart';
import 'list_format_options.dart';

class ListFormat {
  final ListFormatImpl _listFormatImpl;

  ListFormat({
    Locale? locale,
    ListType type = ListType.and,
    ListStyle style = ListStyle.long,
  }) : _listFormatImpl = ListFormatImpl.build(
         locale ?? findSystemLocale(),
         ListFormatOptions(type: type, style: style),
       );

  /// Locale-dependant concatenation of lists, for example in `en-US` locale:
  /// ```dart
  /// format(['A', 'B', 'C']) == 'A, B, and C'
  /// ```
  String format(List<String> list) {
    if (isInTest) {
      return '${list.join(', ')}//${_listFormatImpl.locale}';
    } else {
      return _listFormatImpl.formatImpl(list);
    }
  }
}
