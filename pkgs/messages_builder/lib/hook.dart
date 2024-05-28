import 'dart:io';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:path/path.dart' as p;

import 'builder.dart';
import 'generation_options.dart';
import 'message_with_metadata.dart';

Future<GenerationOptions> _generationOptions(BuildConfig config) async {
  final packageRoot = config.packageRoot;
  final pubspecUri = packageRoot.resolve('pubspec.yaml');
  final file = File.fromUri(pubspecUri);
  return GenerationOptions.fromPubspec(await file.readAsString());
}

class MessagesDataBuilder {
  final Future<List<String>> Function(BuildConfig config) arbFiles;

  //TODO allow arbs from other locations than package root subfolders
  MessagesDataBuilder.fromFiles(List<String> relativePaths)
      : arbFiles = ((config) async => relativePaths);

  MessagesDataBuilder.fromFolder(String relativePath)
      : arbFiles = ((config) =>
            Directory(config.packageRoot.resolve(relativePath).path)
                .list()
                .where((file) => file is File)
                .map((file) => file.path)
                .where((path) => p.extension(path) == '.arb')
                .map((path) => p.relative(path, from: config.packageRoot.path))
                .toList());

  Future<void> run({
    required BuildConfig config,
    required BuildOutput output,
    required Logger? logger,
  }) async {
    final files = await arbFiles(config);
    for (final arbFilePath in files) {
      if (p.isAbsolute(arbFilePath)) {
        throw ArgumentError('Paths for .arb files must be relative to the'
            ' package root ${config.packageRoot}, but $arbFilePath is'
            ' absolute.');
      }
      final arbFileUri = config.packageRoot.resolve(arbFilePath);
      final arbFileContents = await File.fromUri(arbFileUri).readAsString();
      final generationOptions = await _generationOptions(config);
      final messageBundle = await parseMessageFile(
        arbFileContents,
        generationOptions,
      );

      final serializer = _buildSerializer(generationOptions);

      final data = _arbToDataFile(
        messageBundle,
        arbFilePath,
        serializer,
      );

      final assetName = _assetName(
        p.relative(arbFileUri.path, from: config.packageRoot.path),
        serializer.extension,
      );
      final file = await _createAssetFile(assetName, config);

      await _writeDataToFile(data, file);

      output.addAsset(DataAsset(
        package: config.packageName,
        name: assetName,
        file: file.uri,
      ));

      output.addDependency(arbFileUri);
    }
    output.addDependency(config.packageRoot.resolve('hook/build.dart'));
  }

  String _arbToDataFile(MessagesWithMetadata messageBundle, String arbFilePath,
          Serializer<String> serializer) =>
      serializer
          .serialize(
            messageBundle.hash,
            messageBundle.locale ?? inferLocale(arbFilePath) ?? 'en_US',
            messageBundle.messages.map((e) => e.message).toList(),
          )
          .data;

  String _assetName(String relativePath, String extension) {
    final dataFile = p.setExtension(relativePath, extension);
    return dataFile;
  }

  Serializer<String> _buildSerializer(GenerationOptions generationOptions) =>
      JsonSerializer(generationOptions.findById);

  Future<File> _createAssetFile(String dataFile, BuildConfig config) async {
    final outputDirectory =
        Directory.fromUri(config.outputDirectory.resolve(config.packageName));
    final file = File.fromUri(outputDirectory.uri.resolve(dataFile));
    await file.create(recursive: true);
    return file;
  }

  Future<void> _writeDataToFile<T>(
    T data,
    File file,
  ) async {
    if (data is Uint8List) {
      await file.writeAsBytes(data);
    } else if (data is String) {
      await file.writeAsString(data);
    }
  }
}
