// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';
import 'list_formatter.dart';

ListFormatter getListFormatter4X(Intl intl, ListFormatOptions options) =>
    ListFormat4X(intl, options);

class ListFormat4X extends ListFormatter {
  ListFormat4X(super.intl, super.numberFormatterData);

  @override
  String formatImpl(List<String> list) {
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
