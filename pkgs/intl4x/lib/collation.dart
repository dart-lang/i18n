// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'collation.dart' show Collation;
import 'src/locale/locale.dart' show Locale;

export 'src/collation/collation.dart' show Collation;
export 'src/collation/collation_options.dart';
export 'src/locale/locale.dart' show Locale;
export 'src/options.dart';

extension CollationExt on String {
  /// Compare two strings in a locale-dependent manner.
  ///
  /// For more options, use [Collation] directly.
  int compareLocale(String other, {Locale? locale}) =>
      Collation(locale: locale).compare(this, other);
}
