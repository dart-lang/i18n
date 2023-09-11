// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/varint.dart';
import 'package:test/test.dart';

void main() {
  test('int -> varint -> int', () {
    void testNum(int n) {
      expect(VarInt.fromVarint(VarInt.toVarint(n)).value, n);
    }

    testNum(5);
    testNum(50);
    testNum(2000);
    testNum(1112063);
    testNum(268435456);
  });
}
