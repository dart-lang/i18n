// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:crypto/crypto.dart' show sha256;
import 'package:intl4x/src/hook_helpers/hashes.dart';
import 'package:intl4x/src/hook_helpers/version.dart';
import 'package:native_assets_cli/code_assets.dart';
import 'package:path/path.dart' as path;

const crateName = 'icu_capi';
const package = 'intl4x';
const assetId = 'src/bindings/lib.g.dart';

final env = 'ICU4X_BUILD_MODE';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final environmentBuildMode = Platform.environment[env];
    final buildMode = switch (environmentBuildMode) {
      'local' => LocalMode(input),
      'checkout' => CheckoutMode(input),
      'fetch' || null => FetchMode(input),
      String() => throw ArgumentError('''


Unknown build mode for icu4x. Set the `ICU4X_BUILD_MODE` environment variable with either `fetch`, `local`, or `checkout`.
* fetch: Fetch the precompiled binary from a CDN.
* local: Use a locally existing binary at the environment variable `LOCAL_ICU4X_BINARY`.
* checkout: Build a fresh library from a local git checkout of the icu4x repository at the environment variable `LOCAL_ICU4X_CHECKOUT`.

'''),
    };

    final builtLibrary = await buildMode.build();
    // For debugging purposes
    // ignore: deprecated_member_use
    output.addMetadatum(env, environmentBuildMode ?? 'fetch');

    final targetOS = input.config.code.targetOS;
    final targetArchitecture = input.config.code.targetArchitecture;
    output.assets.code.add(CodeAsset(
      package: package,
      name: assetId,
      linkMode: DynamicLoadingBundled(),
      architecture: targetArchitecture,
      os: targetOS,
      file: builtLibrary,
    ));

    output.addDependencies(
      [
        ...buildMode.dependencies,
        input.packageRoot.resolve('hook/build.dart'),
      ],
    );
  });
}

sealed class BuildMode {
  final BuildInput input;

  const BuildMode(this.input);

  List<Uri> get dependencies;

  Future<Uri> build();
}

final class FetchMode extends BuildMode {
  FetchMode(super.input);

  @override
  Future<Uri> build() async {
    final targetOS = input.config.code.targetOS;
    final targetArchitecture = input.config.code.targetArchitecture;
    final libraryType = 'dynamic'; //TODO: Add `static` when using link hooks.
    final target = [
      targetOS,
      targetArchitecture,
      libraryType,
    ].join('_');
    final uri = Uri.parse(
        'https://github.com/dart-lang/i18n/releases/download/$version/$target');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();
    if (response.statusCode != 200) {
      throw ArgumentError('The request to $uri failed');
    }
    final library = File.fromUri(
        input.outputDirectory.resolve(targetOS.dylibFileName('icu4x')));
    await library.create();
    await response.pipe(library.openWrite());

    final bytes = await library.readAsBytes();
    final fileHash = sha256.convert(bytes).toString();
    final expectedFileHash =
        fileHashes[(targetOS, targetArchitecture, libraryType)];
    if (fileHash == expectedFileHash) {
      return library.uri;
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
  LocalMode(super.input);

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
    final targetOS = input.config.code.targetOS;
    final dylibFileName = targetOS.dylibFileName('icu4x');
    final dylibFileUri = input.outputDirectory.resolve(dylibFileName);
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
  CheckoutMode(super.input);

  String? get workingDirectory => Platform.environment['LOCAL_ICU4X_CHECKOUT'];

  @override
  Future<Uri> build() async {
    if (workingDirectory == null) {
      throw ArgumentError('Specify the ICU4X checkout folder'
          'with the LOCAL_ICU4X_CHECKOUT variable');
    }
    return await buildLib(input, workingDirectory!);
  }

  @override
  List<Uri> get dependencies => [
        Uri.directory(workingDirectory!).resolve('Cargo.lock'),
      ];
}

Future<Uri> buildLib(BuildInput input, String workingDirectory) async {
  final code = input.config.code;
  final targetOS = code.targetOS;
  final targetArchitecture = code.targetArchitecture;
  final dylibFileName = targetOS.dylibFileName(crateName.replaceAll('-', '_'));
  final dylibFileUri = input.outputDirectory.resolve(dylibFileName);
  final rustTarget = _asRustTarget(
    targetOS,
    targetArchitecture,
    targetOS == OS.iOS && code.iOS.targetSdk == IOSSdk.iPhoneSimulator,
  );
  final isNoStd = _isNoStdTarget((targetOS, targetArchitecture));

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
    'icu_collator,icu_datetime,icu_list,icu_decimal,icu_plurals',
    'compiled_data',
    'buffer_provider',
    'logging',
    'simple_logger',
    'experimental_components',
  ];
  final noStdFeatures = [
    'icu_collator,icu_datetime,icu_list,icu_decimal,icu_plurals',
    'compiled_data',
    'buffer_provider',
    'libc-alloc',
    'panic-handler',
    'experimental_components',
  ];
  final linkModeType = code.linkModePreference == LinkModePreference.static
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
  await file.copy(dylibFileUri.toFilePath(windows: Platform.isWindows));
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
