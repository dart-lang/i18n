// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'package:intl4x/intl4x.dart';
import 'package:intl4x/src/ecma/ecma_policy.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Check default policy',
    () => expect(Intl().ecmaPolicy, const NeverEcma()),
  );
}
