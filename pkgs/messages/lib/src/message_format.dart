// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: non_constant_identifier_names
import 'plural_selector.dart';

export 'message.dart';

/// The version of the serializer/deserializer, to make sure there is no
/// mismatch when trying to deserialize messages. To be updated whenever there
/// is a breaking change.
const int serializationVersion = 0;

/// Which radix to serialize messages with.
const int serializationRadix = 36;

/// Metadata about the MessageList
abstract class Preamble {
  int get version;

  String get locale;

  String get hash;

  bool get hasIds;

  static int length = 4;
}

abstract class MessageList {
  Preamble get preamble;
  PluralSelector get pluralSelector;

  String generateStringAtIndex(int index, List args);

  String generateStringAtId(String id, List args);
}

sealed class PluralMarker {
  static const String wordCase = 'w';
  static const String few = 'f';
  static const String many = 'm';
}
