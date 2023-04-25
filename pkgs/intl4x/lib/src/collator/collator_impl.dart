// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/intl.dart';

import '../../intl_testutils.dart';
import 'collator_options.dart';

abstract class Collator {
  final Intl intl;
  final CollatorOptions options;

  Collator(this.intl, this.options);

  int compare(String a, String b) {
    if (isInTest()) {
      return a.compareTo(b);
    }
    return compareImpl(a, b);
  }

  int compareImpl(String a, String b);

  List<String> supportedLocalesOf(
    List<String> locales,
    LocaleMatcher localeMatcher,
  );
}

enum LocaleMatcher {
  lookup('lookup'),
  bestfit('best fit');

  final String jsName;
  const LocaleMatcher(this.jsName);
}
