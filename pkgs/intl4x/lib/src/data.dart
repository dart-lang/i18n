// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

sealed class Data {
  const Data();
}

final class AssetData extends Data {
  final String key;

  const AssetData(this.key);
}

final class BundleData extends Data {
  const BundleData();
}

final class NoData extends Data {
  const NoData();
}
