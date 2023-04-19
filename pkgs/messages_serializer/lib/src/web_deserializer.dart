// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:messages/message_format.dart';
import 'package:messages_serializer/messages_serializer.dart';

class MessageListWeb extends MessageList {
  final String _hash;
  final String _locale;
  @override
  final bool hasIds;
  final List<Message> messages;

  MessageListWeb(this._hash, this._locale, this.hasIds, this.messages);

  @override
  String generateStringAtId(String id, List args) =>
      messages.where((element) => element.id == id).first.generateString(args);

  @override
  String generateStringAtIndex(int index, List args) =>
      messages[index].generateString(args);

  @override
  String get hash => _hash;

  @override
  String get locale => _locale;
}

class WebDeserializer extends Deserializer<MessageListWeb> {
  final List _parsed;
  final List<int> messageOffsets = [];
  final List<Message> _messages = [];

  WebDeserializer(String data) : _parsed = jsonDecode(data);

  @override
  MessageListWeb deserialize() {
    if (_parsed[0] != VERSION) {
      throw ArgumentError(
          'This message has version ${_parsed[0]}, while the deserializer has version $VERSION');
    }
    for (var i = jsonPreambleLength; i < _parsed.length; i++) {
      _messages.add(getMessage(_parsed[i], true));
    }
    return MessageListWeb(hash, locale, hasId, _messages);
  }

  String get locale => _parsed[1];

  String get hash => _parsed[2];

  bool get hasId => _parsed[3] == 1;

  Message getMessage(Object message, [bool isTopLevel = false]) {
    if (message is List) {
      var type = message[0];
      int start;
      String? id;
      if (isTopLevel && hasId) {
        start = 2;
        id = message[1];
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
    var value = message[start] as String;
    var argPositions = <int, int>{};
    for (var i = start + 1; i < message.length; i++) {
      var pair = message[i];
      final position = int.parse(pair[0], radix: 36);
      final argIndex = pair[1];
      argPositions[position] = argIndex;
    }
    return StringMessage(value, argPositions: argPositions, id: id);
  }

  PluralMessage _forPlural(List<dynamic> message, int start, String? id) {
    var argIndex = message[start];
    var otherMessage = getMessage(message[start + 1]);
    Message? zeroWordMessage;
    Message? zeroNumberMessage;
    Message? oneWordMessage;
    Message? oneNumberMessage;
    Message? twoWordMessage;
    Message? twoNumberMessage;
    Message? fewMessage;
    Message? manyMessage;
    List<Object> submessages = List.castFrom(message[start + 2]);
    for (var i = 0; i < submessages.length - 1; i += 2) {
      var msg = getMessage(submessages[i + 1]);
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
    var argIndex = message[start];
    var otherCase = getMessage(message[start + 1]);
    Map<String, Object> submessages = Map.castFrom(message[start + 2]);
    var cases = submessages.map(
        (caseName, caseMessage) => MapEntry(caseName, getMessage(caseMessage)));
    return SelectMessage(otherCase, cases, argIndex, id);
  }

  CombinedMessage _forCombined(List<dynamic> message, int start, String? id) {
    return CombinedMessage(
      id,
      message.skip(start).map((message) => getMessage(message)).toList(),
    );
  }

  GenderMessage _forGender(List<dynamic> message, int start, String? id) {
    var argIndex = message[start];
    var otherMessage = getMessage(message[start + 1]);
    var submessages = message[start + 2];
    Message? femaleMessage;
    Message? maleMessage;
    for (var i = 0; i < submessages.length - 1; i += 2) {
      var msg = getMessage(submessages[i + 1]);
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
