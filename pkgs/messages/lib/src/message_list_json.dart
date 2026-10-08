// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'deserializer/deserializer_json.dart';
import 'message_format.dart';
import 'plural_selector.dart';

class JsonPreamble extends Preamble {
  final List<Object?> _data;

  JsonPreamble.build({
    required int serializationVersion,
    required String locale,
    required String hash,
  }) : _data = [serializationVersion, locale, hash];

  JsonPreamble.parse(this._data);

  Iterable<Object?> toJson() => _data;

  @override
  int get version => _data[0] as int;

  @override
  String get locale => _data[1] as String;

  @override
  String get hash => _data[2] as String;
}

/// Static deserialized data payload for JSON messages.
class MessageDataJson implements MessageData {
  final JsonPreamble _preamble;
  @override
  final List<Message> messages;
  final Map<int, int>? messageIndices;

  @override
  Preamble get preamble => _preamble;

  MessageDataJson(this._preamble, this.messages, this.messageIndices);

  factory MessageDataJson.fromString(String string) =>
      JsonDeserializer(string).deserialize();

  @override
  int getIndex(int index) => messageIndices?[index] ?? index;
}

/// Runtime message list wrapping [MessageData] and bound to a [PluralSelector].
class MessageListJson extends MessageList {
  final MessageData data;
  final PluralSelector _selector;

  @override
  Preamble get preamble => data.preamble;

  @override
  PluralSelector get pluralSelector => _selector;

  MessageListJson(this.data, this._selector);

  factory MessageListJson.fromString(String string, PluralSelector selector) =>
      MessageListJson(MessageDataJson.fromString(string), selector);

  @override
  String generateStringAtIndex(int index, List<Object?> args) => data
      .messages[data.getIndex(index)]
      .generateString(args, locale: preamble.locale, pluralSelector: _selector);
}
