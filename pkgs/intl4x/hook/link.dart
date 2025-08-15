// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:code_assets/code_assets.dart'
    show HookConfigCodeConfig, LinkInputCodeAssets, OS;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:hooks/hooks.dart' show LinkInput, link;
import 'package:intl4x/src/hook_helpers/shared.dart' show assetId, package;
import 'package:logging/logging.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';
import 'package:record_use/record_use.dart' as record_use;

import 'identifiers.g.dart';

/// Run the linker to turn a static into a treeshaken dynamic library.
Future<void> main(List<String> args) async {
  await link(args, (input, output) async {
    print('Start linking');
    final staticLib = input.assets.code.firstWhereOrNull(
      (asset) => asset.id == 'package:$package/$assetId',
    );
    if (staticLib == null) {
      // No static lib built, so assume a dynamic one was already bundled.
      return;
    }

    output.addDependency(staticLib.file!);

    final usages = input.usages;

    final usedSymbols = usages
        ?.constantsOf(diplomatFfiUseIdentifier)
        .map((instance) => instance['symbol'] as String);

    print('''
### Using symbols:
${usedSymbols?.join('\n')}
### End using symbols
''');

    await CLinker.library(
      name: input.packageName,
      assetName: assetId,
      sources: [staticLib.file!.toFilePath()],
      libraries:
          // On Windows, icu4x.lib is lacking /DEFAULTLIB directives to advise
          // the linker on what libraries to link against. To make up for that,
          // the libraries used have to be provided to the linker explicitly.
          input.config.code.targetOS == OS.windows
              ? const ['MSVCRT', 'ws2_32', 'userenv', 'ntdll']
              : const [],
      linkerOptions: LinkerOptions.treeshake(symbolsToKeep: usedSymbols),
    ).run(
      input: input,
      output: output,
      logger:
          Logger('')
            ..level = Level.ALL
            ..onRecord.listen((record) => print(record.message)),
    );
  });
}

extension on LinkInput {
  record_use.RecordedUsages? get usages {
    if (recordedUsagesFile == null) {
      return null;
    }
    final usagesContent = File.fromUri(recordedUsagesFile!).readAsStringSync();
    final usagesJson = jsonDecode(usagesContent) as Map<String, dynamic>;
    return record_use.RecordedUsages.fromJson(usagesJson);
  }
}
