// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:crypto/crypto.dart' show sha256;
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';
import 'package:logging/logging.dart';
import 'hashes.dart';
import 'version.dart';

const crateName = 'icu_capi';
const package = 'intl4x';
const assetId = 'src/bindings/lib.g.dart';

final env = 'ICU4X_BUILD_MODE';

void main(List<String> args) async {
  await build(args, (config, output) async {
    final environmentBuildMode = Platform.environment[env];
    final buildMode = switch (environmentBuildMode) {
      'local' => LocalMode(config),
      'checkout' => CheckoutMode(config, output),
      'fetch' || null => FetchMode(config),
      String() => throw ArgumentError('''


Unknown build mode for icu4x. Set the `ICU4X_BUILD_MODE` environment variable with either `fetch`, `local`, or `checkout`.
* fetch: Fetch the precompiled binary from a CDN.
* local: Use a locally existing binary at the environment variable `LOCAL_ICU4X_BINARY`.
* checkout: Build a fresh library from a local git checkout of the icu4x repository at the environment variable `LOCAL_ICU4X_CHECKOUT`.

'''),
    };

    final builtLibrary = await buildMode.build();
    // For debugging purposes
    output.addMetadatum(env, environmentBuildMode ?? 'fetch');

    if (builtLibrary != null) {
      output.addAsset(NativeCodeAsset(
        package: package,
        name: assetId,
        linkMode: DynamicLoadingBundled(),
        architecture: config.targetArchitecture,
        os: config.targetOS,
        file: builtLibrary,
      ));
    }

    output.addDependencies(
      [
        ...buildMode.dependencies,
        config.packageRoot.resolve('hook/build.dart'),
      ],
    );
  });
}

sealed class BuildMode {
  final BuildConfig config;

  const BuildMode(this.config);

  List<Uri> get dependencies;

  Future<Uri?> build();
}

final class FetchMode extends BuildMode {
  FetchMode(super.config);

  @override
  Future<Uri> build() async {
    final target = '${config.targetOS}_${config.targetArchitecture}';
    final uri = Uri.parse(
        'https://github.com/dart-lang/i18n/releases/download/$version/$target');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();
    if (response.statusCode != 200) {
      throw ArgumentError('The request to $uri failed');
    }
    final dynamicLibrary = File.fromUri(
        config.outputDirectory.resolve(config.targetOS.dylibFileName('icu4x')));
    await dynamicLibrary.create();
    await response.pipe(dynamicLibrary.openWrite());

    final bytes = await dynamicLibrary.readAsBytes();
    final fileHash = sha256.convert(bytes).toString();
    final expectedFileHash = fileHashes[(
      config.targetOS,
      config.targetArchitecture,
    )];
    if (fileHash == expectedFileHash) {
      return dynamicLibrary.uri;
    } else {
      throw Exception(
          'The pre-built binary for the target $target at $uri has a hash of '
          '$fileHash, which does not match $expectedFileHash fixed in the '
          'build hook of package:intl4x.');
    }
  }

  @override
  List<Uri> get dependencies => [];
}

final class LocalMode extends BuildMode {
  LocalMode(super.config);

  String get _localBinaryPath {
    final localPath = Platform.environment['LOCAL_ICU4X_BINARY'];
    if (localPath != null) {
      return localPath;
    }
    throw ArgumentError('`LOCAL_ICU4X_BINARY` is empty. '
        'If the `ICU4X_BUILD_MODE` is set to `local`, the '
        '`LOCAL_ICU4X_BINARY` environment variable must contain the path to '
        'the binary.');
  }

  @override
  Future<Uri> build() async {
    final dylibFileName = config.targetOS.dylibFileName('icu4x');
    final dylibFileUri = config.outputDirectory.resolve(dylibFileName);
    final file = File(_localBinaryPath);
    if (!(await file.exists())) {
      throw FileSystemException('Could not find binary.', _localBinaryPath);
    }
    await file.copy(dylibFileUri.toFilePath(windows: Platform.isWindows));
    return dylibFileUri;
  }

  @override
  List<Uri> get dependencies => [Uri.file(_localBinaryPath)];
}

final class CheckoutMode extends BuildMode {
  final BuildOutput output;
  CheckoutMode(super.config, this.output);

  String? get workingDirectory => Platform.environment['LOCAL_ICU4X_CHECKOUT'];

  @override
  Future<Uri?> build() async {
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

  Future<Uri?> buildLib(BuildConfig config, String workingDirectory) async {
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
        await Rustup.systemRustup()?.runCommand(
          rustArguments,
          logger: Logger(''),
        );
      }
      final features = [
        'icu_collator',
        'icu_datetime',
        'icu_list',
        'icu_decimal',
        'icu_plurals',
        if (config.linkingEnabled) 'compiled_data',
        'buffer_provider',
        if (!isNoStd) ...['logging', 'simple_logger'],
        if (isNoStd) ...['libc-alloc', 'panic-handler'],
        'experimental_components',
      ];
      final arguments = [
        if (isNoStd) '+nightly',
        '--config=profile.release.panic="abort"',
        '--config=profile.release.codegen-units=1',
        '--no-default-features',
        '--features=${features.join(',')}',
        if (isNoStd) ...[
          '-Zbuild-std=core,alloc',
          '-Zbuild-std-features=panic_immediate_abort'
        ],
      ];

      final rustBuilder = RustBuilder(
        package: config.packageName,
        assetName: assetId,
        cratePath: crateName,
        buildConfig: config,
        extraCargoArgs: arguments,
        buildMode: CargoBuildMode.rustc,
        crateType:
            config.linkingEnabled ? CrateType.staticlib : CrateType.cdylib,
        release: true,
      );
      await rustBuilder.run(output: output);
    }
    return null;
  }
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
