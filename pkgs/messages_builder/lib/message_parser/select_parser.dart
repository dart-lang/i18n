import 'package:messages/messages.dart';

import 'icu_message_parser.dart';
import 'message_parser.dart';

class SelectParser {
  SelectMessage parse(Node node, List<String> arguments,
      [bool addId = false, String? id]) {
    final identifier = node.children
        .firstWhere((element) => element.type == ST.identifier)
        .value!;
    if (!arguments.contains(identifier)) arguments.add(identifier);

    final parts = node.children
        .firstWhere((element) => element.type == ST.selectParts)
        .children;
    final cases = parts
        .where((element) => element.type == ST.selectPart)
        .map((e) => MapEntry(
            e.children[0].value!,
            MessageParser.parseNode(
              e.children.firstWhere((element) => element.type == ST.message),
              arguments,
            )!))
        .whereType<MapEntry<String, Message>>();
    final caseMap = Map.fromEntries(cases.where((e) => e.key != 'other'));
    return SelectMessage(
      cases.firstWhere((element) => element.key == 'other').value,
      caseMap,
      arguments.indexOf(identifier),
      id,
    );
  }
}
