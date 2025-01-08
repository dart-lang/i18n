// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'message_file.dart';
import 'message_parser/message_parser.dart';
import 'parameterized_message.dart';
import 'placeholder.dart';

class ArbParser {
  ArbParser();

  MessageFile parseMessageFile(Map<String, dynamic> arb) {
    final locale = arb['@@locale'] as String?;
    final context = arb['@@context'] as String?;
    final messages = arb.keys
        .where((key) => !key.startsWith('@'))
        .map((key) => parseMessage(
              arb[key] as String,
              arb['@$key'] as Map<String, dynamic>?,
              key,
              '${context}_$locale',
            ))
        .toList();
    messages.sort((a, b) => a.name.compareTo(b.name));
    return MessageFile(
      messages,
      locale,
      context,
      getHash(arb),
      arb.keys.any((key) => key.startsWith('@') && !key.startsWith('@@')),
    );
  }

  String getHash(Map<String, dynamic> arb) {
    final digest = sha1.convert(arb.toString().codeUnits);
    return base64Encode(digest.bytes).substring(0, 8);
  }

  ParameterizedMessage parseMessage(
    String messageContent,
    Map<String, dynamic>? metadata,
    String name,
    String debugString,
  ) {
    final message = MessageParser.parse(
      debugString,
      messageContent,
      name,
    );
    final placeholdersMap = metadata?['placeholders'] as Map<String, dynamic>?;
    final placeholdersWithMetadata = placeholdersMap?.map(
          (name, metadata) {
            final type = (metadata as Map<String, dynamic>)['type'] as String?;
            return MapEntry(name, Placeholder(name, type ?? 'String'));
          },
        ) ??
        <String, Placeholder>{};

    final placeholders = message.placeholders
        .map((p) => placeholdersWithMetadata[p.name] ?? p)
        .toList();
    return ParameterizedMessage(message.message, message.name, placeholders);
  }
}
