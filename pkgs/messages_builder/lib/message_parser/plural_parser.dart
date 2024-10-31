// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/messages.dart';

import 'icu_message_parser.dart';
import 'message_parser.dart';

Map<String, int> numbers = {'zero': 0, 'one': 1, 'two': 2};

class PluralParser {
  MapEntry<T, Message>? getPluralCaseFrom<T>(
    T id,
    Node node,
    List<String> arguments,
  ) {
    final childMessage = node.children.firstWhere((e) => e.type == ST.message);
    final parsedMessage = MessageParser.parseNode(childMessage, arguments);
    if (parsedMessage != null) {
      return MapEntry(id, parsedMessage);
    } else {
      return null;
    }
  }

  Message? getNamed(
    List<Node> parts,
    String id,
    List<String> arguments,
  ) {
    final messages = parts
        .where((e) =>
            e.children[0].type == ST.identifier && e.children[0].value == id)
        .map((e) => e.children.firstWhere((e) => e.type == ST.message))
        .map((e) => MessageParser.parseNode(e, arguments))
        .whereType<Message>();
    if (messages.isNotEmpty) {
      return messages.first;
    }
    return null;
  }

  PluralMessage parse(Node node, List<String> arguments,
      [bool addId = false, String? name]) {
    final identifier = node.children
        .firstWhere((element) => element.type == ST.identifier)
        .value!;

    if (!arguments.contains(identifier)) arguments.add(identifier);

    final parts = node.children
        .firstWhere((element) => element.type == ST.pluralParts)
        .children;

    final numberCases = getNumberCases(parts, arguments);
    final wordCases = getWordCases(parts, arguments);
    return PluralMessage(
      numberCases: numberCases,
      wordCases: wordCases,
      few: getNamed(parts, 'few', arguments),
      many: getNamed(parts, 'many', arguments),
      other: getOther(parts, arguments)!,
      argIndex: arguments.indexOf(identifier),
      id: addId ? name : null,
    );
  }

  Map<int, Message> getNumberCases(List<Node> parts, List<String> arguments) {
    final numberCases = parts
        .where((node) =>
            node.children[0].type == ST.equalSign &&
            node.children[1].type == ST.number)
        .map((node) => getPluralCaseFrom(
              int.parse(node.children[1].value ?? ''),
              node,
              arguments,
            ))
        .whereType<MapEntry<int, Message>>();
    return Map.fromEntries(numberCases);
  }

  Map<int, Message> getWordCases(List<Node> parts, List<String> arguments) {
    final wordCases = parts
        .where((node) => node.children[0].type == ST.identifier)
        .where((node) => numbers.containsKey(node.children[0].value))
        .map((node) => getPluralCaseFrom(
              numbers[node.children[0].value!]!,
              node,
              arguments,
            ))
        .whereType<MapEntry<int, Message>>();
    return Map.fromEntries(wordCases);
  }

  Message? getOther(List<Node> parts, List<String> arguments) {
    final other = parts
        .where((e) => e.children[0].type == ST.other)
        .map((e) => e.children.firstWhere((e) => e.type == ST.message))
        .map((e) => MessageParser.parseNode(e, arguments))
        .whereType<Message>();
    return other.isNotEmpty ? other.first : null;
  }
}
