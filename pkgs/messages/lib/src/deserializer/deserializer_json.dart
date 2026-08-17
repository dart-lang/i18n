// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import '../message_format.dart';
import '../message_list_json.dart';
import 'deserializer.dart';

class JsonDeserializer extends Deserializer<MessageDataJson> {
  final List<Object?> _parsed;
  final List<int> messageOffsets = [];
  final List<Message> _messages = [];
  late final JsonPreamble preamble;

  JsonDeserializer(String data)
    : _parsed = (jsonDecode(data) as List).cast<Object?>() {
    preamble = JsonPreamble.parse(_parsed);
  }

  @override
  MessageDataJson deserialize() {
    if (preamble.version != serializationVersion) {
      throw ArgumentError(
        '''This message has version ${preamble.version}, while the deserializer has version $serializationVersion''',
      );
    }
    final mappingList = _parsed[Preamble.length] as List<Object?>?;
    for (var i = Preamble.length + 1; i < _parsed.length; i++) {
      _messages.add(getMessage(_parsed[i]));
    }
    final messageIndices = mappingList != null
        ? Map.fromEntries(
            mappingList.cast<int>().indexed.map(
              (entry) => MapEntry(entry.$2, entry.$1),
            ),
          )
        : null;
    return MessageDataJson(preamble, _messages, messageIndices);
  }

  Message getMessage(Object? message) {
    if (message is List) {
      final typeOrId = message[0];
      final start = 1;
      if (typeOrId == PluralMessage.type) {
        return _forPlural(message, start);
      } else if (typeOrId == SelectMessage.type) {
        return _forSelect(message, start);
      } else if (typeOrId == CombinedMessage.type) {
        return _forCombined(message, start);
      } else if (typeOrId is String) {
        return _forString(message, 0);
      }
    } else if (message is String) {
      return StringMessage(message);
    }
    throw ArgumentError();
  }

  StringMessage _forString(List<Object?> message, int start) {
    final value = message[start] as String;
    final argPositions = <({int stringIndex, int argIndex})>[];
    for (var i = start + 1; i < message.length; i++) {
      final [stringIndex as int, argIndex as int] = message[i] as List;
      argPositions.add((stringIndex: stringIndex, argIndex: argIndex));
    }
    return StringMessage(value, argPositions: argPositions);
  }

  PluralMessage _forPlural(List<Object?> message, int start) {
    final argIndex = message[start] as int;
    final otherMessage = getMessage(message[start + 1]);
    Message? fewMessage;
    Message? manyMessage;
    final numberCases = <int, Message>{};
    final wordCases = <int, Message>{};
    final submessages = message[start + 2] as List<Object?>;
    for (var i = 0; i < submessages.length - 1; i += 2) {
      final msg = getMessage(submessages[i + 1]);
      final messageMarker = submessages[i];
      if (messageMarker case PluralMarker.few) {
        fewMessage = msg;
      } else if (messageMarker case PluralMarker.many) {
        manyMessage = msg;
      } else if (messageMarker case final int digit) {
        numberCases[digit] = msg;
      } else if (messageMarker is String &&
          messageMarker.startsWith(PluralMarker.wordCase)) {
        final digit = int.parse(messageMarker.substring(1));
        wordCases[digit] = msg;
      }
    }
    return PluralMessage(
      numberCases: numberCases,
      wordCases: wordCases,
      few: fewMessage,
      many: manyMessage,
      argIndex: argIndex,
      other: otherMessage,
    );
  }

  SelectMessage _forSelect(List<Object?> message, int start) {
    final argIndex = message[start] as int;
    final otherCase = getMessage(message[start + 1]);
    final submessages = message[start + 2] as Map<String, Object?>;
    final cases = submessages.map(
      (caseName, caseMessage) => MapEntry(caseName, getMessage(caseMessage)),
    );
    return SelectMessage(otherCase, cases, argIndex);
  }

  CombinedMessage _forCombined(List<Object?> message, int start) {
    return CombinedMessage(message.skip(start).map(getMessage).toList());
  }
}
