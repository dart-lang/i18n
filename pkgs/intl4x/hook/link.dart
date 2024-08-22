// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:intl4x/src/hook_helpers/locales.dart';
import 'package:intl4x/src/hook_helpers/shared.dart';
import 'package:logging/logging.dart';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

// TODO(mosuem): Use `record_use` to automagically get the used symbols.
const usedSymbols = <String>[
  'diplomat_buffer_writeable_create',
  'diplomat_buffer_writeable_get_bytes',
  'diplomat_buffer_writeable_len',
  'diplomat_buffer_writeable_destroy',
  'ICU4XCollator_create_v1',
  'ICU4XCollator_compare_utf16_',
  'ICU4XDataProvider_create_compiled',
  'ICU4XDataProvider_create_empty',
  'ICU4XLocale_create_und',
  'ICU4XLocale_set_language',
  'ICU4XLocale_set_region',
  'ICU4XLocale_set_script',
  'ICU4XLocale_to_string',
  'ICU4XLocale_total_cmp_',
  //additional
  'ICU4XDataProvider_create_compiled',
  'ICU4XDataProvider_destroy',
  'ICU4XLocale_destroy',
  'ICU4XCollator_destroy',
];

void main(List<String> arguments) {
  link(
    arguments,
    (config, output) async {
      final staticLib = config.assets
          .firstWhereOrNull((asset) => asset.id == 'package:$package/$assetId');
      if (staticLib == null) {
        // No static lib built, so assume a dynamic one was already bundled.
        return;
      }

      final linker = CLinker.library(
        name: config.packageName,
        assetName: assetId,
        sources: [staticLib.file!.path],
        linkerOptions: LinkerOptions.treeshake(symbols: usedSymbols),
      );

      await linker.run(
        config: config,
        output: output,
        logger: Logger('')
          ..level = Level.ALL
          ..onRecord.listen((record) => print(record.message)),
      );

      final postcard =
          config.assets.firstWhere((asset) => asset.id.endsWith('postcard'));
      final datagenTool =
          config.assets.firstWhere((asset) => asset.id.endsWith('datagen'));
      final dylib = output.assets.first;

      await Process.run(datagenTool.file!.toFilePath(), [
        '--locales',
        (await _customLocales ?? locales).join(','),
        '--input',
        postcard.file!.toFilePath(),
        '--keys-for-bin',
        dylib.file!.toFilePath(),
      ]);
    },
  );
}

Future<List<String>?> get _customLocales async {
  final localPath = Platform.environment['ICU4X_LOCALE_LIST'];
  if (localPath != null) {
    final file = File(localPath);
    if (await file.exists()) {
      return file.readAsLines();
    }
  }
  return null;
}
