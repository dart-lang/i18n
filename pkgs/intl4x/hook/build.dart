// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:crypto/crypto.dart' show sha256;
import 'package:intl4x/src/hook_helpers/build_options.dart';
import 'package:intl4x/src/hook_helpers/hashes.dart';
import 'package:intl4x/src/hook_helpers/shared.dart'
    show assetId, package, runProcess;
import 'package:intl4x/src/hook_helpers/version.dart';
import 'package:native_assets_cli/code_assets.dart';
import 'package:path/path.dart' as path;

const crateName = 'icu_capi';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final buildOptions = await getBuildOptions(
      input.outputDirectory.toFilePath(),
    );
    if (buildOptions == null) {
      throw ArgumentError('''

Unknown build mode for icu4x. Set the build mode with either `fetch`, `local`, or `checkout` by writing into your pubspec:
* fetch: Fetch the precompiled binary from a CDN.
```
...
hook:
  intl4x:
    buildMode: fetch
...
```
* local: Use a locally existing binary at the environment variable `LOCAL_ICU4X_BINARY`.
```
...
hook:
  intl4x:
    buildMode: local
    localDylibPath: path/to/dylib.so
...
```
* checkout: Build a fresh library from a local git checkout of the icu4x repository.
```
...
hook:
  intl4x:
    buildMode: checkout
    checkoutPath: path/to/checkout
...
```

''');
    }
    print('Read build options: ${buildOptions.toJson()}');
    final treeshake = buildOptions.treeshake ?? false;
    final buildMode = switch (buildOptions.buildMode) {
      BuildModeEnum.local => LocalMode(
        input,
        buildOptions.localDylibPath,
        treeshake,
      ),
      BuildModeEnum.checkout => CheckoutMode(
        input,
        buildOptions.checkoutPath,
        treeshake,
      ),
      BuildModeEnum.fetch => FetchMode(input, treeshake),
    };

    final builtLibrary = await buildMode.build();
    // For debugging purposes
    // ignore: deprecated_member_use
    output.addMetadatum('ICU4X_BUILD_MODE', buildOptions.buildMode.name);

    final targetOS = input.config.code.targetOS;
    final targetArchitecture = input.config.code.targetArchitecture;
    output.assets.code.add(
      CodeAsset(
        package: package,
        name: assetId,
        linkMode: DynamicLoadingBundled(),
        architecture: targetArchitecture,
        os: targetOS,
        file: builtLibrary,
      ),
      linkInPackage: input.config.linkingEnabled ? package : null,
    );

    output.addDependencies(buildMode.dependencies);
  });
}

sealed class BuildMode {
  final BuildInput input;
  final bool treeshake;

  const BuildMode(this.input, this.treeshake);

  List<Uri> get dependencies;

  Future<Uri> build();
}

final class FetchMode extends BuildMode {
  FetchMode(super.input, super.treeshake);
  final httpClient = HttpClient();

  @override
  Future<Uri> build() async {
    print('Running in `fetch` mode');
    final targetOS = input.config.code.targetOS;
    final targetArchitecture = input.config.code.targetArchitecture;
    final libraryType =
        input.config.buildStatic(treeshake) ? 'static' : 'dynamic';
    final target = [targetOS, targetArchitecture, libraryType].join('_');
    print('Fetching pre-built binary for $version and $target');
    final dylibRemoteUri = Uri.parse(
      'https://github.com/dart-lang/i18n/releases/download/$version/$target',
    );
    final library = await fetchToFile(
      dylibRemoteUri,
      input.outputDirectory.resolve(input.config.filename(treeshake)('icu4x')),
    );

    final bytes = await library.readAsBytes();
    final fileHash = sha256.convert(bytes).toString();
    final expectedFileHash =
        fileHashes[(targetOS, targetArchitecture, libraryType)];
    if (fileHash != expectedFileHash) {
      throw Exception(
        'The pre-built binary for the target $target at $dylibRemoteUri has a'
        ' hash of $fileHash, which does not match $expectedFileHash fixed in'
        ' the build hook of package:intl4x.',
      );
    }
    return library.uri;
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
  final String? localPath;
  LocalMode(super.input, this.localPath, super.treeshake);

  String get _localLibraryPath {
    if (localPath != null) {
      return localPath!;
    }
    throw ArgumentError(
      '`LOCAL_ICU4X_BINARY` is empty. '
      'If the `ICU4X_BUILD_MODE` is set to `local`, the '
      '`LOCAL_ICU4X_BINARY` environment variable must contain the path to '
      'the binary.',
    );
  }

  @override
  Future<Uri> build() async {
    print('Running in `local` mode');
    final targetOS = input.config.code.targetOS;
    final dylibFileName = targetOS.dylibFileName('icu4x');
    final dylibFileUri = input.outputDirectory.resolve(dylibFileName);
    final file = File(_localLibraryPath);
    if (!(await file.exists())) {
      throw FileSystemException('Could not find binary.', _localLibraryPath);
    }
    await file.copy(dylibFileUri.toFilePath(windows: Platform.isWindows));
    return dylibFileUri;
  }

  @override
  List<Uri> get dependencies => [Uri.file(_localLibraryPath)];
}

final class CheckoutMode extends BuildMode {
  final String? checkoutPath;

  CheckoutMode(super.input, this.checkoutPath, super.treeshake);

  @override
  Future<Uri> build() async {
    print('Running in `checkout` mode');
    if (checkoutPath == null) {
      throw ArgumentError(
        'Specify the ICU4X checkout folder'
        'with the LOCAL_ICU4X_CHECKOUT variable',
      );
    }
    return await buildLib(input, checkoutPath!, treeshake);
  }

  @override
  List<Uri> get dependencies => [
    Uri.directory(checkoutPath!).resolve('Cargo.lock'),
  ];
}

//TODO: Reuse code from package:icu4x as soon as it is published.
Future<Uri> buildLib(
  BuildInput input,
  String workingDirectory,
  bool treeshake,
) async {
  final crateNameFixed = crateName.replaceAll('-', '_');
  final libFileName = input.config.filename(treeshake)(crateNameFixed);
  final libFileUri = input.outputDirectory.resolve(libFileName);

  final code = input.config.code;
  final targetOS = code.targetOS;
  final targetArchitecture = code.targetArchitecture;
  final buildStatic = input.config.buildStatic(treeshake);

  final isNoStd = _isNoStdTarget((targetOS, targetArchitecture));
  final target = asRustTarget(input);

  if (!isNoStd) {
    final rustArguments = ['target', 'add', target];
    await runProcess(
      'rustup',
      rustArguments,
      workingDirectory: workingDirectory,
    );
  }
  final stdFeatures = ['logging', 'simple_logger'];
  final noStdFeatures = ['libc_alloc', 'panic_handler'];
  final features = {
    'default_components',
    'icu_collator',
    'icu_datetime',
    'icu_list',
    'icu_decimal',
    'icu_plurals',
    'compiled_data',
    'buffer_provider',
    'experimental_components',
    ...(isNoStd ? noStdFeatures : stdFeatures),
  };
  final arguments = [
    if (buildStatic || isNoStd) '+nightly',
    'rustc',
    '--manifest-path=$workingDirectory/ffi/capi/Cargo.toml',
    '--crate-type=${buildStatic ? 'staticlib' : 'cdylib'}',
    '--release',
    '--config=profile.release.panic="abort"',
    '--config=profile.release.codegen-units=1',
    '--no-default-features',
    '--features=${features.join(',')}',
    if (isNoStd) '-Zbuild-std=core,alloc',
    if (buildStatic || isNoStd) ...[
      '-Zbuild-std=std,panic_abort',
      '-Zbuild-std-features=panic_immediate_abort',
    ],
    '--target=$target',
  ];
  await runProcess('cargo', arguments, workingDirectory: workingDirectory);

  final builtPath = path.join(
    workingDirectory,
    'target',
    target,
    'release',
    libFileName,
  );
  final file = File(builtPath);
  if (!(await file.exists())) {
    throw FileSystemException('Building the dylib failed', builtPath);
  }
  await file.copy(libFileUri.toFilePath(windows: Platform.isWindows));
  return libFileUri;
}

String asRustTarget(BuildInput input) {
  final rustTarget = _asRustTarget(
    input.config.code.targetOS,
    input.config.code.targetArchitecture,
    input.config.code.targetOS == OS.iOS &&
        input.config.code.iOS.targetSdk == IOSSdk.iPhoneSimulator,
  );
  return rustTarget;
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
    (_, _) =>
      throw UnimplementedError(
        'Target ${(os, architecture)} not available for rust',
      ),
  };
}

bool _isNoStdTarget((OS os, Architecture? architecture) arg) => [
  (OS.android, Architecture.riscv64),
  (OS.linux, Architecture.riscv64),
].contains(arg);

extension on BuildConfig {
  bool buildStatic(bool treeshake) =>
      code.linkModePreference == LinkModePreference.static ||
      (linkingEnabled && treeshake);

  String Function(String) filename(bool treeshake) =>
      buildStatic(treeshake)
          ? code.targetOS.staticlibFileName
          : code.targetOS.dylibFileName;
}
