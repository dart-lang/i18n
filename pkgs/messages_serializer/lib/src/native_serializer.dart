// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:messages/message_format.dart';
import 'package:messages/varint.dart';
import 'package:messages_serializer/src/serializer.dart';

class NativeSerializer extends Serializer<Uint8List> {
  int pointer = 0;
  List<int> result = [];
  List<int> messageOffsets = [];

  NativeSerializer([super.writeIds = false]);

  @override
  Serialization<Uint8List> serialize(
    String hash,
    String locale,
    List<Message> messages,
  ) {
    addVarInt(VERSION);
    addString(hash);
    addString(locale);
    add(writeIds ? 1 : 0);
    for (var message in messages) {
      encodeMessage(message, true);
    }
    var offsetBlockStart = pointer;
    var offsetBlockStartVarint = VarInt.toVarint(offsetBlockStart);
    for (var i = 0; i < messageOffsets.length; i++) {
      addVarInt(messageOffsets[i] + offsetBlockStartVarint.length);
    }
    result.insertAll(0, offsetBlockStartVarint);
    return Serialization(Uint8List.fromList(result));
  }

  void addVarInt(int s) => addAll(VarInt.toVarint(s));

  void addString(String? s) {
    if (s != null) {
      addAll(utf8.encode(s));
    } else {
      add(NUL);
    }
    add(DELIMITER);
  }

  void addAll(List<int> data) {
    result.addAll(data);
    pointer += data.length;
  }

  void add(int data) {
    result.add(data);
    pointer += 1;
  }

  int encodeMessage(Message message, [bool isVisible = false]) {
    // print('Encode message $message');
    if (message is StringMessage) {
      encodeString(message, isVisible);
    } else if (message is SelectMessage) {
      encodeSelect(message, isVisible);
    } else if (message is PluralMessage) {
      encodePlural(message, isVisible);
    } else if (message is CombinedMessage) {
      encodeCombined(message, isVisible);
    } else if (message is GenderMessage) {
      encodeGender(message, isVisible);
    }
    return messageOffsets.length - 1;
  }

  void encodeString(StringMessage message, bool isVisible) {
    addMessage();
    var containsArgs = message.argPositions.isNotEmpty;
    addType(StringMessage.type, isVisible, message.id != null, containsArgs);
    // print('Add id ${message.id} to message ${message.value}');
    addId(message.id);
    if (containsArgs) {
      addVarInt(message.argPositions.length);
      var positions = message.argPositions.keys.toList()..sort();
      for (var i = 0; i < positions.length; i++) {
        addVarInt(positions[i]);
        addVarInt(message.argPositions[positions[i]]!);
      }
    }
    addAll(utf8.encode(message.value));
  }

  void encodeSelect(SelectMessage message, bool isVisible) {
    var casePointers = <String, int>{};
    for (var entry in message.cases.entries) {
      casePointers[entry.key] = encodeMessage(entry.value);
    }
    var otherMessagePointer = encodeMessage(message.other);

    addMessage();
    addType(SelectMessage.type, isVisible, message.id != null);
    addId(message.id);
    addVarInt(message.argIndex);
    addVarInt(otherMessagePointer);
    for (var entry in casePointers.entries) {
      addString(entry.key);
      addVarInt(entry.value);
    }
  }

  void encodePlural(PluralMessage message, bool isVisible) {
    var caseIndices = [];
    caseIndices.add(encodeMessage(message.other));
    var containsByte = 0;
    if (message.few != null) {
      caseIndices.add(encodeMessage(message.few!));
      containsByte += 1;
    }
    if (message.many != null) {
      caseIndices.add(encodeMessage(message.many!));
      containsByte += 1 << 1;
    }
    if (message.zeroNumber != null) {
      caseIndices.add(encodeMessage(message.zeroNumber!));
      containsByte += 1 << 2;
    }
    if (message.zeroWord != null) {
      caseIndices.add(encodeMessage(message.zeroWord!));
      containsByte += 1 << 3;
    }
    if (message.oneNumber != null) {
      caseIndices.add(encodeMessage(message.oneNumber!));
      containsByte += 1 << 4;
    }
    if (message.oneWord != null) {
      caseIndices.add(encodeMessage(message.oneWord!));
      containsByte += 1 << 5;
    }
    if (message.twoNumber != null) {
      caseIndices.add(encodeMessage(message.twoNumber!));
      containsByte += 1 << 6;
    }
    if (message.twoWord != null) {
      caseIndices.add(encodeMessage(message.twoWord!));
      containsByte += 1 << 7;
    }
    addMessage();
    addType(PluralMessage.type, isVisible, message.id != null);
    addId(message.id);
    addVarInt(message.argIndex);
    add(containsByte);
    for (var index in caseIndices) {
      addVarInt(index);
    }
  }

  void encodeCombined(CombinedMessage message, bool isVisible) {
    var offsets = <int>[];
    for (var submessage in message.messages) {
      offsets.add(encodeMessage(submessage));
    }
    addMessage();
    addType(CombinedMessage.type, isVisible, message.id != null);
    addId(message.id);
    for (var offset in offsets) {
      addVarInt(offset);
    }
  }

  void encodeGender(GenderMessage message, bool isVisible) {
    var caseIndices = [];
    caseIndices.add(encodeMessage(message.other));
    var containsByte = 0;
    if (message.female != null) {
      caseIndices.add(encodeMessage(message.female!));
      containsByte += 1;
    }
    if (message.male != null) {
      caseIndices.add(encodeMessage(message.male!));
      containsByte += 1 << 1;
    }
    addMessage();
    addType(GenderMessage.type, isVisible, message.id != null);
    addId(message.id);
    addVarInt(message.argIndex);
    add(containsByte);
    for (var index in caseIndices) {
      addVarInt(index);
    }
  }

  void addId(String? id) {
    if (writeIds && id != null) {
      addString(id);
    }
  }

  void addMessage() {
    messageOffsets.add(pointer);
  }

  void addType(int type, bool isVisible, bool hasId, [bool hasArgs = false]) {
    add((type << 3) +
        ((hasId ? 1 : 0) << 2) +
        ((hasArgs ? 1 : 0) << 1) +
        (isVisible ? 1 : 0));
  }
}
