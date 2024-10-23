// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'message_parser/message_parser.dart';
import 'message_with_metadata.dart';

class ArbParser {
  final bool addName;
  ArbParser([this.addName = false]);

  MessagesWithMetadata parseMessageFile(Map<String, dynamic> arb) {
    final locale = arb['@@locale'] as String?;
    final context = arb['@@context'] as String?;
    final referencePath = arb['@@x-reference'] as String?;
    final messagesWithKeys = arb.keys
        .where((key) => !key.startsWith('@'))
        .map((key) => (key, parseMessage(arb, key, '${context}_$locale')))
        .toList();
    messagesWithKeys.sort((a, b) => a.$1.compareTo(b.$1));
    final messages = messagesWithKeys.map((e) => e.$2).toList();
    return MessagesWithMetadata(
      messages,
      locale,
      context,
      referencePath,
      getHash(arb),
      arb.keys.any((key) => key.startsWith('@') && !key.startsWith('@@')),
    );
  }

  String getHash(Map<String, dynamic> arb) {
    final digest = sha1.convert(arb.toString().codeUnits);
    return base64Encode(digest.bytes).substring(0, 8);
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
      addId: addName,
    );
    final messageMetadata = arb['@$messageKey'];
    if (messageMetadata != null) {
      final metadata = messageMetadata as Map<String, dynamic>;
      final placeholdersMap = metadata['placeholders'] as Map<String, dynamic>?;
      final placeholders = placeholdersMap ?? <String, dynamic>{};
      final placeholdersWithMetadata = parsePlaceholderMetadata(placeholders);

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
    final placeholderTypes = <Placeholder>[];
    for (var entry in placeholders.entries) {
      final placeholderName = entry.key;
      final placeholderData = entry.value as Map<String, dynamic>;
      final type = (placeholderData['type'] as String?) ?? 'String';
      placeholderTypes.add(Placeholder(placeholderName, type));
    }
    return placeholderTypes;
  }
}
