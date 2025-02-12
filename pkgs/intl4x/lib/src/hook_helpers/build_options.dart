// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show JsonEncoder, json;
import 'dart:io';

import 'package:path/path.dart' as path;

final homeFolder = Platform.isWindows ? '%UserProfile%' : 'HOME';

File get configFile {
  final configPath =
      path.join(Platform.environment[homeFolder]!, 'intl4x.json');
  print('Setting config file at $configPath');
  return File(configPath);
}

Future<BuildOptions?> getBuildOptions() async {
  if (await configFile.exists()) {
    final contents = await configFile.readAsString();
    return BuildOptions.fromJson(contents);
  }
  return BuildOptions(buildMode: BuildModeEnum.fetch);
}

Future<void> writeBuildOptions(BuildOptions options) async {
  await configFile.create(recursive: true);
  await configFile.writeAsString(options.toJson());
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
      'localDylibPath': localDylibPath,
      'checkoutPath': checkoutPath,
    };
  }

  factory BuildOptions.fromMap(Map<String, dynamic> map) {
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
