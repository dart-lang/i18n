// This file is part of ICU4X. For terms of use, please see the file
// called LICENSE at the top level of the ICU4X source tree
// (online at: https://github.com/unicode-org/icu4x/blob/main/LICENSE ).

import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:path/path.dart' as path;

const crateName = 'icu_capi';
const release = true;
const assetId = 'package:intl4x/src/bindings/lib.g.dart';

void main(List<String> args) async {
  final config = await BuildConfig.fromArgs(args);
  final runMode = Platform.environment['MODE']!;

  final libPath =
      '${config.outDir.path}/$folder/lib${crateName.replaceAll("-", "_")}.$dynamicLibraryExtension';
  if (runMode == 'fetch') {
    final request = await HttpClient().getUrl(Uri.parse(
        'https://nightly.link/mosuem/i18n/workflows/intl4x_artifacts/main/lib-$platformName-latest.zip'));
    final response = await request.close();

    final zippedDynamicLibrary =
        File(path.join(Directory.systemTemp.path, 'tmp.zip'));
    zippedDynamicLibrary.createSync();
    await response.pipe(zippedDynamicLibrary.openWrite());

    final dynamicLibrary = File(libPath);
    dynamicLibrary.createSync(recursive: true);
    unzipFirstFile(input: zippedDynamicLibrary, output: dynamicLibrary);
  } else {
    await Process.run(
      'cargo',
      [
        'rustc',
        '-p',
        crateName,
        '--crate-type=cdylib',
        if (release) '--release',
      ],
      environment: {'CARGO_TARGET_DIR': config.outDir.path},
    );
  }

  await BuildOutput(
    assets: [
      Asset(
        id: assetId,
        linkMode: LinkMode.static,
        target: Target.current,
        path: AssetAbsolutePath(Uri.file(libPath)),
      )
    ],
    dependencies: Dependencies([Uri.file('build.dart')]),
  ).writeToFile(outDir: config.outDir);
}

String get folder => release ? 'release' : 'debug';

String get dynamicLibraryExtension {
  if (Platform.isMacOS) {
    return 'dylib';
  } else if (Platform.isWindows) {
    return 'dll';
  } else {
    return 'so';
  }
}

String get platformName {
  if (Platform.isMacOS) {
    return 'macos';
  } else if (Platform.isWindows) {
    return 'windows';
  } else {
    return 'ubuntu';
  }
}

void unzipFirstFile({required File input, required File output}) {
  final inputStream = InputFileStream(input.path);
  final archive = ZipDecoder().decodeBuffer(inputStream);
  final file = archive.files.firstOrNull;
  // If it's a file and not a directory
  if (file?.isFile ?? false) {
    final outputStream = OutputFileStream(output.path);
    file!.writeContent(outputStream);
    outputStream.close();
  }
}
