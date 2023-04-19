import 'dart:io';
import 'dart:typed_data';

import 'package:messages/message_format.dart';
import 'package:messages_serializer/messages_serializer.dart';

class MessageShrinker {
  String shrink(String fileName, List<int> messagesToKeep) {
    var newFileName = '$fileName.shrnk';
    var file = File(fileName);
    var newFile = File(newFileName);
    if (fileName.endsWith('.carb.dart')) {
      var buffer = file.readAsStringSync();
      var newBuffer = shrinkJson(buffer, messagesToKeep);
      newFile.writeAsString(newBuffer);
    } else if (fileName.endsWith('.carb')) {
      var bytes = file.readAsBytesSync();
      var newBytes = shrinkNative(bytes, messagesToKeep);
      newFile.writeAsBytes(newBytes);
    } else {
      throw ArgumentError('Not a valid Message file');
    }
    return file.path;
  }

  String shrinkJson(String buffer, List<int> messagesToKeep) {
    var jsonExtraction = extractJsonFromClass(buffer);
    var json = WebDeserializer(jsonExtraction.json).deserialize();
    var newMessageList = <Message>[];
    for (var messageIndex in messagesToKeep) {
      newMessageList.add(json.messages[messageIndex]);
    }
    return WebSerializer(json.hasIds)
        .serialize(json.hash, json.locale, newMessageList)
        .data;
  }

  Uint8List shrinkNative(Uint8List bytes, List<int> messagesToKeep) {
    var deserializer = NativeDeserializer(bytes);
    var messageList = deserializer.deserialize();
    var serialized = NativeSerializer(deserializer.hasIds).serialize(
      messageList.hash,
      messageList.locale,
      messagesToKeep.map((index) => messageList.messages[index]).toList(),
    );
    return serialized.data;
  }
}

class JsonExtraction {
  final String before;
  final String json;
  final String after;

  JsonExtraction(this.before, this.json, this.after);
}

JsonExtraction extractJsonFromClass(String buffer) {
  var jsonStart = buffer.indexOf('r\'');
  var jsonEnd = buffer.lastIndexOf('\';');
  return JsonExtraction(
    buffer.substring(0, jsonStart + 2),
    buffer.substring(jsonStart + 2, jsonEnd),
    buffer.substring(jsonEnd),
  );
}
