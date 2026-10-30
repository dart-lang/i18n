// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: non_constant_identifier_names
import 'message.dart';
import 'plural_selector.dart';

export 'message.dart';

/// The version of the serializer/deserializer, to make sure there is no
/// mismatch when trying to deserialize messages. To be updated whenever there
/// is a breaking change.
const int serializationVersion = 0;

/// Type definition for loading asset file contents by asset ID.
typedef AssetLoader = Future<String> Function(String id);

/// Metadata about the MessageList
abstract class Preamble {
  int get version;

  String get locale;

  String get hash;

  static int length = 3;
}

/// Deserialized static message data payload.
abstract class MessageData {
  Preamble get preamble;
  List<Message> get messages;

  int getIndex(int index);
}

/// Runtime message list wrapper bound to a [PluralSelector].
abstract class MessageList {
  Preamble get preamble;
  PluralSelector get pluralSelector;

  String generateStringAtIndex(int index, List<Object?> args);
}

sealed class PluralMarker {
  static const String wordCase = 'w';
  static const String few = 'f';
  static const String many = 'm';
}
