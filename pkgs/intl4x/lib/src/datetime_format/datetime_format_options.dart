// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';

/// datetime formatting functionality of the browser.
class DatetimeFormatOptions {
  final LocaleMatcher localeMatcher;

  const DatetimeFormatOptions({
    this.localeMatcher = LocaleMatcher.bestfit,
  });
}
