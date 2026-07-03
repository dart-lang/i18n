// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';

typedef ListStyle = Style;

class ListFormatOptions {
  final ListType type;

  /// Indicates the grouping style (for example, whether list separators and
  /// conjunctions are included).
  /// * long: "A, B, and C".
  /// * short: "A, B, C".
  /// * narrow: "A B C".
  final ListStyle style;

  const ListFormatOptions({required this.type, required this.style});
}

/// Indicates the type of grouping.
enum ListType {
  /// For "and"-based grouping of the list items: "A, B, and C".
  and,

  /// For "or"-based grouping of the list items: "A, B, or C".
  or,

  /// Grouping the list items as a unit: "A, B, C".
  unit,
}
