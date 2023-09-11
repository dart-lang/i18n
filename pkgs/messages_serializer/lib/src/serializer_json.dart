import 'dart:convert';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:messages/messages.dart';

import 'serializer.dart';

class JsonSerializer extends Serializer<String> {
  final List result = [];

  JsonSerializer([super.writeIds = false]);

  @override
  Serialization<String> serialize(
    String hash,
    String locale,
    List<Message> messages,
  ) {
    result.clear();

    var preamble = [
      VERSION,
      locale,
      hash,
      writeIds ? 1 : 0,
    ];

    result.addAll(preamble);

    for (var message in messages) {
      encodeMessage(message, isVisible: true);
    }

    var jsonString = jsonEncode(result);

    var lib = Library(
      (lb) => lb
        ..body.add(Class(
          (cb) => cb
            ..name = 'JsonData'
            ..fields.add(Field(
              (fb) => fb
                ..static = true
                ..modifier = FieldModifier.final$
                ..name = 'jsonData'
                ..type = Reference('String')
                ..assignment = Code('r\'$jsonString\''),
            )),
        )),
    );

    final emitter = DartEmitter(orderDirectives: true);
    var code = '${lib.accept(emitter)}';
    var formattedCode = DartFormatter().format(code);
    return Serialization(formattedCode);
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
    } else if (message is GenderMessage) {
      messageIndex = encodeGender(message, isVisible);
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
    var containsArgs = message.argPositions.isNotEmpty;
    if ((message.id == null || isVisible == false) && !containsArgs) {
      return message.value;
    }
    var m = [];
    addId(message, m, isVisible);
    m.add(message.value);
    if (containsArgs) {
      var positions = message.argPositions
        ..sort((a, b) => a.stringIndex.compareTo(b.stringIndex));
      for (var i = 0; i < positions.length; i++) {
        m.add([
          positions[i].stringIndex.toRadixString(36),
          positions[i].argIndex.toRadixString(36),
        ]);
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
    var m = [];
    m.add(SelectMessage.type);
    addId(message, m, isVisible);
    m.add(message.argIndex);
    m.add(encodeMessage(message.other));
    var caseIndices = <String, Object>{};
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
    var m = [];
    m.add(PluralMessage.type);
    addId(message, m, isVisible);
    m.add(message.argIndex);
    m.add(encodeMessage(message.other));
    var caseIndices = [];
    if (message.few != null) {
      caseIndices.add(Plural.few);
      caseIndices.add(encodeMessage(message.few!));
    }
    if (message.many != null) {
      caseIndices.add(Plural.many);
      caseIndices.add(encodeMessage(message.many!));
    }
    if (message.zeroNumber != null) {
      caseIndices.add(Plural.zeroNumber);
      caseIndices.add(encodeMessage(message.zeroNumber!));
    }
    if (message.zeroWord != null) {
      caseIndices.add(Plural.zeroWord);
      caseIndices.add(encodeMessage(message.zeroWord!));
    }
    if (message.oneNumber != null) {
      caseIndices.add(Plural.oneNumber);
      caseIndices.add(encodeMessage(message.oneNumber!));
    }
    if (message.oneWord != null) {
      caseIndices.add(Plural.oneWord);
      caseIndices.add(encodeMessage(message.oneWord!));
    }
    if (message.twoNumber != null) {
      caseIndices.add(Plural.twoNumber);
      caseIndices.add(encodeMessage(message.twoNumber!));
    }
    if (message.twoWord != null) {
      caseIndices.add(Plural.twoWord);
      caseIndices.add(encodeMessage(message.twoWord!));
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
    var m = [];
    m.add(CombinedMessage.type);
    addId(message, m, isVisible);
    for (var submessage in message.messages) {
      m.add(encodeMessage(submessage));
    }
    return m;
  }

  /// Encodes a gender message as follows:
  ///
  /// * int | the GenderMessage type
  /// * if we write IDs: String | the message id
  /// * int | the argument index on which the gender switches
  /// * int | the index of the other case message, which must be present
  /// * List\<int\> | the cases, which are added in pairs of two:
  ///   * int | the case index as encoded by the constants in `Gender`
  ///   * int | the message index of the case
  List encodeGender(GenderMessage message, bool isVisible) {
    var m = [];
    m.add(GenderMessage.type);
    addId(message, m, isVisible);
    m.add(message.argIndex);
    m.add(encodeMessage(message.other));
    var caseIndices = [];
    if (message.female != null) {
      caseIndices.add(Gender.female);
      caseIndices.add(encodeMessage(message.female!));
    }
    if (message.male != null) {
      caseIndices.add(Gender.male);
      caseIndices.add(encodeMessage(message.male!));
    }
    m.add(caseIndices);
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
}
