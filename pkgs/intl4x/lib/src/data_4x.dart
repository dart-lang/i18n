// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'bindings/lib.g.dart' as icu;
import 'data.dart';

extension DataProvider on Data {
  icu.DataProvider to4X() => switch (this) {
        AssetData() => icu.DataProvider.fromByteSlice(
            File((this as AssetData).key).readAsBytesSync().buffer),
        BundleData() => icu.DataProvider.compiled(),
        NoData() => icu.DataProvider.empty(),
      };
}
