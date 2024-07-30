// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:messages/messages_json.dart';

import 'serializer.dart';

class JsonSerializer extends Serializer<String> {
  final List result = [];

  JsonSerializer([super.writeIds = false]);

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
      hasIds: writeIds,
    );

    result.addAll(preamble.toJson());

    final messageMapping = <String, String>{};
    var messageCounter = 0;
    for (var i = 0; i < messages.length; i++) {
      if (keepOnly?.contains(i) ?? true) {
        encodeMessage(messages[i], isVisible: true);
        messageMapping[i.toRadixString(serializationRadix)] =
            messageCounter.toRadixString(serializationRadix);
        messageCounter++;
      }
    }

    /// Insert `null` instead of the full messageMapping to save space.
    result.insert(Preamble.length, keepOnly != null ? messageMapping : null);

    return Serialization(jsonEncode(result));
  }

  Object encodeMessage(Message message, {bool isVisible = false}) {
    // print('Encode message $message');
    Object messageIndex;
    if (message is StringMessage) {
      messageIndex = encodeString(message, isVisible);
    } else if (message is SelectMessage) {
      messageIndex = encodeSelect(message, isVisible);
    } else if (message is PluralMessage) {
      messageIndex = encodePlural(message, isVisible);
    } else if (message is CombinedMessage) {
      messageIndex = encodeCombined(message, isVisible);
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
  /// If the id does not have to be written, and there are no placeholders:
  /// * the String value
  /// else:
  /// * int | the StringMessage type
  /// * if we write IDs: String | the message id
  /// * String | the String value
  /// * if there are placeholders: List\<List\> | the position pairs:
  ///   * List\<int\> | a pair of position in the string - number of the placeholder
  Object encodeString(StringMessage message, bool isVisible) {
    final containsArgs = message.argPositions.isNotEmpty;
    if ((message.id == null || isVisible == false) && !containsArgs) {
      return message.value;
    }
    final m = <Object>[];
    addId(message, m, isVisible);
    m.add(message.value);
    if (containsArgs) {
      final positions = message.argPositions
        ..sort((a, b) => a.stringIndex.compareTo(b.stringIndex));
      for (var i = 0; i < positions.length; i++) {
        m.add(<int>[positions[i].stringIndex, positions[i].argIndex]);
      }
    }
    return m;
  }

  /// Encodes a select message as follows:
  ///
  /// * int | the SelectMessage type
  /// * if we write IDs: String | the message id
  /// * int | the argument index on which the select switches
  /// * Map\<String, int\> | the cases:
  ///   * MapEntry\<String, int\> | a case mapped to the message it represents
  List encodeSelect(SelectMessage message, bool isVisible) {
    final m = <Object>[];
    m.add(SelectMessage.type);
    addId(message, m, isVisible);
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
  /// * if we write IDs: String | the message id
  /// * int | the argument index on which the plural switches
  /// * int | the index of the other case message, which must be present
  /// * List\<int\> | the cases, which are added in pairs of two:
  ///   * int | the case index as encoded by the constants in `Plural`
  ///   * int | the message index of the case
  List encodePlural(PluralMessage message, bool isVisible) {
    final m = <Object>[];
    m.add(PluralMessage.type);
    addId(message, m, isVisible);
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
  /// * if we write IDs: String | the message id
  /// * List\<int\> | the submessage IDs
  ///   * int | the index of the submessage
  List encodeCombined(CombinedMessage message, bool isVisible) {
    final m = <Object>[];
    m.add(CombinedMessage.type);
    addId(message, m, isVisible);
    for (var submessage in message.messages) {
      m.add(encodeMessage(submessage));
    }
    return m;
  }

  /// Add a non-null ID iff `writeIds` is enabled
  void addId(Message message, List<dynamic> m, bool isVisible) {
    if (writeIds && message.id != null && isVisible) m.add(message.id!);
  }

  int addMessage(dynamic m) {
    result.add(m);
    return result.length - 1;
  }

  @override
  String get extension => '.json';
}
