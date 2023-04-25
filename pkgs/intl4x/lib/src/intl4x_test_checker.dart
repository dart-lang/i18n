// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

/// Check if we are in a test environment, by checking for the `#test.declarer`
/// symbol defined in the zone in which a Dart test runs.
bool get isInTest {
  if (Zone.current[#test.declarer] != null &&
      !(Zone.current[#test.allowFormatting] as bool)) {
    return true;
  } else {
    return false;
  }
}
