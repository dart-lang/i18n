import 'package:messages/message.dart';

import 'icu_message_parser.dart';
import 'message_parser.dart';

Map<String, int> numbers = {'one': 1, 'two': 2};

class PluralParser {
  MapEntry<T, Message>? getPluralCaseFrom<T>(
    T id,
    Node node,
    List<String> arguments,
  ) {
    var childMessage = node.children.firstWhere((e) => e.type == ST.message);
    var parsedMessage = MessageParser.parseNode(childMessage, arguments);
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
    var messages = parts
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
    var identifier = node.children
        .firstWhere((element) => element.type == ST.identifier)
        .value!;

    if (!arguments.contains(identifier)) arguments.add(identifier);

    var parts = node.children
        .firstWhere((element) => element.type == ST.pluralParts)
        .children;

    var numberCases = getNumberCases(parts, arguments);
    var wordCases = getWordCases(parts, arguments);
    return PluralMessage(
      zeroNumber: numberCases[0],
      zeroWord: wordCases[0],
      oneNumber: numberCases[1],
      oneWord: wordCases[1],
      twoNumber: numberCases[2],
      twoWord: wordCases[2],
      few: getNamed(parts, 'few', arguments),
      many: getNamed(parts, 'many', arguments),
      other: getOther(parts, arguments)!,
      argIndex: arguments.indexOf(identifier),
      id: addId ? name : null,
    );
  }

  Map<int, Message> getNumberCases(List<Node> parts, List<String> arguments) {
    var numberCases = parts
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
    var wordCases = parts
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
    var other = parts
        .where((e) => e.children[0].type == ST.other)
        .map((e) => e.children.firstWhere((e) => e.type == ST.message))
        .map((e) => MessageParser.parseNode(e, arguments))
        .whereType<Message>();
    return other.isNotEmpty ? other.first : null;
  }
}
