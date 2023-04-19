// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:messages_serializer/messages_serializer.dart';

import 'message_format.dart';

class MessageListNative extends MessageList {
  final List<Message> messages;
  final String _locale;
  final String _hash;

  final bool _hasIds;

  MessageListNative(this._locale, this._hash, this._hasIds, this.messages);

  factory MessageListNative.fromBuffer(Uint8List buffer) =>
      NativeDeserializer(buffer).deserialize();

  @override
  String generateStringAtIndex(int index, List args) =>
      messages[index].generateString(args);

  @override
  String generateStringAtId(String id, List args) {
    return messages
        .firstWhere((element) => element.id == id)
        .generateString(args);
  }

  @override
  String get hash => _hash;

  @override
  String get locale => _locale;

  @override
  bool get hasIds => _hasIds;
}
