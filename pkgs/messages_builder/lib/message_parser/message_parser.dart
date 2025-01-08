// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/messages.dart';

import '../parameterized_message.dart';
import '../placeholder.dart';
import 'icu_message_parser.dart';
import 'plural_parser.dart';
import 'select_parser.dart';

class MessageParser {
  static ParameterizedMessage parse(
    String debugString,
    String fileContents,
    String name,
  ) {
    final node = Parser(name, debugString, fileContents).parse();
    final arguments = <String>[];
    final message = parseNode(node, arguments, name) ?? StringMessage('');
    final placeholders = arguments.map(Placeholder.new).toList();
    return ParameterizedMessage(message, name, placeholders);
  }

  static Message? parseNode(
    Node node,
    List<String> arguments, [
    String? name,
  ]) {
    final submessages = <Message>[];
    final placeholders = <({int argIndex, int afterStringMessage})>[];
    for (var child in node.children) {
      switch (child.type) {
        case ST.string:
          submessages.add(StringMessage(child.value!));
          break;
        case ST.pluralExpr:
          submessages.add(PluralParser().parse(child, arguments));
          break;
        case ST.placeholderExpr:
          final identifier = child.children
              .firstWhere((element) => element.type == ST.identifier)
              .value!;
          if (!arguments.contains(identifier)) {
            arguments.add(identifier);
          }
          placeholders.add((
            argIndex: arguments.indexOf(identifier),
            afterStringMessage: submessages.length,
          ));
          break;
        case ST.selectExpr:
          submessages.add(SelectParser().parse(child, arguments));
          break;
        default:
          break;
      }
    }
    if (submessages.isEmpty && placeholders.isEmpty) {
      return null;
    } else if (submessages.length == 1 && placeholders.isEmpty) {
      return submessages.first;
    } else if (submessages.every((message) => message is StringMessage)) {
      return combineStringsAndPlaceholders(
        submessages.whereType<StringMessage>().toList(),
        placeholders,
      );
    } else {
      return CombinedMessage(submessages);
    }
  }

  static StringMessage combineStringsAndPlaceholders(
    List<StringMessage> submessages,
    List<({int afterStringMessage, int argIndex})> placeholders,
  ) {
    final argPositions = <({int argIndex, int stringIndex})>[];
    final s = StringBuffer();
    for (var i = 0; i < submessages.length + 1; i++) {
      placeholders
          .where((element) => element.afterStringMessage == i)
          .forEach((element) {
        argPositions.add((argIndex: element.argIndex, stringIndex: s.length));
      });
      if (i < submessages.length) {
        final submessage = submessages[i];
        s.write(submessage.value);
      }
    }
    return StringMessage(s.toString(), argPositions: argPositions);
  }
}
