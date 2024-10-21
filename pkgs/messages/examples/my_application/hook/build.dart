// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:logging/logging.dart';
import 'package:messages_builder/hook.dart';
import 'package:native_assets_cli/native_assets_cli.dart';

void main(List<String> args) {
  build(args, (config, output) async {
    final builder = MessagesDataBuilder.fromFolder('assets/l10n/');

    final assets = await builder.run(
      config: config,
      output: output,
      logger: Logger('')
        ..onRecord.listen((event) => stdout.add(event.toString().codeUnits)),
    );

    for (final asset in assets) {
      final outputPath = config.packageRoot.resolve(asset.name);
      final file = File.fromUri(outputPath);
      await file.create();
      await File.fromUri(asset.file!).copy(file.path);
    }
  });
}
