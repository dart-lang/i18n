// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:native_assets_cli/native_assets_cli.dart';

void main(List<String> args) async {
  final buildConfig = await BuildConfig.fromArgs(args);
  final fileName = 'icu4x${Target.current.toString()}';

  final file = await downloadAsset(fileName, fileName);

  final asset = Asset(
    id: fileName,
    path: AssetRelativePath(file.uri),
    linkMode: LinkMode.dynamic,
    target: Target.current,
  );

  final buildOutput = BuildOutput(
    timestamp: DateTime.timestamp(),
    assets: [asset],
  );

  await buildOutput.writeToFile(outDir: buildConfig.outDir);
}

Future<File> downloadAsset(String fileName, String assetName) async {
  //TODO(mosum): Replace by upcoming pub.dev native assets feature.
  final request = await HttpClient().getUrl(Uri.parse(
      ' https://api.github.com/repos/dart-lang/intl4x/releases/assets/$assetName'));
  final response = await request.close();
  final file = File(fileName);
  if (!file.existsSync()) {
    await file.create();
  }
  await response.pipe(file.openWrite());
  return file;
}
