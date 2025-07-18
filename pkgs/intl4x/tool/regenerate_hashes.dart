// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:code_assets/code_assets.dart' show Architecture;
import 'package:crypto/crypto.dart';
import 'package:intl4x/src/hook_helpers/version.dart';

Future<void> main(List<String> args) async {
  final httpClient = HttpClient();

  print('Checking hashes for $version');
  final fileHashes = <(String, Architecture, String), String>{};
  final dynamicLibrary = File.fromUri(Directory.systemTemp.uri.resolve('lib'));
  await dynamicLibrary.create();
  for (final os in ['linux', 'windows', 'fuchsia', 'android', 'macOS', 'iOS']) {
    for (final architecture in Architecture.values) {
      for (final libraryType in ['dynamic', 'static', 'static_data']) {
        final target = [os, architecture, libraryType].join('_');
        print('Checking hash for $target');
        final success = await _fetchLibrary(target, httpClient, dynamicLibrary);
        if (success) {
          final bytes = await dynamicLibrary.readAsBytes();
          final fileHash = sha256.convert(bytes).toString();
          fileHashes[(os, architecture, libraryType)] = fileHash;
          print('Hash is $fileHash');
        } else {
          print('Could not fetch library');
        }
      }
    }
  }
  httpClient.close(force: true);

  await File('lib/src/hook_helpers/hashes.dart').writeAsString('''
// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// THIS FILE IS AUTOGENERATED BY `tool/regenerate_hashes.dart`. TO UPDATE, RUN
//
//    dart tool/regenerate_hashes.dart
//

import 'package:code_assets/code_assets.dart' show Architecture, OS;

const fileHashes = <(OS, Architecture, String), String>{
${fileHashes.map((key, value) => MapEntry(('OS.${key.$1}', 'Architecture.${key.$2}', "'${key.$3}'"), "'$value'")).entries.map((e) => '  ${e.key}:\n      ${e.value},').join('\n')}
};
''');
}

Future<bool> _fetchLibrary(
  String target,
  HttpClient httpClient,
  File dynamicLibrary,
) async {
  final uri = Uri.parse(
    'https://github.com/dart-lang/i18n/releases/download/$version/$target',
  );
  print('Fetch file from $uri');
  final request = await httpClient.getUrl(uri);
  final response = await request.close();
  if (response.statusCode != 200) {
    print('File not found at $uri');
    return false;
  }
  await response.pipe(dynamicLibrary.openWrite());
  return true;
}
