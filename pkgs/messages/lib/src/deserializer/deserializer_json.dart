// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import '../message_format.dart';
import '../message_list_json.dart';
import '../plural_selector.dart';
import 'deserializer.dart';

class JsonDeserializer extends Deserializer<MessageListJson> {
  final List _parsed;
  final List<int> messageOffsets = [];
  final List<Message> _messages = [];
  late final JsonPreamble preamble;

  JsonDeserializer(String data) : _parsed = jsonDecode(data) as List {
    preamble = JsonPreamble.parse(_parsed);
  }

  @override
  MessageListJson deserialize(PluralSelector intl) {
    if (preamble.version != serializationVersion) {
      throw ArgumentError(
          '''This message has version ${preamble.version}, while the deserializer has version $serializationVersion''');
    }
    final mapping = _parsed[Preamble.length] as Map<String, dynamic>?;
    for (var i = Preamble.length + 1; i < _parsed.length; i++) {
      _messages.add(getMessage(_parsed[i], true));
    }
    return MessageListJson(
      preamble,
      _messages,
      intl,
      mapping?.map((key, value) => MapEntry(
            int.parse(key, radix: serializationRadix),
            int.parse(value as String, radix: serializationRadix),
          )),
    );
  }

  Message getMessage(dynamic message, [bool isTopLevel = false]) {
    if (message is List) {
      final typeOrId = message[0];
      int start;
      String? id;
      if (isTopLevel && preamble.hasIds) {
        start = 2;
        id = message[1] as String;
      } else {
        start = 1;
      }
      if (typeOrId == PluralMessage.type) {
        return _forPlural(message, start, id);
      } else if (typeOrId == SelectMessage.type) {
        return _forSelect(message, start, id);
      } else if (typeOrId == CombinedMessage.type) {
        return _forCombined(message, start, id);
      } else if (typeOrId is String) {
        return _forString(message, start - 1, typeOrId);
      }
    } else if (message is String) {
      return StringMessage(message);
    }
    throw ArgumentError();
  }

  StringMessage _forString(List<dynamic> message, int start, String? id) {
    final value = message[start] as String;
    final argPositions = <({int stringIndex, int argIndex})>[];
    for (var i = start + 1; i < message.length; i++) {
      final pair = message[i] as List;
      final stringIndex = pair[0];
      final argIndex = pair[1];
      argPositions.add((stringIndex: stringIndex, argIndex: argIndex));
    }
    return StringMessage(value, argPositions: argPositions, id: id);
  }

  PluralMessage _forPlural(List<dynamic> message, int start, String? id) {
    final argIndex = message[start] as int;
    final otherMessage = getMessage(message[start + 1]);
    Message? fewMessage;
    Message? manyMessage;
    final numberCases = <int, Message>{};
    final wordCases = <int, Message>{};
    final submessages = message[start + 2] as List;
    for (var i = 0; i < submessages.length - 1; i += 2) {
      final msg = getMessage(submessages[i + 1]);
      final messageMarker = submessages[i];
      if (messageMarker case Plural.few) {
        fewMessage = msg;
      } else if (messageMarker case Plural.many) {
        manyMessage = msg;
      } else if (messageMarker case final int d) {
        numberCases[d] = msg;
      } else if (messageMarker is String &&
          messageMarker.startsWith(Plural.wordCase)) {
        wordCases[int.parse(messageMarker.substring(1))] = msg;
      }
    }
    return PluralMessage(
      numberCases: numberCases,
      wordCases: wordCases,
      few: fewMessage,
      many: manyMessage,
      argIndex: argIndex,
      other: otherMessage,
      id: id,
    );
  }

  SelectMessage _forSelect(List<dynamic> message, int start, String? id) {
    final argIndex = message[start] as int;
    final otherCase = getMessage(message[start + 1]);
    final submessages = message[start + 2] as Map;
    final cases = submessages.map((caseName, caseMessage) => MapEntry(
          caseName as String,
          getMessage(caseMessage),
        ));
    return SelectMessage(otherCase, cases, argIndex, id);
  }

  CombinedMessage _forCombined(List<dynamic> message, int start, String? id) {
    return CombinedMessage(
      id,
      message.skip(start).map(getMessage).toList(),
    );
  }
}
