// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: non_constant_identifier_names
import 'intl_object.dart';

export 'message.dart';

const int version = 0;

final jsonPreambleLength = 4;

abstract class MessageList {
  String get locale;
  String get hash;
  bool get hasIds;
  IntlObject get intl;

  String generateStringAtIndex(int index, List args);

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
