// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:logging/logging.dart';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:path/path.dart' as p;

// implements Builder
class MessageBuilder {
  final List<String> arbFiles;
  final List<String> locales;

  MessageBuilder({
    required this.arbFiles,
    required this.locales,
  });

  Future<void> run({
    required BuildConfig config,
    required BuildOutput output,
    required Logger? logger,
  }) async {
    DataAsset fileToAsset(String relativePath) => DataAsset(
          package: config.packageName,
          name: relativePath,
          file: config.packageRoot.resolve(relativePath),
        );

    for (final arb in arbFiles) {
      final arbNoExtension = p.withoutExtension(arb);
      for (final locale in locales) {
        final data = p.setExtension(arbNoExtension, '_$locale.json');
        final asset = fileToAsset(data);
        if (await File.fromUri(asset.file!).exists()) {
          output.addAsset(asset);
        } else {
          logger?.warning('Could not find messages for locale "$locale" and'
              ' arb "$arb" at ${asset.file}');
        }
      }
    }

    output.addDependencies([
      ...arbFiles,
      'hook/build.dart',
    ].map(config.packageRoot.resolve));
  }
}
