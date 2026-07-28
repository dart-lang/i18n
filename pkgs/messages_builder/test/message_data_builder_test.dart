// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:messages_builder/generation_options.dart';
import 'package:messages_builder/message_data_builder.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('MessageDataFileBuilder', () {
    late Directory tempDir;
    late Directory inputDir;
    late Directory outputDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('messages_builder_test_');
      inputDir = Directory(path.join(tempDir.path, 'l10n'))..createSync();
      outputDir = Directory(path.join(tempDir.path, 'assets'))..createSync();

      final arbFile = File(path.join(inputDir.path, 'app_en.arb'));
      await arbFile.writeAsString('''
{
  "@@locale": "en",
  "hello": "Hello world"
}
''');
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('generates .arb.json asset files for flutter target', () async {
      final options = await GenerationOptions.fromPubspec('''
name: test_pkg
package_options:
  messages_builder:
    target: flutter
''');

      final builder = MessageDataFileBuilder(
        inputFolder: inputDir,
        outputFolder: outputDir,
        options: options,
      );

      final mapping = await builder.run();
      expect(mapping, isNotEmpty);

      final generatedAsset = File(path.join(outputDir.path, 'app_en.arb.json'));
      expect(generatedAsset.existsSync(), isTrue);
    });

    test('does NOT generate .arb.json asset files for dart target', () async {
      final options = await GenerationOptions.fromPubspec('''
name: test_pkg
package_options:
  messages_builder:
    target: dart
''');

      final builder = MessageDataFileBuilder(
        inputFolder: inputDir,
        outputFolder: outputDir,
        options: options,
      );

      final mapping = await builder.run();
      expect(mapping, isNotEmpty);

      final generatedAsset = File(path.join(outputDir.path, 'app_en.arb.json'));
      expect(generatedAsset.existsSync(), isFalse);
    });

    test('generates .arb.json asset files for manual target', () async {
      final options = await GenerationOptions.fromPubspec('''
name: test_pkg
package_options:
  messages_builder:
    target: manual
''');

      final builder = MessageDataFileBuilder(
        inputFolder: inputDir,
        outputFolder: outputDir,
        options: options,
      );

      final mapping = await builder.run();
      expect(mapping, isNotEmpty);

      final generatedAsset = File(path.join(outputDir.path, 'app_en.arb.json'));
      expect(generatedAsset.existsSync(), isTrue);
    });
  });
}
