// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';

class ListFormatOptions {
  final Type type;
  final ListStyle style;
  final LocaleMatcher localeMatcher;

  const ListFormatOptions({
    this.type = Type.conjunction,
    this.style = ListStyle.long,
    this.localeMatcher = LocaleMatcher.bestfit,
  });
}

/// Indicates the type of grouping.
enum Type {
  /// For "and"-based grouping of the list items: "A, B, and C"
  conjunction,

  /// For "or"-based grouping of the list items: "A, B, or C"
  disjunction,

  /// Grouping the list items as a unit: "A, B, C"
  unit;
}

/// Indicates the grouping style (for example, whether list separators and
/// conjunctions are included).
enum ListStyle {
  /// Example: "A, B, and C"
  long,

  /// Example: "A, B, C"
  short,

  /// Example: "A B C"
  narrow;
}
