import 'dart:io';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:path/path.dart' as p;

import 'builder.dart';
import 'generation_options.dart';
import 'message_with_metadata.dart';

class MessagesDataBuilder {
  final GenerationOptions generationOptions;
  final List<String> arbFiles;

  MessagesDataBuilder(
      {required this.generationOptions, required this.arbFiles});

  Serializer<String> get serializer =>
      JsonSerializer(generationOptions.findById);

  Future<void> run({
    required BuildConfig config,
    required BuildOutput output,
    required Logger? logger,
  }) async {
    for (final arbFilePath in arbFiles) {
      final arbFileUri = config.packageRoot.resolve(arbFilePath);
      final arbFile = File.fromUri(arbFileUri);
      final arbFileContents = await arbFile.readAsString();
      final messageBundle = await parseMessageFile(
        arbFileContents,
        generationOptions,
      );

      /// This writes the file containing the messages, which can be either a binary
      /// `.carb` file or a JSON file, depending on the serializer.
      ///
      /// This message data file must be shipped with the application, it is
      /// unpacked at runtime so that the messages can be read from it.
      ///
      /// Returns the list of indices of the messages which are visible to the user.
      final serialization = _serializeArb(messageBundle, arbFilePath);

      final (fileName, file) = await _createDataFile(arbFilePath, config);

      await _writeDataToFile(serialization, file);

      output.addAsset(DataAsset(
        package: config.packageName,
        name: fileName,
        file: file.uri,
      ));

      output.addDependency(arbFileUri);
    }
  }

  Serialization<String> _serializeArb(
          MessagesWithMetadata messageBundle, String arbFilePath) =>
      serializer.serialize(
        messageBundle.hash,
        messageBundle.locale ?? inferLocale(arbFilePath) ?? 'en_US',
        messageBundle.messages.map((e) => e.message).toList(),
      );

  Future<void> _writeDataToFile<T>(
    Serialization<T> serialization,
    File file,
  ) async {
    final data = serialization.data;
    if (data is Uint8List) {
      await file.writeAsBytes(data);
    } else if (data is String) {
      await file.writeAsString(data);
    }
  }

  Future<(String, File)> _createDataFile(
    String arbFilePath,
    BuildConfig config,
  ) async {
    final dataFile = p.setExtension(arbFilePath, serializer.extension);
    final directory =
        Directory.fromUri(config.outputDirectory.resolve(config.packageName));
    final file = File.fromUri(directory.uri.resolve(dataFile));
    await file.create(recursive: true);
    return (dataFile, file);
  }
}
