// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'message_parser/message_parser.dart';
import 'message_with_metadata.dart';

class ArbParser {
  final bool addName;
  ArbParser([this.addName = false]);

  MessageListWithMetadata parseMessageFile(Map<String, dynamic> arb) {
    final locale = arb['@@locale'] as String?;
    final context = arb['@@context'] as String?;
    final templatePath = arb['@@x-template'] as String?;
    final messages = arb.keys
        .where((key) => !key.startsWith('@'))
        .map((key) => parseMessage(arb, key, '${context}_$locale'))
        .toList();
    return MessageListWithMetadata(
      messages,
      locale,
      context,
      templatePath == null,
    );
  }

  MessageWithMetadata parseMessage(
    Map<String, dynamic> arb,
    String messageKey,
    String debugString,
  ) {
    final messageContent = arb[messageKey] as String;
    final message = MessageParser.parse(
      debugString,
      messageContent,
      messageKey,
      addName,
    );
    final messageMetadata = arb['@$messageKey'];
    if (messageMetadata != null) {
      final metadata = messageMetadata as Map<String, dynamic>;
      final description = metadata['description'] as String?;
      final placeholdersMap = metadata['placeholders'] as Map<String, dynamic>?;
      final placeholders = placeholdersMap ?? <String, dynamic>{};
      final placeholdersWithMetadata = parsePlaceholderMetadata(placeholders);

      message.placeholders = message.placeholders
          .map((placeholder) => placeholdersWithMetadata.firstWhere(
                (p) => p.name == placeholder.name,
                orElse: () => placeholder,
              ))
          .toList();
      message.description = description;
    }
    return message;
  }

  List<Placeholder> parsePlaceholderMetadata(
    Map<String, dynamic> placeholders,
  ) {
    final placeholderTypes = <Placeholder>[];
    for (var entry in placeholders.entries) {
      final placeholderName = entry.key;
      final placeholderData = entry.value as Map<String, dynamic>;
      final type = (placeholderData['type'] as String?) ?? 'String';
      final example = placeholderData['example'] as String?;
      placeholderTypes.add(Placeholder(
        name: placeholderName,
        type: type,
        example: example,
      ));
    }
    return placeholderTypes;
  }
}
