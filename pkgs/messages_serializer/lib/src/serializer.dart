// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/message_format.dart';

class Serialization<T> {
  final T data;

  Serialization(this.data);
}

abstract class Deserializer<T extends MessageList> {
  T deserialize();
}

abstract class Serializer<T> {
  final bool writeIds;

  Serializer(this.writeIds);

  Serialization<T> serialize(
    String hash,
    String locale,
    List<Message> messages,
  );
}