// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../data.dart';
import '../locale/locale.dart';
import 'list_format_impl.dart';
import 'list_format_options.dart';

ListFormatImpl getListFormatter4X(
        Locale locale, Data data, ListFormatOptions options) =>
    ListFormat4X(locale, data, options);

class ListFormat4X extends ListFormatImpl {
  ListFormat4X(super.locale, Data data, super.options);

  @override
  String formatImpl(List<String> list) {
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
