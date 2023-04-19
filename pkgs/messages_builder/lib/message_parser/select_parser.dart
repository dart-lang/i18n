// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/message.dart';

import 'icu_message_parser.dart';
import 'message_parser.dart';

class SelectParser {
  SelectMessage parse(Node node, List<String> arguments,
      [bool addId = false, String? id]) {
    var identifier = node.children
        .firstWhere((element) => element.type == ST.identifier)
        .value!;
    if (!arguments.contains(identifier)) arguments.add(identifier);

    var parts = node.children
        .firstWhere((element) => element.type == ST.selectParts)
        .children;
    var cases = parts
        .where((element) => element.type == ST.selectPart)
        .map((e) => MapEntry(
            e.children[0].value!,
            MessageParser.parseNode(
              e.children.firstWhere((element) => element.type == ST.message),
              arguments,
            )!))
        .whereType<MapEntry<String, Message>>();
    var caseMap = Map.fromEntries(cases.where((e) => e.key != 'other'));
    return SelectMessage(
      cases.firstWhere((element) => element.key == 'other').value,
      caseMap,
      arguments.indexOf(identifier),
      id,
    );
  }
}
