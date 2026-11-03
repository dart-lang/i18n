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
    String name, {
    bool addId = false,
  }) {
    final node = Parser(name, debugString, fileContents).parse();
    final arguments = <String>[];
    final message =
        parseNode(node, arguments, name, addId) ?? StringMessage('');
    final placeholders = arguments.map(Placeholder.new).toList();
    return ParameterizedMessage(message, name, placeholders);
  }

  static Message? parseNode(
    Node node,
    List<String> arguments, [
    String? name,
    bool addId = false,
  ]) {
    final id = addId ? name : null;
    final submessages = <Message>[];

    // The text and placeholders since the last plural or select, which are
    // combined into a single [StringMessage].
    final text = StringBuffer();
    final argPositions = <({int argIndex, int stringIndex})>[];
    void addText() {
      if (text.isNotEmpty || argPositions.isNotEmpty) {
        submessages.add(StringMessage(
          text.toString(),
          argPositions: [...argPositions],
          id: id,
        ));
        text.clear();
        argPositions.clear();
      }
    }

    for (var child in node.children) {
      switch (child.type) {
        case ST.string:
          text.write(child.value!);
          break;
        case ST.pluralExpr:
          addText();
          submessages.add(PluralParser().parse(child, arguments, addId, name));
          break;
        case ST.placeholderExpr:
          final identifier = child.children
              .firstWhere((element) => element.type == ST.identifier)
              .value!;
          if (!arguments.contains(identifier)) {
            arguments.add(identifier);
          }
          argPositions.add((
            argIndex: arguments.indexOf(identifier),
            stringIndex: text.length,
          ));
          break;
        case ST.selectExpr:
          addText();
          submessages.add(SelectParser().parse(child, arguments, addId, name));
          break;
        default:
          break;
      }
    }
    addText();

    return switch (submessages) {
      [] => null,
      [final message] => message,
      _ => CombinedMessage(id, submessages),
    };
  }
}
