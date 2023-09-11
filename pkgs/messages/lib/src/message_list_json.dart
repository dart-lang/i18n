// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages_deserializer/messages_deserializer_json.dart';

import 'intl_object.dart';
import 'message_format.dart';

class MessageListJson extends MessageList {
  final String _hash;
  final String _locale;
  final List<Message> messages;
  final IntlObject _intl;

  @override
  final bool hasIds;
  @override
  IntlObject get intl => _intl;

  MessageListJson(
    this._hash,
    this._locale,
    this.hasIds,
    this.messages,
    this._intl,
  );

  factory MessageListJson.fromString(String string, IntlObject intl) =>
      JsonDeserializer(string).deserialize(intl);

  @override
  String generateStringAtId(String id, List args) => messages
      .where((element) => element.id == id)
      .first
      .generateString(args, intl: _intl);

  @override
  String generateStringAtIndex(int index, List args) =>
      messages[index].generateString(args, intl: _intl);

  @override
  String get hash => _hash;

  @override
  String get locale => _locale;
}
