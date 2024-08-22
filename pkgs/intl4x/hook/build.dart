// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:crypto/crypto.dart' show sha256;
import 'package:intl4x/src/hook_helpers/hashes.dart';
import 'package:intl4x/src/hook_helpers/shared.dart';
import 'package:intl4x/src/hook_helpers/version.dart';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:path/path.dart' as path;

const crateName = 'icu_capi';

final env = 'ICU4X_BUILD_MODE';

void main(List<String> args) async {
  await build(args, (config, output) async {
    final environmentBuildMode = Platform.environment[env];
    final buildMode = switch (environmentBuildMode) {
      'local' => LocalMode(config),
      'checkout' => CheckoutMode(config),
      'fetch' || null => FetchMode(config),
      String() => throw ArgumentError('''


Unknown build mode for icu4x. Set the `ICU4X_BUILD_MODE` environment variable with either `fetch`, `local`, or `checkout`.
* fetch: Fetch the precompiled binary from a CDN.
* local: Use a locally existing binary at the environment variable `LOCAL_ICU4X_BINARY`.
* checkout: Build a fresh library from a local git checkout of the icu4x repository at the environment variable `LOCAL_ICU4X_CHECKOUT`.

'''),
    };

    final buildResult = await buildMode.build();
    // For debugging purposes
    // ignore: deprecated_member_use
    output.addMetadatum(env, environmentBuildMode ?? 'fetch');
    buildResult.addAssets(config, output);
    output.addDependencies(buildMode.dependencies);
  });
}

sealed class BuildMode {
  final BuildConfig config;

  const BuildMode(this.config);

  List<Uri> get dependencies;

  Future<BuildResult> build();
}

final class BuildResult {
  final Uri library;
  final Uri? datagen;
  final Uri? postcard;

  BuildResult({
    required this.library,
    required this.datagen,
    required this.postcard,
  });

  void addAssets(BuildConfig config, BuildOutput output) {
    output.addAssets(
      [
        NativeCodeAsset(
          package: package,
          name: assetId,
          linkMode: DynamicLoadingBundled(),
          architecture: config.targetArchitecture,
          os: config.targetOS,
          file: library,
        ),
        if (datagen != null)
          DataAsset(
            package: package,
            name: 'datagen',
            file: datagen!,
          ),
        if (postcard != null)
          DataAsset(
            package: package,
            name: 'postcard',
            file: postcard!,
          ),
      ],
      linkInPackage: config.linkingEnabled ? config.packageName : null,
    );
  }
}

final class FetchMode extends BuildMode {
  FetchMode(super.config);
  final httpClient = HttpClient();

  @override
  Future<BuildResult> build() async {
    final libraryType = config.linkingEnabled ? 'static' : 'dynamic';
    final target = '${config.targetOS}_${config.targetArchitecture}';
    final dylibRemoteUri = Uri.parse(
        'https://github.com/dart-lang/i18n/releases/download/$version/${target}_$libraryType');
    final library = await fetchToFile(
      dylibRemoteUri,
      config.outputDirectory.resolve(config.filename('icu4x')),
    );

    final datagenName = config.targetOS.executableFileName('$target-datagen');
    final datagen = await fetchToFile(
      Uri.parse(
          'https://github.com/dart-lang/i18n/releases/download/$version/$datagenName'),
      config.outputDirectory.resolve('datagen'),
    );

    final postcard = await fetchToFile(
      Uri.parse(
          'https://github.com/dart-lang/i18n/releases/download/$version/full.postcard'),
      config.outputDirectory.resolve('full.postcard'),
    );

    final bytes = await library.readAsBytes();
    final fileHash = sha256.convert(bytes).toString();
    final expectedFileHash =
        fileHashes[(config.targetOS, config.targetArchitecture, libraryType)];
    if (fileHash == expectedFileHash) {
      return BuildResult(
        library: library.uri,
        datagen: datagen.uri,
        postcard: postcard.uri,
      );
    } else {
      throw Exception(
          'The pre-built binary for the target $target at $dylibRemoteUri has a'
          ' hash of $fileHash, which does not match $expectedFileHash fixed in'
          ' the build hook of package:intl4x.');
    }
  }

  Future<File> fetchToFile(Uri uri, Uri fileUri) async {
    final request = await httpClient.getUrl(uri);
    final response = await request.close();
    if (response.statusCode != 200) {
      throw ArgumentError('The request to $uri failed');
    }
    final file = File.fromUri(fileUri);
    await file.create();
    await response.pipe(file.openWrite());
    return file;
  }

  @override
  List<Uri> get dependencies => [];
}

final class LocalMode extends BuildMode {
  final String localLibraryPath;
  final String? localDatagenPath;
  final String? localPostcardPath;

  LocalMode(super.config)
      : localLibraryPath = _getFromEnvironment(
          'LOCAL_ICU4X_BINARY_${config.linkingEnabled ? 'STATIC' : 'DYNAMIC'}',
          true,
        )!,
        localDatagenPath = _getFromEnvironment('LOCAL_ICU4X_DATAGEN', false),
        localPostcardPath = _getFromEnvironment('LOCAL_ICU4X_POSTCARD', false);

  static String? _getFromEnvironment(String key, bool mustExist) {
    final localPath = Platform.environment[key];
    if (localPath != null || !mustExist) {
      return localPath;
    }
    throw ArgumentError('`$key` is empty. '
        'If the `ICU4X_BUILD_MODE` is set to `local`, the '
        '`$key` environment variable must be set.');
  }

  @override
  Future<BuildResult> build() async {
    final libFileUri = config.outputDirectory.resolve(config.filename('icu4x'));
    await copyFile(localLibraryPath, libFileUri);

    final Uri? datagenFileUri;
    if (localDatagenPath != null) {
      datagenFileUri = config.outputDirectory.resolve('datagen');
      await copyFile(localDatagenPath!, datagenFileUri);
    } else {
      datagenFileUri = null;
    }

    final Uri? postcardFileUri;
    if (localPostcardPath != null) {
      postcardFileUri = config.outputDirectory.resolve('postcard');
      await copyFile(localPostcardPath!, postcardFileUri);
    } else {
      postcardFileUri = null;
    }

    return BuildResult(
      library: libFileUri,
      datagen: datagenFileUri,
      postcard: postcardFileUri,
    );
  }

  @override
  List<Uri> get dependencies => [
        Uri.file(localLibraryPath),
      ];
}

final class CheckoutMode extends BuildMode {
  CheckoutMode(super.config);

  String? get workingDirectory => Platform.environment['LOCAL_ICU4X_CHECKOUT'];

  @override
  Future<BuildResult> build() async {
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

Future<BuildResult> buildLib(
    BuildConfig config, String workingDirectory) async {
  final crateNameFixed = crateName.replaceAll('-', '_');
  final libFileName = config.filename(crateNameFixed);

  final libFileUri = config.outputDirectory.resolve(libFileName);
  final datagenFileUri = config.outputDirectory.resolve('datagen');
  final postcardFileUri = config.outputDirectory.resolve('postcard');
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
    final linkModeType = config.buildStatic ? 'staticlib' : 'cdylib';
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
      libFileName,
    );
    await copyFile(builtPath, libFileUri);

    if (config.linkingEnabled) {
      final postcardPath = path.join(tempDir.path, 'full.postcard');
      await Process.run(
        'cargo',
        [
          'run',
          ...['-p', 'icu_datagen'],
          '--',
          ...['--locales', 'full'],
          ...['--keys', 'all'],
          ...['--format', 'blob'],
          ...['--out', postcardPath],
        ],
        workingDirectory: workingDirectory,
      );
      await copyFile(postcardPath, postcardFileUri);

      final datagenPath = path.join(tempDir.path, 'datagen');
      final datagenDirectory = path.join(workingDirectory, 'provider/datagen');
      await Process.run(
        'rustup',
        ['target', 'add', 'aarch64-unknown-linux-gnu'],
        workingDirectory: datagenDirectory,
      );
      await Process.run(
        'cargo',
        [
          'build',
          '--release',
          '--bin',
          'icu4x-datagen',
          '--no-default-features',
          ...[
            '--features',
            'bin,blob_exporter,blob_input,rayon,experimental_components'
          ],
          ...['--target', 'aarch64-unknown-linux-gnu']
        ],
        workingDirectory: datagenDirectory,
      );
      await copyFile(datagenPath, datagenFileUri);
    }
  }
  return BuildResult(
    library: libFileUri,
    datagen: config.linkingEnabled ? datagenFileUri : null,
    postcard: config.linkingEnabled ? postcardFileUri : null,
  );
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

extension on BuildConfig {
  bool get buildStatic =>
      linkModePreference == LinkModePreference.static || linkingEnabled;
  String Function(String) get filename =>
      buildStatic ? targetOS.staticlibFileName : targetOS.dylibFileName;
}

Future<void> copyFile(String path, Uri libFileUri) async {
  final file = File(path);
  if (!(await file.exists())) {
    throw FileSystemException('File does not exist.', path);
  }
  await file.copy(libFileUri.toFilePath(windows: Platform.isWindows));
}
