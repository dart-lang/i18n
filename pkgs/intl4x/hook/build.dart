// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:path/path.dart' as path;

const crateName = 'icu_capi';
const package = 'intl4x';
const assetId = 'src/bindings/lib.g.dart';

void main(List<String> args) async {
  await build(args, (config, output) async {
    final buildMode = switch (Platform.environment['ICU4X_BUILD_MODE']) {
      'local' => LocalMode(),
      'checkout' => CheckoutMode(config),
      'fetch' || null => FetchMode(config),
      String() => throw ArgumentError('''


Unknown build mode for icu4x. Set the `ICU4X_BUILD_MODE` environment variable with either `fetch`, `local`, or `checkout`.
* fetch: Fetch the precompiled binary from a CDN.
* local: Use a locally existing binary at the environment variable `LOCAL_ICU4X_BINARY`.
* checkout: Build a fresh library from a local git checkout of the icu4x repository at the environment variable `LOCAL_ICU4X_CHECKOUT`.

'''),
    };

    final builtLibrary = await buildMode.build();

    output.addAsset(NativeCodeAsset(
      package: package,
      name: assetId,
      linkMode: DynamicLoadingBundled(),
      architecture: config.targetArchitecture,
      os: config.targetOS,
      file: builtLibrary,
    ));

    output.addDependencies(
      [
        ...buildMode.dependencies,
        config.packageRoot.resolve('hook/build.dart'),
        //TODO: Fix this, currently causes a rebuild for checkout mode
        //builtLibrary,
      ],
    );
  });
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
  List<Uri> get dependencies;

  Future<Uri> build();
}

final class FetchMode implements BuildMode {
  final BuildConfig config;

  FetchMode(this.config);

  @override
  Future<Uri> build() async {
    // TODO: Get a nicer CDN than a generated link to a privately owned repo.
    final uri = Uri.parse(
        'https://nightly.link/mosuem/i18n/workflows/intl4x_artifacts/main/lib-$platformName-latest.zip');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();
    if (response.statusCode != 200) {
      throw ArgumentError('The request to $uri failed');
    }
    final zippedDynamicLibrary =
        File(path.join(Directory.systemTemp.path, 'tmp.zip'));
    zippedDynamicLibrary.createSync();
    await response.pipe(zippedDynamicLibrary.openWrite());

    final dynamicLibrary =
        File.fromUri(config.outputDirectory.resolve('icu4xlib'));
    await dynamicLibrary.create();
    unzipFirstFile(input: zippedDynamicLibrary, output: dynamicLibrary);
    return dynamicLibrary.uri;
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

  @override
  List<Uri> get dependencies => [];
}

final class LocalMode implements BuildMode {
  String get _localBinaryPath => Platform.environment['LOCAL_ICU4X_BINARY']!;

  @override
  Future<Uri> build() async => Uri.file(_localBinaryPath);

  @override
  List<Uri> get dependencies => [Uri.file(_localBinaryPath)];
}

final class CheckoutMode implements BuildMode {
  final BuildConfig config;

  CheckoutMode(this.config);

  String? get workingDirectory => Platform.environment['LOCAL_ICU4X_CHECKOUT'];

  @override
  Future<Uri> build() async {
    if (workingDirectory == null) {
      throw ArgumentError('Specify the ICU4X checkout folder'
          'with the LOCAL_ICU4X_CHECKOUT variable');
    }
    return await buildLib(config, workingDirectory!);
  }

  @override
  List<Uri> get dependencies => [
        Uri.directory(workingDirectory!).resolve('Cargo.lock'),
      ];
}

Future<Uri> buildLib(BuildConfig config, String workingDirectory) async {
  final dylibFileName =
      config.targetOS.dylibFileName(crateName.replaceAll('-', '_'));
  final dylibFileUri = config.outputDirectory.resolve(dylibFileName);
  if (!config.dryRun) {
    final rustTarget = _asRustTarget(
      config.targetOS,
      config.dryRun ? null : config.targetArchitecture!,
      config.targetOS == OS.iOS &&
          config.targetIOSSdk == IOSSdk.iPhoneSimulator,
    );
    final isNoStd =
        _isNoStdTarget((config.targetOS, config.targetArchitecture));

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
    final tempDir = await Directory.systemTemp.createTemp();

    final stdFeatures = [
      'default_components',
      'compiled_data',
      'buffer_provider',
      'logging',
      'simple_logger',
      'experimental_components',
    ];
    final noStdFeatures = [
      'default_components',
      'compiled_data',
      'buffer_provider',
      'libc-alloc',
      'panic-handler',
      'experimental_components',
    ];
    final linkModeType = config.linkModePreference == LinkModePreference.static
        ? 'staticlib'
        : 'cdylib';
    final arguments = [
      if (isNoStd) '+nightly',
      'rustc',
      '-p=$crateName',
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

    final builtPath = path.join(
      tempDir.path,
      rustTarget,
      'release',
      dylibFileName,
    );
    final file = File(builtPath);
    if (!(await file.exists())) {
      throw FileSystemException('Building the dylib failed', builtPath);
    }
    await file.copy(dylibFileUri.path);
  }
  return dylibFileUri;
}

String _asRustTarget(OS os, Architecture? architecture, bool isSimulator) {
  if (os == OS.iOS && architecture == Architecture.arm64 && isSimulator) {
    return 'aarch64-apple-ios-sim';
  }
  return switch ((os, architecture)) {
    (OS.android, Architecture.arm) => 'armv7-linux-androideabi',
    (OS.android, Architecture.arm64) => 'aarch64-linux-android',
    (OS.android, Architecture.ia32) => 'i686-linux-android',
    (OS.android, Architecture.riscv64) => 'riscv64-linux-android',
    (OS.android, Architecture.x64) => 'x86_64-linux-android',
    (OS.fuchsia, Architecture.arm64) => 'aarch64-unknown-fuchsia',
    (OS.fuchsia, Architecture.x64) => 'x86_64-unknown-fuchsia',
    (OS.iOS, Architecture.arm64) => 'aarch64-apple-ios',
    (OS.iOS, Architecture.x64) => 'x86_64-apple-ios',
    (OS.linux, Architecture.arm) => 'armv7-unknown-linux-gnueabihf',
    (OS.linux, Architecture.arm64) => 'aarch64-unknown-linux-gnu',
    (OS.linux, Architecture.ia32) => 'i686-unknown-linux-gnu',
    (OS.linux, Architecture.riscv32) => 'riscv32gc-unknown-linux-gnu',
    (OS.linux, Architecture.riscv64) => 'riscv64gc-unknown-linux-gnu',
    (OS.linux, Architecture.x64) => 'x86_64-unknown-linux-gnu',
    (OS.macOS, Architecture.arm64) => 'aarch64-apple-darwin',
    (OS.macOS, Architecture.x64) => 'x86_64-apple-darwin',
    (OS.windows, Architecture.arm64) => 'aarch64-pc-windows-msvc',
    (OS.windows, Architecture.ia32) => 'i686-pc-windows-msvc',
    (OS.windows, Architecture.x64) => 'x86_64-pc-windows-msvc',
    (_, _) => throw UnimplementedError(
        'Target ${(os, architecture)} not available for rust'),
  };
}

bool _isNoStdTarget((OS os, Architecture? architecture) arg) => [
      (OS.android, Architecture.riscv64),
      (OS.linux, Architecture.riscv64)
    ].contains(arg);
