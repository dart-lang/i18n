// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/src/hook_helpers/build_options.dart';

Future<void> main(List<String> args) async {
  final buildModeString = args[0];
  final pathString = args.length > 1 ? args[1] : null;
  final buildMode =
      BuildModeEnum.values.firstWhere((mode) => mode.name == buildModeString);
  final buildOptions = switch (buildMode) {
    BuildModeEnum.local => BuildOptions(
        buildMode: buildMode,
        localDylibPath: pathString,
      ),
    BuildModeEnum.checkout => BuildOptions(
        buildMode: buildMode,
        checkoutPath: pathString,
      ),
    BuildModeEnum.fetch => BuildOptions(buildMode: buildMode)
  };
  print('Writing build options: ${buildOptions.toJson()}');
  await writeBuildOptions(buildOptions);
}
