import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:native_assets_cli/native_assets_cli.dart';

import '../hook/version.dart';

final httpClient = HttpClient();

Future<void> main(List<String> args) async {
  print('Checking hashes for $version');
  final fileHashes = <(OS, Architecture), String>{};
  final dynamicLibrary = File.fromUri(Directory.systemTemp.uri.resolve('lib'));
  await dynamicLibrary.create();
  for (final os in OS.values) {
    for (final architecture in Architecture.values) {
      final target = '${os}_$architecture';
      print('Checking hash for $target');
      final success = await _fetchLibrary(target, httpClient, dynamicLibrary);
      if (success) {
        final bytes = await dynamicLibrary.readAsBytes();
        final fileHash = sha256.convert(bytes).toString();
        fileHashes[(os, architecture)] = fileHash;
        print('Hash is $fileHash');
      } else {
        print('Could not fetch library');
      }
    }
  }
  httpClient.close(force: true);

  await File('hook/hashes.dart').writeAsString('''
// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// THIS FILE IS AUTOGENERATED BY `tool/regenerate_hashes.dart`. TO UPDATE, RUN
//
//    dart --enable-experiment=native-assets run tool/regenerate_hashes.dart
//

import 'package:native_assets_cli/native_assets_cli.dart';

const fileHashes = <(OS, Architecture), String>{
${fileHashes.map((key, value) => MapEntry(
                ('OS.${key.$1.varName}', 'Architecture.${key.$2}'),
                "'$value'",
              )).entries.map(
            (e) => '  ${e.key}:\n      ${e.value}',
          ).join(',\n')}
};
''');
}

Future<bool> _fetchLibrary(
    String target, HttpClient httpClient, File dynamicLibrary) async {
  final uri = Uri.parse(
      'https://github.com/dart-lang/i18n/releases/download/$version/$target');
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

extension OSExt on OS {
  String get varName => switch (this) {
        OS.linux => 'linux',
        OS.windows => 'windows',
        OS.fuchsia => 'fuchsia',
        OS.android => 'android',
        OS.macOS => 'macOS',
        OS.iOS => 'iOS',
        OS() => throw UnimplementedError(),
      };
}
