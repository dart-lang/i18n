// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

/// Placeholder for the data type of ICU4X - tbd!
abstract final class Data {}

final class JsonData extends Data {
  final String value;

  JsonData(this.value);
}

final class BlobData extends Data {
  final Uint8List value;

  BlobData(this.value);
}
