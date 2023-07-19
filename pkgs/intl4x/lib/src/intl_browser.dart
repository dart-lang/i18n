// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// This provides facilities for Internationalization that are only available
/// when running in the web browser. You should import only one of this or
/// intl_standalone.dart. Right now the only thing provided here is the
/// ability to find the default locale from the browser.

library intl_browser;

import 'dart:html';

/// Find the system locale, accessed as window.navigator.language, and
/// set it as the default for internationalization operations in the
/// [Intl.systemLocale] variable.
String findSystemLocale() => window.navigator.language;
