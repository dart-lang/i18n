// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../options.dart';

typedef ListStyle = Style;

class ListFormatOptions {
  final Type type;

  /// Indicates the grouping style (for example, whether list separators and
  /// conjunctions are included).
  /// * long: "A, B, and C".
  /// * short: "A, B, C".
  /// * narrow: "A B C".
  final ListStyle style;

  const ListFormatOptions({this.type = Type.and, this.style = ListStyle.long});

  ListFormatOptions copyWith({Type? type, ListStyle? style}) {
    return ListFormatOptions(
      type: type ?? this.type,
      style: style ?? this.style,
    );
  }
}

/// Indicates the type of grouping.
enum Type {
  /// For "and"-based grouping of the list items: "A, B, and C".
  and('conjunction'),

  /// For "or"-based grouping of the list items: "A, B, or C".
  or('disjunction'),

  /// Grouping the list items as a unit: "A, B, C".
  unit;

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Type([this._jsName]);
}
