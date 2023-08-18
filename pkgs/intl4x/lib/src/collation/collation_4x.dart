// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale/locale.dart';
import 'collation_impl.dart';
import 'collation_options.dart';

CollationImpl getCollator4X(Locale locale) => Collation4X(locale);

class Collation4X extends CollationImpl {
  Collation4X(super.locale);

  @override
  int compareImpl(String a, String b, CollationOptions options) {
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
