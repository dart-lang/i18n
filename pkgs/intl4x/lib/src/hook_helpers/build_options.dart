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
  final buildOptions =
      // ignore: avoid_dynamic_calls
      BuildOptions.fromMap(map['intl4x'] as Map? ?? {});
  print('Got build options: ${buildOptions.toJson()}');
  return buildOptions;
}

Future<Map> readOptionsFromPubspec(String searchPath) async {
  File pubspec(Directory dir) => File(path.join(dir.path, 'pubspec.yaml'));

  var directory = Directory(searchPath);
  while (!pubspec(directory).existsSync()) {
    directory = directory.parent;
  }

  // ignore: avoid_dynamic_calls
  return loadYaml(pubspec(directory).readAsStringSync())['hook'] as YamlMap;
}

enum BuildModeEnum {
  local,
  checkout,
  fetch,
}

class BuildOptions {
  final BuildModeEnum buildMode;
  final String? localDylibPath;
  final String? checkoutPath;

  BuildOptions({
    required this.buildMode,
    this.localDylibPath,
    this.checkoutPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'buildMode': buildMode.name,
      if (localDylibPath != null) 'localDylibPath': localDylibPath,
      if (checkoutPath != null) 'checkoutPath': checkoutPath,
    };
  }

  factory BuildOptions.fromMap(Map map) {
    return BuildOptions(
      buildMode: BuildModeEnum.values
          .firstWhere((element) => element.name == map['buildMode']),
      localDylibPath: map['localDylibPath'] as String?,
      checkoutPath: map['checkoutPath'] as String?,
    );
  }

  String toJson() => const JsonEncoder.withIndent('  ').convert(toMap());

  factory BuildOptions.fromJson(String source) =>
      BuildOptions.fromMap(json.decode(source) as Map<String, dynamic>);
}
