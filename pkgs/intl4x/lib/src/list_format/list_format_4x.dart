// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale.dart';
import 'list_format_impl.dart';
import 'list_format_options.dart';

ListFormatImpl getListFormatter4X(Locale locale) => ListFormat4X(locale);

class ListFormat4X extends ListFormatImpl {
  ListFormat4X(super.locale);

  @override
  String formatImpl(List<String> list, ListFormatOptions options) {
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
