// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:build_daemon/client.dart';
import 'package:build_daemon/data/build_target.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) async {
  BuildDaemonClient client;
  final workingDirectory = p.normalize(Directory.current.path);

  try {
    // First we connect to the daemon. This will start one if one is not
    // currently running.
    client = await BuildDaemonClient.connect(
        workingDirectory,
        [
          'dart',
          'run',
          'build_runner',
          'daemon',
          '--delete-conflicting-outputs',
        ],
        logHandler: print);
  } catch (e) {
    if (e is VersionSkew) {
      print('Version skew. Please disconnect all other clients '
          'before trying to start a new one.');
    } else if (e is OptionsSkew) {
      print('Options skew. Please disconnect all other clients '
          'before trying to start a new one.');
    } else {
      print('Unexpected error: $e');
    }

    exit(1);
  }
  print('Connected to Dart Build Daemon');

  // Next we register a build target (directory) to build.
  // Note this will not cause a build to occur unless there are relevant file
  // changes.
  client.registerBuildTarget(DefaultBuildTarget((b) => b
    ..target = 'lib'
    ..blackListPatterns.replace([RegExp(r'.*(?<!\.arb|\.yaml)$')])));
  print('Registered target...');

  // Handle events coming from the daemon.
  client.buildResults.listen((status) => print('BUILD STATUS: $status'));

  await client.finished;
}
