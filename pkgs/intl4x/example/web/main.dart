// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/ecma_policy.dart';
import 'package:intl4x/intl4x.dart';

void main() {
  Intl(
    defaultLocale: ['en'],
    ecmaPolicy: AlwaysEcma(),
  );
  //TODO: Add examples for formatting.
}
