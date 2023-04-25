// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl.dart';

import 'collator_impl.dart';
import 'collator_options.dart';

Collator getCollator4X(Intl intl, CollatorOptions options) =>
    Collator4X(intl, options);

class Collator4X extends Collator {
  Collator4X(super.intl, super.options);

  @override
  int compareImpl(String a, String b) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  List<String> supportedLocalesOf(
    List<String> locales,
    LocaleMatcher localeMatcher,
  ) {
    return intl.availableData.entries
        .where((element) => element.value.contains('NumberFormat'))
        .map((e) => e.key)
        .toList();
  }
}
