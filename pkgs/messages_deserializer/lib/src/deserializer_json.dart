// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:messages/messages_json.dart';

import 'deserializer.dart';

class JsonDeserializer extends Deserializer<MessageListJson> {
  final List _parsed;
  final List<int> messageOffsets = [];
  final List<Message> _messages = [];

  JsonDeserializer(String data) : _parsed = jsonDecode(data) as List;

  @override
  MessageListJson deserialize(IntlObject intl) {
    if (_parsed[0] != VERSION) {
      throw ArgumentError(
          '''This message has version ${_parsed[0]}, while the deserializer has version $VERSION''');
    }
    for (var i = jsonPreambleLength; i < _parsed.length; i++) {
      _messages.add(getMessage(_parsed[i], true));
    }
    return MessageListJson(hash, locale, hasId, _messages, intl);
  }

  String get locale => _parsed[1] as String;

  String get hash => _parsed[2] as String;

  bool get hasId => _parsed[3] == 1;

  Message getMessage(dynamic message, [bool isTopLevel = false]) {
    if (message is List) {
      final type = message[0];
      int start;
      String? id;
      if (isTopLevel && hasId) {
        start = 2;
        id = message[1] as String;
      } else {
        start = 1;
      }
      if (type == PluralMessage.type) {
        return _forPlural(message, start, id);
      } else if (type == SelectMessage.type) {
        return _forSelect(message, start, id);
      } else if (type == GenderMessage.type) {
        return _forGender(message, start, id);
      } else if (type == CombinedMessage.type) {
        return _forCombined(message, start, id);
      } else {
        return _forString(message, start - 1, id);
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
      final stringIndex = int.parse(pair[0] as String, radix: 36);
      final argIndex = int.parse(pair[1] as String, radix: 36);
      argPositions.add((stringIndex: stringIndex, argIndex: argIndex));
    }
    return StringMessage(value, argPositions: argPositions, id: id);
  }

  PluralMessage _forPlural(List<dynamic> message, int start, String? id) {
    final argIndex = message[start] as int;
    final otherMessage = getMessage(message[start + 1]);
    Message? zeroWordMessage;
    Message? zeroNumberMessage;
    Message? oneWordMessage;
    Message? oneNumberMessage;
    Message? twoWordMessage;
    Message? twoNumberMessage;
    Message? fewMessage;
    Message? manyMessage;
    final submessages = List.castFrom(message[start + 2] as List);
    for (var i = 0; i < submessages.length - 1; i += 2) {
      final msg = getMessage(submessages[i + 1]);
      switch (submessages[i]) {
        case Plural.zeroWord:
          zeroWordMessage = msg;
          break;
        case Plural.zeroNumber:
          zeroNumberMessage = msg;
          break;
        case Plural.oneWord:
          oneWordMessage = msg;
          break;
        case Plural.oneNumber:
          oneNumberMessage = msg;
          break;
        case Plural.twoWord:
          twoWordMessage = msg;
          break;
        case Plural.twoNumber:
          twoNumberMessage = msg;
          break;
        case Plural.few:
          fewMessage = msg;
          break;
        case Plural.many:
          manyMessage = msg;
          break;
      }
    }
    return PluralMessage(
      zeroNumber: zeroNumberMessage,
      zeroWord: zeroWordMessage,
      oneNumber: oneNumberMessage,
      oneWord: oneWordMessage,
      twoNumber: twoNumberMessage,
      twoWord: twoWordMessage,
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
    final submessages = Map.castFrom(message[start + 2] as Map);
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

  GenderMessage _forGender(List<dynamic> message, int start, String? id) {
    final argIndex = message[start] as int;
    final otherMessage = getMessage(message[start + 1]);
    final submessages = message[start + 2] as List;
    Message? femaleMessage;
    Message? maleMessage;
    for (var i = 0; i < submessages.length - 1; i += 2) {
      final msg = getMessage(submessages[i + 1]);
      switch (submessages[i]) {
        case Gender.female:
          femaleMessage = msg;
          break;
        case Gender.male:
          maleMessage = msg;
          break;
      }
    }
    return GenderMessage(
      female: femaleMessage,
      male: maleMessage,
      other: otherMessage,
      argIndex: argIndex,
      id: id,
    );
  }
}
