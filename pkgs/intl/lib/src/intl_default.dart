// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Default implementation of findSystemLocale, which throws if called.
/// Platforms with the 'io' and 'html' libraries should use
/// `intl_standalone.dart` and `intl_browser.dart` respectively.
library;

/// Find the system locale, accessed via the appropriate system APIs, and
/// set it as the default for internationalization operations in
/// the [Intl.systemLocale] variable.
Future<String> findSystemLocale() {
  throw UnsupportedError(
      'intl.findSystemLocale is not implemented on this platform.');
}
