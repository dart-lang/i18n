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

  final libFolder = path.join(config.outDir.path, folder);
  final libPath = path.join(
    libFolder,
    'lib${crateName.replaceAll("-", "_")}.$dynamicLibraryExtension',
  );

  final buildMode = switch (Platform.environment['ICU4X_BUILD_MODE']) {
    'fetch' => FetchMode(libPath),
    'local' => LocalMode(libPath),
    'checkout' => CheckoutMode(config.outDir.path),
    String() => throw ArgumentError('Unknown build mode for icu4x'),
    null => throw ArgumentError('''


Missing build mode for icu4x. Set the `ICU4X_BUILD_MODE` environment variable with either `fetch`, `local`, or `checkout`.
* fetch: Fetch the precompiled binary from a CDN.
* local: Use a locally existing binary at the environment variable `LOCAL_ICU4X_BINARY`.
* checkout: Build a fresh library from a local git checkout of the icu4x repository at the environment variable `LOCAL_ICU4X_CHECKOUT`.

'''),
  };

  await buildMode.build();

  await BuildOutput(
    assets: [
      Asset(
        id: assetId,
        linkMode: LinkMode.dynamic,
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

sealed class BuildMode {
  Future<void> build();
}

final class FetchMode implements BuildMode {
  final String libPath;

  FetchMode(this.libPath);

  @override
  Future<void> build() async {
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
  }
}

final class LocalMode implements BuildMode {
  final String libPath;

  LocalMode(this.libPath);

  String get _localBinaryPath => Platform.environment['LOCAL_ICU4X_BINARY']!;

  @override
  Future<void> build() async {
    await File(_localBinaryPath).copy(libPath);
  }
}

final class CheckoutMode implements BuildMode {
  final String outDirPath;
  CheckoutMode(this.outDirPath);

  @override
  Future<void> build() async {
    final arguments = [
      'rustc',
      '-p',
      crateName,
      '--crate-type=cdylib',
      if (release) '--release',
      ...['--target-dir', outDirPath],
    ];
    final processResult = await Process.run(
      'cargo',
      arguments,
      workingDirectory: Platform.environment['LOCAL_ICU4X_CHECKOUT']!,
    );
    if (processResult.exitCode != 0) {
      throw ProcessException(
        'cargo',
        arguments,
        processResult.stderr.toString(),
      );
    }
  }
}
