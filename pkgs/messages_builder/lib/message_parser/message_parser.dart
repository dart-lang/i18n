// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/message_format.dart';
import 'package:messages_builder/message_with_metadata.dart';

import 'icu_message_parser.dart';
import 'plural_parser.dart';
import 'select_parser.dart';

class MessageParser {
  static MessageWithMetadata parse(
    String debugString,
    String fileContents, [
    String? name,
    bool addId = false,
  ]) {
    final node = Parser(name ?? 'id', debugString, fileContents).parse();
    var arguments = <String>[];
    var message = parseNode(node, arguments, name, addId) ?? StringMessage('');
    return MessageWithMetadata(message, arguments, name);
  }

  static Message? parseNode(
    Node node,
    List<String> arguments, [
    String? name,
    bool addId = false,
  ]) {
    var id = addId ? name : null;
    var submessages = <Message>[];
    for (var child in node.children) {
      switch (child.type) {
        case ST.string:
          submessages.add(StringMessage(child.value!, id: id));
          break;
        case ST.pluralExpr:
          submessages.add(PluralParser().parse(child, arguments, addId, name));
          break;
        case ST.placeholderExpr:
          var identifier = child.children
              .firstWhere((element) => element.type == ST.identifier)
              .value!;
          if (!arguments.contains(identifier)) arguments.add(identifier);
          submessages
              .add(_MessageWithPlaceholder(arguments.indexOf(identifier), id));
          break;
        case ST.selectExpr:
          submessages.add(SelectParser().parse(child, arguments, addId, name));
          break;
        default:
          break;
      }
    }
    if (submessages.isEmpty) {
      return null;
    } else if (submessages.length == 1) {
      return submessages.first;
    } else if (submessages.every((message) =>
        message is StringMessage || message is _MessageWithPlaceholder)) {
      var argPositions = <int, int>{};
      var s = StringBuffer();
      for (var i = 0; i < submessages.length; i++) {
        var submessage = submessages[i];
        if (submessage is StringMessage) {
          s.write(submessage.value);
        } else if (submessage is _MessageWithPlaceholder) {
          argPositions[s.length] = submessage.placeholderIndex;
        }
      }
      return StringMessage(s.toString(), argPositions: argPositions, id: id);
    } else {
      return CombinedMessage(id, submessages);
    }
  }
}

class _MessageWithPlaceholder extends Message {
  final int placeholderIndex;
  _MessageWithPlaceholder(this.placeholderIndex, [super.id]);

  @override
  String generateString(
    List allArgs, {
    String Function(String p1)? cleaner,
    String? locale,
  }) {
    throw UnimplementedError();
  }
}
