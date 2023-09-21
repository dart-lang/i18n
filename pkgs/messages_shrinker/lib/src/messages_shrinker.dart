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
        parseConstInstances(File(constInstancesFile).readAsStringSync());

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

  List<int> parseConstInstances(String fileContents) {
    final decoded = jsonDecode(fileContents) as Map<String, dynamic>;
    final instances = decoded['constantInstances'] as List;
    return instances
        .map((e) => e as Map<String, dynamic>)
        .map((e) => e['index'] as int)
        .toList();
  }
}

class JsonExtraction {
  final String before;
  final String json;
  final String after;

  JsonExtraction(this.before, this.json, this.after);
}
