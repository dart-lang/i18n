// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

/// Find the system locale, accessed via the appropriate system APIs, and
/// set it as the default for internationalization operations in
/// the [Intl.systemLocale] variable.
String findSystemLocale() {
  try {
    return Platform.localeName;
  } catch (e) {
    return 'en-US';
  }
}
