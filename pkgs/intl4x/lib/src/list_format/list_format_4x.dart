// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../bindings/lib.g.dart' as icu;
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'list_format_impl.dart';
import 'list_format_options.dart';

ListFormatImpl getListFormatter4X(Locale locale, ListFormatOptions options) =>
    ListFormat4X(locale, options);

class ListFormat4X extends ListFormatImpl {
  final icu.ListFormatter _formatter;
  ListFormat4X(super.locale, super.options)
    : _formatter = _getFormatter(locale, options);

  @override
  String formatImpl(List<String> list) {
    return _formatter.format(list);
  }

  static icu.ListFormatter _getFormatter(
    Locale locale,
    ListFormatOptions options,
  ) {
    final constructor = switch (options.type) {
      Type.and => icu.ListFormatter.andWithLength,
      Type.or => icu.ListFormatter.orWithLength,
      Type.unit => icu.ListFormatter.unitWithLength,
    };
    return constructor(locale.toX, options.style.toX);
  }
}

extension on ListStyle {
  icu.ListLength get toX => switch (this) {
    ListStyle.narrow => icu.ListLength.narrow,
    ListStyle.short => icu.ListLength.short,
    ListStyle.long => icu.ListLength.wide,
  };
}
