// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:messages/package_intl_object.dart';
import 'package:messages_deserializer/messages_deserializer_json.dart';
import 'package:messages_serializer/messages_serializer.dart';

class MessageShrinker {
  void shrink(
    String dataFile,
    String constInstancesFile,
    String outputFile,
  ) {
    final constInstances =
        _parseConstInstances(File(constInstancesFile).readAsStringSync());

    final file = File(dataFile);
    if (dataFile.endsWith('.json')) {
      final buffer = file.readAsStringSync();
      final newBuffer = shrinkJson(buffer, constInstances);
      final newFile = File(outputFile)..createSync(recursive: true);
      newFile.writeAsStringSync(newBuffer);
    } else {
      throw ArgumentError('Not a valid Message file');
    }
  }

  /// Shrink a json message file by de- and reserializing, keeping only the
  /// message indices in [messagesToKeep].
  String shrinkJson(String buffer, List<int> messagesToKeep) {
    final sizeBefore = buffer.length;
    final json = JsonDeserializer(buffer).deserialize(OldIntlObject());
    final data = JsonSerializer(json.preamble.hasIds)
        .serialize(
          json.preamble.hash,
          json.preamble.locale,
          json.messages,
          messagesToKeep,
        )
        .data;
    final sizeAfter = data.length;
    final change = (sizeBefore - sizeAfter) / sizeBefore;
    final changeInPercent = (change * 100).toStringAsFixed(2);
    print('Reduced size from $sizeBefore to $sizeAfter by $changeInPercent %');
    return data;
  }

  /// Receive a file emitted by const_finder from the SDK, which has the
  /// structure:
  /// ```json
  /// {
  ///   "constantInstances": [
  ///     {
  ///       "index": 1,
  ///       "_name": "constantNameOne"
  ///     },
  ///     {
  ///       "index": 2,
  ///       "_name": "constantNameTwo"
  ///     },
  ///     ...
  ///   ],
  ///   "nonConstantLocations": []
  /// }
  /// ```
  List<int> _parseConstInstances(String fileContents) {
    final decoded = jsonDecode(fileContents) as Map<String, dynamic>;
    final instances = decoded['constantInstances'] as List;
    return instances
        .map((e) => e as Map<String, dynamic>)
        .map((e) => e['index'] as int)
        .toList();
  }
}
