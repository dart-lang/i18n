// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:native_assets_cli/native_assets_cli.dart';

const package = 'example_json';
void main(List<String> args) {
  final dir = 'lib/';
  build(args, (config, output) async {
    getArbs(config, output, dir, [
      'testarb',
      'testarbctx2',
      'testarbctx2_fr',
    ]);
  });
}

void getArbs(
  BuildConfig config,
  BuildOutput output,
  String dir,
  List<String> assets,
) {
  output.addAssets(assets.map((asset) => getArb(config, dir, asset)));
  output.addDependencies([
    config.packageRoot.resolve('hook/build.dart'),
  ]);
}

DataAsset getArb(BuildConfig config, String dir, String name) {
  final directory = Directory(dir);
  final resolved = directory.uri.resolve('$name.json');
  return DataAsset(
    package: package,
    name: resolved.path,
    file: config.packageRoot.resolveUri(resolved),
  );
}
