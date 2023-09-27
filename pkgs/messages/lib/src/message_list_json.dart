// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages_deserializer/messages_deserializer_json.dart';

import 'intl_object.dart';
import 'message_format.dart';

class JsonPreamble extends Preamble {
  final List _data;

  JsonPreamble.build({
    required int serializationVersion,
    required String locale,
    required String hash,
    required bool hasIds,
  }) : _data = [
          serializationVersion,
          locale,
          hash,
          hasIds ? 1 : 0,
        ];

  JsonPreamble.parse(this._data);

  Iterable toJson() => _data;

  @override
  int get version => _data[0] as int;

  @override
  String get locale => _data[1] as String;

  @override
  String get hash => _data[2] as String;

  @override
  bool get hasIds => _data[3] == 1;
}

class MessageListJson extends MessageList {
  final List<Message> messages;
  final IntlObject _intl;
  final JsonPreamble _preamble;
  final Map<int, int>? messageIndices;

  @override
  IntlObject get intl => _intl;

  @override
  Preamble get preamble => _preamble;

  MessageListJson(
    this._preamble,
    this.messages,
    this._intl,
    this.messageIndices,
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
      messages[getIndex(index)].generateString(args, intl: _intl);

  int getIndex(int index) => messageIndices?[index] ?? index;
}
