// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'list_formatter.dart';

class ListFormatOptions {
  final LocaleMatcher localeMatcher;
  final Type type;
  final ListStyle style;

  ListFormatOptions({
    required this.localeMatcher,
    required this.type,
    required this.style,
  });
}

enum Type {
  conjunction,
  disjunction,
  unit;
}

enum ListStyle {
  long,
  short,
  narrow;
}
