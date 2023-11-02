// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: non_constant_identifier_names
import 'intl_object.dart';

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
  IntlObject get intl;

  String generateStringAtId(String id, List args);
}

enum PluralEnum {
  zeroWord,
  zeroNumber,
  oneWord,
  oneNumber,
  twoWord,
  twoNumber,
  few,
  many,
}

class Plural {
  static const int zeroWord = 1;
  static const int zeroNumber = 2;
  static const int oneWord = 3;
  static const int oneNumber = 4;
  static const int twoWord = 5;
  static const int twoNumber = 6;
  static const int few = 7;
  static const int many = 8;
}

class Gender {
  static const int female = 1;
  static const int male = 2;
}
