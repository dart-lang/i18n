// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:messages/message_format.dart';
import 'package:messages/message_native.dart';
import 'package:messages/varint.dart';
import 'package:messages_serializer/messages_serializer.dart';

class NativeDeserializer extends Deserializer<MessageListNative> {
  final Uint8List data;
  final List<int> messageOffsets = [];
  final List<Message> messages = [];

  NativeDeserializer(this.data);

  late bool hasIds;

  @override
  MessageListNative deserialize() {
    var offsetBlockVarInt = VarInt.fromVarint(data);
    var startOfOffsetBlock = offsetBlockVarInt.value + offsetBlockVarInt.length;
    var start = offsetBlockVarInt.length;

    var versionVarInt = VarInt.fromVarint(data, start);
    var version = versionVarInt.value;
    start += versionVarInt.length;

    if (version != VERSION) {
      throw ArgumentError(
          'This message has version $version, while the deserializer has version $VERSION');
    }

    var end = data.indexOf(DELIMITER, start);
    var hash = utf8.decode(Uint8List.sublistView(data, start, end));
    start = end + 1;

    end = data.indexOf(DELIMITER, start);
    var locale = utf8.decode(Uint8List.sublistView(data, start, end));
    start = end + 1;

    hasIds = data[start] == 1;

    setMessageOffsets(startOfOffsetBlock);
    var visibleMessages = decodeMessages(startOfOffsetBlock);
    return MessageListNative(
      locale,
      hash,
      hasIds,
      visibleMessages.map((e) => messages[e]).toList(growable: false),
    );
  }

// TODO: (mosum) Add number of offsets and messages to make this faster!!!
  void setMessageOffsets(int startOfMessageBlock) {
    var start = startOfMessageBlock;
    do {
      var varint = VarInt.fromVarint(data, start);
      messageOffsets.add(varint.value);
      start += varint.length;
    } while (start < data.length);
  }

  List<int> decodeMessages(int startOfMessageBlock) {
    var visibleMessages = <int>[];
    for (var i = 0; i < messageOffsets.length; i++) {
      int next;
      if (i + 1 < messageOffsets.length) {
        next = messageOffsets[i + 1];
      } else {
        next = startOfMessageBlock;
      }
      var messageOffset = messageOffsets[i];
      // print('Decode at $messageOffset');
      // print(data.sublist(messageOffset));
      messages.add(decodeMessage(messageOffset, next));
      if (data[messageOffset] & 1 == 1) {
        visibleMessages.add(messages.length - 1);
      }
    }
    return visibleMessages;
  }

  Message decodeMessage(int offset, int offsetEnd) {
    var messageData = Uint8List.sublistView(data, offset + 1, offsetEnd);
    // print('Decode message from $offset to $offsetEnd');
    // print(utf8.decode(messageData));
    String? id;
    if (messageData.isEmpty) {
      return StringMessage('');
    }
    var hasId = data[offset] >> 2 & 1;
    // print('Has id at ${data[offset].toRadixString(2)}: $hasId');
    if (hasIds && hasId == 1) {
      var indexOfDelimiter = messageData.indexOf(DELIMITER, 1);
      id = utf8.decode(Uint8List.sublistView(messageData, 0, indexOfDelimiter));
      messageData = Uint8List.sublistView(messageData, indexOfDelimiter + 1);
    }
    // print(id);
    var typeByte = data[offset] >> 3;
    if (typeByte == StringMessage.type) {
      return decodeStringMessage(offset, messageData, id);
    } else if (typeByte == SelectMessage.type) {
      return decodeSelectMessage(messageData, id);
    } else if (typeByte == PluralMessage.type) {
      return decodePluralMessage(messageData, id);
    } else if (typeByte == CombinedMessage.type) {
      return extractCombinedMessage(messageData, id);
    } else if (typeByte == GenderMessage.type) {
      return extractGenderMessage(messageData, id);
    }
    throw ArgumentError();
  }

  StringMessage decodeStringMessage(
    int offset,
    Uint8List messageData,
    String? id,
  ) {
    // print('Decode string message at $offset');
    // print(utf8.decode(messageData));
    var hasArgs = (data[offset] >> 1) & 1;
    // print(data[offset].toRadixString(2));
    if (hasArgs == 1) {
      var argIndices = <int, int>{};
      var numberArgsVarint = VarInt.fromVarint(messageData, 0);
      var start = numberArgsVarint.length;
      for (var i = 0; i < numberArgsVarint.value; i++) {
        var positionVarint = VarInt.fromVarint(messageData, start);
        start += positionVarint.length;
        var argIndexVarint = VarInt.fromVarint(messageData, start);
        start += argIndexVarint.length;
        argIndices[positionVarint.value] = argIndexVarint.value;
      }
      return StringMessage(
        utf8.decode(Uint8List.sublistView(messageData, start)),
        argPositions: argIndices,
        id: id,
      );
    } else {
      return StringMessage(utf8.decode(messageData), id: id);
    }
  }

  SelectMessage decodeSelectMessage(Uint8List messageData, String? id) {
    var argIndexVarint = VarInt.fromVarint(messageData, 0);
    var argIndex = argIndexVarint.value;
    var start = argIndexVarint.length;
    var cases = <String, Message>{};

    var otherCaseVarint = VarInt.fromVarint(messageData, start);
    var otherCase = messages[otherCaseVarint.value];
    var nextDelimiter = start + otherCaseVarint.length;
    do {
      //Get case name
      var caseStart = nextDelimiter;
      var caseEnd = messageData.indexOf(DELIMITER, caseStart);
      var caseNameData = Uint8List.sublistView(messageData, caseStart, caseEnd);
      var caseName = utf8.decode(caseNameData);
      //Get case message index
      var messageIndexStart = caseEnd + 1;
      var caseVarint = VarInt.fromVarint(messageData, messageIndexStart);
      var messageIndex = caseVarint.value;
      cases[caseName] = messages[messageIndex];
      nextDelimiter = messageIndexStart + caseVarint.length;
    } while (nextDelimiter < messageData.length);
    return SelectMessage(
      otherCase,
      cases,
      argIndex,
      id,
    );
  }

  PluralMessage decodePluralMessage(Uint8List messageData, String? id) {
    var varint = VarInt.fromVarint(messageData, 0);
    var argIndex = varint.value;
    var start = varint.length;

    var cases = <String, Message?>{};
    var containsByte = messageData[start];
    start += 1;
    final caseCodes = 'fmxaybzc'.codeUnits;
    varint = VarInt.fromVarint(messageData, start);
    start += varint.length;
    cases['o'] = messages[varint.value];
    for (var i = 0; i < caseCodes.length; i++) {
      if ((containsByte >> i) & 1 == 1) {
        varint = VarInt.fromVarint(messageData, start);
        start += varint.length;
        cases[String.fromCharCode(caseCodes[i])] = messages[varint.value];
      }
    }
    return PluralMessage(
      other: cases['o']!,
      few: cases['f'],
      many: cases['m'],
      zeroNumber: cases['x'],
      zeroWord: cases['a'],
      oneNumber: cases['y'],
      oneWord: cases['b'],
      twoNumber: cases['z'],
      twoWord: cases['c'],
      id: id,
      argIndex: argIndex,
    );
  }

  CombinedMessage extractCombinedMessage(Uint8List messageData, String? id) {
    var submessages = <Message>[];
    var offsetStart = 0;
    while (offsetStart < messageData.length) {
      var varint = VarInt.fromVarint(messageData, offsetStart);
      offsetStart += varint.length;
      submessages.add(messages[varint.value]);
    }
    return CombinedMessage(id, submessages);
  }

  GenderMessage extractGenderMessage(Uint8List messageData, String? id) {
    var varint = VarInt.fromVarint(messageData, 0);
    var argIndex = varint.value;
    var start = varint.length;

    var cases = <String, Message?>{};
    var containsByte = messageData[start];
    start += 1;
    var s = 'fm';
    varint = VarInt.fromVarint(messageData, start);
    start += varint.length;
    cases['o'] = messages[varint.value];
    for (var i = 0; i < s.codeUnits.length; i++) {
      if ((containsByte >> i) & 1 == 1) {
        varint = VarInt.fromVarint(messageData, start);
        start += varint.length;
        cases[s[i]] = messages[varint.value];
      }
    }
    return GenderMessage(
      other: cases['o']!,
      male: cases['m'],
      female: cases['f'],
      id: id,
      argIndex: argIndex,
    );
  }
}
