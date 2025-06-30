// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'intl4x.dart';

export 'src/collation/collation.dart' show Collation;
export 'src/collation/collation_options.dart';
export 'src/options.dart';

extension CollationExt on String {
  /// Compare two strings in a locale-dependant manner.
  ///
  /// For more options, use [Intl.collation] directly.
  int compareLocale(String other, {Locale? locale}) =>
      Intl(locale: locale).collation().compare(this, other);
}
