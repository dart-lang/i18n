// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Indicates the type of grouping.
/// * [conjunction] for "and"-based grouping of the list items: "A, B, and C"
/// * [disjunction] for "or"-based grouping of the list items: "A, B, or C"
/// * [unit] for grouping the list items as a unit: "A, B, C"
enum Type {
  conjunction,
  disjunction,
  unit;
}

/// Indicates the grouping style (for example, whether list separators and
/// conjunctions are included).
/// * [long] "A, B, and C"
/// * [short] "A, B, C"
/// * [narrow] "A B C"
enum ListStyle {
  long,
  short,
  narrow;
}
