// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show JsonEncoder, json;
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart' show YamlMap, loadYaml;

Future<BuildOptions?> getBuildOptions(String searchDir) async {
  final map = await readOptionsFromPubspec(searchDir);
  print('Reading build options from $map');
  final buildOptions = BuildOptions.fromMap(map?['intl4x'] as Map? ?? {});
  print('Got build options: ${buildOptions.toJson()}');
  return buildOptions;
}

Future<YamlMap?> readOptionsFromPubspec(String searchPath) async {
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
  return pubspecYaml['hook'] as YamlMap?;
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

  factory BuildOptions.fromMap(Map map) {
    return BuildOptions(
      buildMode: BuildModeEnum.values.firstWhere(
        (element) => element.name == map['buildMode'],
      ),
      localDylibPath: map['localDylibPath'] as String?,
      checkoutPath: map['checkoutPath'] as String?,
      treeshake: map['treeshake'] == true,
    );
  }

  String toJson() => const JsonEncoder.withIndent('  ').convert(toMap());

  factory BuildOptions.fromJson(String source) =>
      BuildOptions.fromMap(json.decode(source) as Map<String, dynamic>);
}
