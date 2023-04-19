// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'message_with_metadata.dart';
import 'message_parser/message_parser.dart';

class ArbParser {
  final bool addName;
  ArbParser([this.addName = false]);

  MessageListWithMetadata parseMessageFile(Map<String, dynamic> arb) {
    var locale = arb['@@locale'] as String?;
    var context = arb['@@context'] as String?;
    var isReference = arb.containsKey('@@x-reference') && arb['@@x-reference'];
    var messages = arb.keys
        .where((key) => !key.startsWith('@'))
        .map((key) => parseMessage(arb, key, '${context}_$locale'))
        .toList();
    return MessageListWithMetadata(messages, locale, context, isReference);
  }

  MessageWithMetadata parseMessage(
    Map<String, dynamic> arb,
    String messageKey,
    String debugString,
  ) {
    var messageContent = arb[messageKey] as String;
    var message = MessageParser.parse(
      debugString,
      messageContent,
      messageKey,
      addName,
    );
    var messageMetadata = arb['@$messageKey'];
    if (messageMetadata != null) {
      var metadata = messageMetadata as Map<String, dynamic>;
      var placeholdersWithMetadata =
          parsePlaceholderMetadata(metadata['placeholders'] ?? {});

      message.placeholders = message.placeholders
          .map((placeholder) => placeholdersWithMetadata.firstWhere(
                (p) => p.name == placeholder.name,
                orElse: () => placeholder,
              ))
          .toList();
    }
    return message;
  }

  List<Placeholder> parsePlaceholderMetadata(
    Map<String, dynamic> placeholders,
  ) {
    var placeholderTypes = <Placeholder>[];
    for (var entry in placeholders.entries) {
      var placeholderName = entry.key;
      var placeholderData = entry.value as Map<String, dynamic>;
      var type = placeholderData['type'] ?? 'String';
      placeholderTypes.add(Placeholder(placeholderName, type));
    }
    return placeholderTypes;
  }
}
