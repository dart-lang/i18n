// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:path/path.dart' as path;

const crateName = 'icu_capi';
const assetId = 'package:intl4x/src/bindings/lib.g.dart';

void main(List<String> args) async {
  final config = await BuildConfig.fromArgs(args);

  final libFolder = path.join(config.outDir.path, 'release');
  Directory(libFolder).createSync();
  final libPath = path.join(
    libFolder,
    config.targetOs.dylibFileName(crateName.replaceAll('-', '_')),
  );

  final buildMode = switch (Platform.environment['ICU4X_BUILD_MODE']) {
    'local' => LocalMode(libPath),
    'checkout' => CheckoutMode(config, libPath),
    'fetch' || null => FetchMode(libPath),
    String() => throw ArgumentError('''


Unknown build mode for icu4x. Set the `ICU4X_BUILD_MODE` environment variable with either `fetch`, `local`, or `checkout`.
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
    // TODO: Get a nicer CDN than a generated link to a privately owned repo.
    final request = await HttpClient().getUrl(Uri.parse(
        'https://nightly.link/mosuem/i18n/workflows/intl4x_artifacts/main/lib-${Platform.operatingSystem}-latest.zip'));
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
  final BuildConfig config;
  final String libPath;
  CheckoutMode(this.config, this.libPath);

  @override
  Future<void> build() async {
    final workingDirectory = Platform.environment['LOCAL_ICU4X_CHECKOUT'];
    if (workingDirectory == null) {
      throw ArgumentError('Specify the ICU4X checkout folder'
          'with the LOCAL_ICU4X_CHECKOUT variable');
    }
    final lib = await buildLib(
      config,
      workingDirectory,
    );
    await File(lib).copy(libPath);
  }
}

Future<String> buildLib(
  BuildConfig config,
  String workingDirectory,
) async {
  final rustTarget =
      config.target.asRustTarget(config.targetIOSSdk == IOSSdk.iPhoneSimulator);
  final isNoStd = config.target.isNoStdTarget;

  if (!isNoStd) {
    final rustArguments = ['target', 'add', rustTarget];
    final rustup = await Process.run(
      'rustup',
      rustArguments,
      workingDirectory: workingDirectory,
    );

    if (rustup.exitCode != 0) {
      throw ProcessException(
        'rustup',
        rustArguments,
        rustup.stderr.toString(),
        rustup.exitCode,
      );
    }
  }

  final stdFeatures = [
    'default_components',
    'compiled_data',
    'buffer_provider',
    'logging',
    'simple_logger',
  ];
  final noStdFeatures = [
    'default_components',
    'compiled_data',
    'buffer_provider',
    'libc-alloc',
    'panic-handler'
  ];
  final tempDir = Directory.systemTemp.createTempSync();
  final linkModeType =
      config.linkModePreference.preferredLinkMode == LinkMode.static
          ? 'staticlib'
          : 'cdylib';
  final arguments = [
    if (isNoStd) '+nightly',
    'rustc',
    '-p={crateName}',
    '--crate-type=$linkModeType',
    '--release',
    '--config=profile.release.panic="abort"',
    '--config=profile.release.codegen-units=1',
    '--no-default-features',
    if (!isNoStd) '--features=${stdFeatures.join(',')}',
    if (isNoStd) '--features=${noStdFeatures.join(',')}',
    if (isNoStd) '-Zbuild-std=core,alloc',
    if (isNoStd) '-Zbuild-std-features=panic_immediate_abort',
    '--target=$rustTarget',
    '--target-dir=${tempDir.path}'
  ];
  final cargo = await Process.run(
    'cargo',
    arguments,
    workingDirectory: workingDirectory,
  );

  if (cargo.exitCode != 0) {
    throw ProcessException(
      'cargo',
      arguments,
      cargo.stderr.toString(),
      cargo.exitCode,
    );
  }

  final dylibFilePath = path.join(
    tempDir.path,
    rustTarget,
    'release',
    config.target.os.dylibFileName('icu_capi'),
  );
  if (!File(dylibFilePath).existsSync()) {
    throw FileSystemException('Building the dylib failed', dylibFilePath);
  }
  return dylibFilePath;
}

extension on Target {
  String asRustTarget(bool isSimulator) {
    if (this == Target.iOSArm64 && isSimulator) {
      return 'aarch64-apple-ios-sim';
    }
    return switch (this) {
      Target.androidArm => 'armv7-linux-androideabi',
      Target.androidArm64 => 'aarch64-linux-android',
      Target.androidIA32 => 'i686-linux-android',
      Target.androidRiscv64 => 'riscv64-linux-android',
      Target.androidX64 => 'x86_64-linux-android',
      Target.fuchsiaArm64 => 'aarch64-unknown-fuchsia',
      Target.fuchsiaX64 => 'x86_64-unknown-fuchsia',
      Target.iOSArm64 => 'aarch64-apple-ios',
      Target.iOSX64 => 'x86_64-apple-ios',
      Target.linuxArm => 'armv7-unknown-linux-gnueabihf',
      Target.linuxArm64 => 'aarch64-unknown-linux-gnu',
      Target.linuxIA32 => 'i686-unknown-linux-gnu',
      Target.linuxRiscv32 => 'riscv32gc-unknown-linux-gnu',
      Target.linuxRiscv64 => 'riscv64gc-unknown-linux-gnu',
      Target.linuxX64 => 'x86_64-unknown-linux-gnu',
      Target.macOSArm64 => 'aarch64-apple-darwin',
      Target.macOSX64 => 'x86_64-apple-darwin',
      Target.windowsArm64 => 'aarch64-pc-windows-msvc',
      Target.windowsIA32 => 'i686-pc-windows-msvc',
      Target.windowsX64 => 'x86_64-pc-windows-msvc',
      Target() => throw UnimplementedError('Target not available for rust'),
    };
  }

  bool get isNoStdTarget =>
      [Target.androidRiscv64, Target.linuxRiscv32].contains(this);
}
