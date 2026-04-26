// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/messages.dart';

import 'icu_message_parser.dart';
import 'plural_parser.dart';
import 'select_parser.dart';

class MessageParser {
  static (Message, List<String>) parse(
    String debugString,
    String fileContents,
    String name,
  ) {
    final node = Parser(name, debugString, fileContents).parse();
    final arguments = <String>[];
    final message = parseNode(node, arguments, name) ?? StringMessage('');
    return (message, arguments);
  }

  static Message? parseNode(Node node, List<String> arguments, [String? name]) {
    final submessages = <Message>[];
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
          submessages.add(
            StringMessage(
              '',
              argPositions: [
                (argIndex: arguments.indexOf(identifier), stringIndex: 0),
              ],
            ),
          );
          break;
        case ST.selectExpr:
          submessages.add(SelectParser().parse(child, arguments));
          break;
        default:
          break;
      }
    }
    if (submessages.isEmpty) {
      return null;
    }
    final fold = submessages.fold(<Message>[], (messages, message) {
      if (messages.isNotEmpty &&
          message is StringMessage &&
          messages.last is StringMessage) {
        final last = messages.removeLast() as StringMessage;
        return [...messages, combineStringMessages(last, message)];
      } else {
        return [...messages, message];
      }
    });
    if (fold.length == 1) {
      return fold.first;
    } else {
      return CombinedMessage(fold);
    }
  }

  static StringMessage combineStringMessages(
    StringMessage message1,
    StringMessage message2,
  ) =>
      StringMessage(
        message1.value + message2.value,
        argPositions: [
          ...message1.argPositions,
          ...message2.argPositions.map(
            (e) => (
              argIndex: e.argIndex,
              stringIndex: e.stringIndex + message1.value.length,
            ),
          ),
        ],
      );
}
