// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

const package = 'intl4x';
const assetId = 'src/bindings/lib.g.dart';

Future<void> runProcess(
  String executable,
  List<String> arguments, {
  String? workingDirectory,
  bool dryRun = false,
}) async {
  print('----------');
  print('Running `$executable $arguments` in $workingDirectory');
  if (!dryRun) {
    final processResult = await Process.run(
      executable,
      arguments,
      workingDirectory: workingDirectory,
    );
    print('stdout:');
    print(processResult.stdout);
    if ((processResult.stderr as String).isNotEmpty) {
      print('stderr:');
      print(processResult.stderr);
    }
    if (processResult.exitCode != 0) {
      throw ProcessException(executable, arguments, '', processResult.exitCode);
    }
  } else {
    print('Not running, as --dry-run is set.');
  }
  print('==========');
}
