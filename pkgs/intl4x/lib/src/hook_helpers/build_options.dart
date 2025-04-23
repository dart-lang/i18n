// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show JsonEncoder;
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart' show YamlMap, loadYaml;

Future<BuildOptions?> getBuildOptions(String searchDir) async {
  final (map, dir) = await readOptionsFromPubspec(searchDir);
  print('Reading build options from $map');
  final buildOptions = BuildOptions.fromMap(map?['intl4x'] as Map? ?? {}, dir);
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
  final String? localDylibPath;
  final String? checkoutPath;
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
      if (localDylibPath != null) 'localDylibPath': localDylibPath,
      if (checkoutPath != null) 'checkoutPath': checkoutPath,
      if (treeshake != null) 'treeshake': treeshake.toString(),
    };
  }

  factory BuildOptions.fromMap(Map map, Directory dir) {
    final localPath = map['localDylibPath'] as String?;
    final checkoutPath = map['checkoutPath'] as String?;
    return BuildOptions(
      buildMode: BuildModeEnum.values.firstWhere(
        (element) => element.name == map['buildMode'],
      ),
      localDylibPath: localPath != null ? getPath(dir, localPath) : null,
      checkoutPath: checkoutPath != null ? getPath(dir, checkoutPath) : null,
      treeshake: map['treeshake'] == true,
    );
  }

  static String getPath(Directory dir, String p) =>
      path.canonicalize(path.absolute(dir.path, p));

  String toJson() => const JsonEncoder.withIndent('  ').convert(toMap());
}
