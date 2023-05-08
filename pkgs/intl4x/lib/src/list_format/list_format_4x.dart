// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';
import '../locale.dart';
import '../options.dart';
import 'list_format.dart';

ListFormat getListFormatter4X(List<Locale> locale) =>
    ListFormat4X(locale.first);

class ListFormat4X extends ListFormat {
  ListFormat4X(super.locale);

  // @override
  // List<String> supportedLocalesOf(List<String> locales) {
  //   return intl.icu4xDataKeys.entries
  //       .where((element) => element.value.contains('NumberFormat'))
  //       .map((e) => e.key)
  //       .toList();
  // }

  @override
  String formatImpl(
    List<String> list, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Type type = Type.conjunction,
    ListStyle style = ListStyle.long,
  }) {
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
