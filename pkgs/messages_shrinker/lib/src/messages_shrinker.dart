import 'dart:io';

import 'package:messages/package_intl_object.dart';
import 'package:messages_deserializer/messages_deserializer_json.dart';
import 'package:messages_serializer/messages_serializer.dart';

class MessageShrinker {
  String shrink(String fileName, List<int> messagesToKeep) {
    final newFileName = '$fileName.shrnk';
    final file = File(fileName);
    final newFile = File(newFileName);
    if (fileName.endsWith('.json')) {
      final buffer = file.readAsStringSync();
      final newBuffer = shrinkJson(buffer, messagesToKeep);
      newFile.writeAsString(newBuffer);
    } else {
      throw ArgumentError('Not a valid Message file');
    }
    return file.path;
  }

  String shrinkJson(String buffer, List<int> messagesToKeep) {
    final json = JsonDeserializer(buffer).deserialize(OldIntlObject());
    return JsonSerializer(json.preamble.hasIds)
        .serialize(
          json.preamble.hash,
          json.preamble.locale,
          json.messages,
          messagesToKeep,
        )
        .data;
  }
}

class JsonExtraction {
  final String before;
  final String json;
  final String after;

  JsonExtraction(this.before, this.json, this.after);
}
