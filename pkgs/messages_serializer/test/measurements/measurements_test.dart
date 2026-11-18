// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:messages/messages_json.dart';
import 'package:messages_builder/arb_parser.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

final expectedSizes = {'small': 89, 'medium': 872, 'large': 2398};

void main() {
  group('Serialization Golden Benchmarks', () {
    final updateGoldens = Platform.environment['UPDATE_GOLDENS'] == 'true';
    final measurementsDir = Directory(
      path.join(Directory.current.path, 'test', 'measurements'),
    );

    for (final prefix in ['small', 'medium', 'large']) {
      test('golden test for $prefix.arb', () async {
        final arbFile = File(path.join(measurementsDir.path, '$prefix.arb'));
        expect(await arbFile.exists(), true, reason: 'Missing $prefix.arb');

        final arbContent = await arbFile.readAsString();
        final arbJson = jsonDecode(arbContent) as Map<String, dynamic>;
        final messageBundle = ArbParser().parseMessageFile(arbJson);

        final serializer = JsonSerializer();
        final serialization = serializer.serialize(
          messageBundle.hash,
          messageBundle.locale ?? 'en',
          messageBundle.messages.map((e) => e.message).toList(),
        );

        final goldenFile = File(
          path.join(measurementsDir.path, '$prefix.arb.json'),
        );

        if (updateGoldens) {
          await goldenFile.writeAsString(serialization.data);
        }

        expect(
          await goldenFile.exists(),
          true,
          reason:
              'Golden file $prefix.arb.json does not exist. '
              'Run with UPDATE_GOLDENS=true to generate.',
        );

        final actualSize = serialization.data.length;
        final expectedSize = expectedSizes[prefix];
        expect(
          actualSize,
          expectedSize,
          reason:
              'Size for $prefix.arb.json ($actualSize bytes) does not match '
              'expected exact size ($expectedSize bytes).',
        );

        // Verify deserializer parses the file without error
        final deserialized = JsonDeserializer(serialization.data).deserialize();
        expect(deserialized.preamble.locale, messageBundle.locale ?? 'en');
      });
    }
  });
}
