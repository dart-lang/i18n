// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:intl4x/src/hook_helpers/build_options.dart';
import 'package:yaml_edit/yaml_edit.dart';

Future<void> main(List<String> args) async {
  final pubspecPath = args[0];
  final buildModeString = args[1];
  final pathString = args.length > 2 ? args[2] : null;
  final buildMode = BuildModeEnum.values.firstWhere(
    (mode) => mode.name == buildModeString,
  );
  final buildOptions = switch (buildMode) {
    BuildModeEnum.local => BuildOptions(
      buildMode: buildMode,
      localDylibPath: pathString,
    ),
    BuildModeEnum.checkout => BuildOptions(
      buildMode: buildMode,
      checkoutPath: pathString,
    ),
    BuildModeEnum.fetch => BuildOptions(buildMode: buildMode),
  };
  print('Writing build options: ${buildOptions.toJson()}');

  final pubspecContents = await File(pubspecPath).readAsString();
  final yamlEditor = YamlEditor(pubspecContents);
  yamlEditor.update(['hook'], {'intl4x': buildOptions.toMap()});
  await File(pubspecPath).writeAsString(yamlEditor.toString());
}
