// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:native_assets_cli/native_assets_cli.dart';

void main(List<String> args) async {
  final buildConfig = await BuildConfig.fromArgs(args);
  final fileName = 'icu4x${Target.current.toString()}';
  final shouldCompile = buildConfig.config.bool('compile');

  File library;
  if (shouldCompile) {
    library = await compileAsset(buildConfig.target, fileName);
  } else {
    library = await downloadAsset(fileName, fileName);
  }
  final libraryAsset = Asset(
    id: fileName,
    path: AssetRelativePath(library.uri),
    linkMode: LinkMode.dynamic,
    target: Target.current,
  );

  final buildOutput = BuildOutput(
    timestamp: DateTime.timestamp(),
    assets: [libraryAsset],
  );

  await buildOutput.writeToFile(outDir: buildConfig.outDir);
}

Future<File> compileAsset(Target target, String fileName) async {
  //TODO: add https://rust-lang.github.io/rustup/cross-compilation.html
  final file = File(fileName);
  await file.create();
  const icuDatagen = IcuDatagen(
    keys: [
      'datetime/japanese/datesymbols@1',
      'datetime/gregory/datelengths@1',
      'datetime/timelengths@1',
      'decimal/symbols@1'
    ],
    locales: ['ja'],
  );
  final dataGenerationProcess = await icuDatagen.runDataGeneration();

  throwOnError(dataGenerationProcess, 'icu4x-datagen', [icuDatagen.toString()]);

  final processResult = await Process.run('cargo', [
    'build',
    '--release',
  ]);
  throwOnError(processResult, 'cargo', ['build', '--release']);

  return file;
}

void throwOnError(ProcessResult dataGenerationProcess, String executable,
    List<String> arguments) {
  if (dataGenerationProcess.exitCode != 0) {
    throw ProcessException(executable, arguments, 'Error running $executable');
  }
}

Future<File> downloadAsset(String fileName, String assetName) async {
  //TODO(mosum): Replace by upcoming pub.dev native assets feature.
  final request = await HttpClient().getUrl(Uri.parse(
      ' https://api.github.com/repos/dart-lang/intl4x/releases/assets/$assetName'));
  final response = await request.close();
  final file = File(fileName);
  if (!file.existsSync()) {
    await file.create();
  }
  await response.pipe(file.openWrite());
  return file;
}

class IcuDatagen {
  final List<String> keys;
  final List<String> locales;
  final Format format;

  const IcuDatagen({
    required this.keys,
    required this.locales,
    this.format = Format.mod,
  });

  Future<ProcessResult> runDataGeneration() async {
    final processResult =
        await Process.run('cargo', ['install', 'icu_datagen']);

    throwOnError(processResult, 'cargo', ['install', 'icu_datagen']);

    return Process.run('icu4x-datagen', [
      '--keys',
      ...keys,
      '--locales',
      ...locales,
      '--format',
      format.name,
      '--out',
      'my_data_blob.postcard',
      '--overwrite',
    ]);
  }

  @override
  String toString() =>
      'IcuDatagen(keys: $keys, locales: $locales, format: $format)';
}

enum Format {
  dir,
  blob,
  mod,
}
