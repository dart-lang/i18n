// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// This provides facilities for Internationalization that are only available
/// when running in the web browser. You should import only one of this or
/// intl_standalone.dart. Right now the only thing provided here is the
/// ability to find the default locale from the browser.
library;

Future<String> findSystemLocale() => throw UnimplementedError(
    'This is a stub for either `intl_standalone` or `intl_browser`');
