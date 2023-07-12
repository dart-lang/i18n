// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// This provides a way for a test to print to an internal list so the
/// results can be verified rather than writing to and reading a file.

library print_to_list.dart;

List<String> lines = [];

void printOut(String s) {
  lines.add(s);
}
