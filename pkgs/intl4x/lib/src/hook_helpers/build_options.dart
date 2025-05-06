// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show JsonEncoder;
import 'dart:io';

// ignore: implementation_imports
import 'package:collection/collection.dart';
import 'package:hooks/hooks.dart' show HookInputUserDefines;
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart' show YamlMap, loadYaml;

Future<BuildOptions> getBuildOptions(HookInputUserDefines userDefines) async {
  final buildOptions = BuildOptions.fromDefines(userDefines);
  print('Got build options: ${buildOptions.toJson()}');
  return buildOptions;
}

Future<(YamlMap?, Directory)> readOptionsFromPubspec(String searchPath) async {
  File pubspec(Directory dir) => File(path.join(dir.path, 'pubspec.yaml'));

  var directory = Directory(searchPath);
  var counter = 0;
  while (!pubspec(directory).existsSync()) {
    directory = directory.parent;
    counter++;
    if (counter > 10) {
      throw ArgumentError('Could not find pubspec at $searchPath');
    }
  }

  final pubspecYaml =
      loadYaml(pubspec(directory).readAsStringSync()) as YamlMap;
  return (pubspecYaml['hook'] as YamlMap?, directory);
}

enum BuildModeEnum { local, checkout, fetch }

class BuildOptions {
  final BuildModeEnum buildMode;
  final Uri? localDylibPath;
  final Uri? checkoutPath;
  final bool? treeshake;

  BuildOptions({
    required this.buildMode,
    this.localDylibPath,
    this.checkoutPath,
    this.treeshake,
  });

  Map<String, dynamic> toMap() {
    return {
      'buildMode': buildMode.name,
      if (localDylibPath != null) 'localDylibPath': localDylibPath.toString(),
      if (checkoutPath != null) 'checkoutPath': checkoutPath.toString(),
      if (treeshake != null) 'treeshake': treeshake.toString(),
    };
  }

  factory BuildOptions.fromDefines(HookInputUserDefines defines) {
    return BuildOptions(
      buildMode:
          BuildModeEnum.values.firstWhereOrNull(
            (element) => element.name == defines['buildMode'],
          ) ??
          BuildModeEnum.fetch,
      localDylibPath: defines.path('localDylibPath'),
      checkoutPath: defines.path('checkoutPath'),
      treeshake: (defines['treeshake'] ?? true) == true,
    );
  }

  static String getPath(Directory dir, String p) =>
      path.canonicalize(path.absolute(dir.path, p));

  String toJson() => const JsonEncoder.withIndent('  ').convert(toMap());
}
