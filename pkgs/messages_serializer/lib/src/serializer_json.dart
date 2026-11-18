// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:messages/messages_json.dart';

import 'serializer.dart';

class JsonSerializer extends Serializer<String> {
  final List<Object?> result = [];

  JsonSerializer();

  @override
  Serialization<String> serialize(
    String hash,
    String locale,
    List<Message> messages, [
    List<int>? keepOnly,
  ]) {
    result.clear();

    final preamble = JsonPreamble.build(
      serializationVersion: serializationVersion,
      locale: locale,
      hash: hash,
    );

    result.addAll(preamble.toJson());

    final keptIndices = <int>[];
    for (var i = 0; i < messages.length; i++) {
      if (keepOnly?.contains(i) ?? true) {
        encodeMessage(messages[i], isVisible: true);
        if (keepOnly != null) {
          keptIndices.add(i);
        }
      }
    }

    /// Insert `null` instead of keptIndices to save space when all messages are
    /// kept.
    result.insert(Preamble.length, keepOnly != null ? keptIndices : null);

    return Serialization(jsonEncode(result));
  }

  Object encodeMessage(Message message, {bool isVisible = false}) {
    Object messageIndex;
    if (message is StringMessage) {
      messageIndex = encodeString(message);
    } else if (message is SelectMessage) {
      messageIndex = encodeSelect(message);
    } else if (message is PluralMessage) {
      messageIndex = encodePlural(message);
    } else if (message is CombinedMessage) {
      messageIndex = encodeCombined(message);
    } else {
      throw ArgumentError('Unknown message type');
    }
    if (isVisible == true) {
      addMessage(messageIndex);
    }
    return messageIndex;
  }

  /// Encodes a string message as follows:
  ///
  /// If there are no placeholders:
  /// * the String value
  /// else:
  /// * String | the String value
  /// * List\<List\> | the position pairs:
  ///   * List\<int\> | a pair of position in the string - number of the placeholder
  Object encodeString(StringMessage message) {
    final containsArgs = message.argPositions.isNotEmpty;
    if (!containsArgs) {
      return message.value;
    }
    final m = <Object>[];
    m.add(message.value);
    final positions = List.of(message.argPositions)
      ..sort((a, b) => a.stringIndex.compareTo(b.stringIndex));
    for (var i = 0; i < positions.length; i++) {
      m.add(<int>[positions[i].stringIndex, positions[i].argIndex]);
    }
    return m;
  }

  /// Encodes a select message as follows:
  ///
  /// * int | the SelectMessage type
  /// * int | the argument index on which the select switches
  /// * Map\<String, int\> | the cases:
  ///   * MapEntry\<String, int\> | a case mapped to the message it represents
  List<Object> encodeSelect(SelectMessage message) {
    final m = <Object>[];
    m.add(SelectMessage.type);
    m.add(message.argIndex);
    m.add(encodeMessage(message.other));
    final caseIndices = <String, Object>{};
    for (var entry in message.cases.entries) {
      caseIndices[entry.key] = encodeMessage(entry.value);
    }
    m.add(caseIndices);
    return m;
  }

  /// Encodes a plural message as follows:
  ///
  /// * int | the PluralMessage type
  /// * int | the argument index on which the plural switches
  /// * int | the index of the other case message, which must be present
  /// * List\<int\> | the cases, which are added in pairs of two:
  ///   * int | the case index as encoded by the constants in `Plural`
  ///   * int | the message index of the case
  List<Object> encodePlural(PluralMessage message) {
    final m = <Object>[];
    m.add(PluralMessage.type);
    m.add(message.argIndex);
    m.add(encodeMessage(message.other));
    final caseIndices = <Object>[];
    if (message.few != null) {
      caseIndices.add(PluralMarker.few);
      caseIndices.add(encodeMessage(message.few!));
    }
    if (message.many != null) {
      caseIndices.add(PluralMarker.many);
      caseIndices.add(encodeMessage(message.many!));
    }
    for (final MapEntry(key: caseIndex, value: messageIndex)
        in message.numberCases.entries) {
      caseIndices.add(caseIndex);
      caseIndices.add(encodeMessage(messageIndex));
    }
    for (final entry in message.wordCases.entries) {
      caseIndices.add(PluralMarker.wordCase + entry.key.toString());
      caseIndices.add(encodeMessage(entry.value));
    }
    m.add(caseIndices);
    return m;
  }

  /// Encodes a combined message as follows:
  ///
  /// * int | the CombinedMessage type
  /// * List\<int\> | the submessage IDs
  ///   * int | the index of the submessage
  List<Object> encodeCombined(CombinedMessage message) {
    final m = <Object>[];
    m.add(CombinedMessage.type);
    for (var submessage in message.messages) {
      m.add(encodeMessage(submessage));
    }
    return m;
  }

  int addMessage(Object m) {
    result.add(m);
    return result.length - 1;
  }

  @override
  String get extension => '.json';
}
