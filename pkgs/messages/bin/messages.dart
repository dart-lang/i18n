// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

Future<void> main(List<String> args) async {
  final runBuilder = await Process.run('dart', ['run', 'messages_builder']);
  stdout.write(runBuilder.stdout as String);

  final runBuilderStdErr = runBuilder.stderr as String;
  final messagesBuilderNotInDeps =
      runBuilderStdErr.contains('Could not find package `messages_builder`');
  if (messagesBuilderNotInDeps) {
    print('Adding `package:messages_builder` to dev dependencies...');
    final addBuilder = await runDart(['pub', 'add', 'dev:messages_builder']);
    if (addBuilder.exitCode == 0) {
      print('Re-running message generation');
      await runDart(['run', 'messages_builder']);
    }
  } else {
    stderr.write(runBuilderStdErr);
  }
}

Future<ProcessResult> runDart(List<String> arguments) async {
  final processResult = await Process.run('dart', arguments);
  stdout.write(processResult.stdout as String);
  stderr.write(processResult.stderr as String);
  return processResult;
}
