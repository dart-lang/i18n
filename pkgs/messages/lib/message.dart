// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart' as old_intl;

abstract class Message {
  final String? id;

  Message(this.id);

  String generateString(
    List allArgs, {
    String? locale,
    String Function(String p1)? cleaner,
  });
}

class CombinedMessage extends Message {
  final List<Message> messages;

  CombinedMessage(super.id, this.messages);

  @override
  String generateString(
    List allArgs, {
    String Function(String p1)? cleaner,
    String? locale,
  }) =>
      messages
          .map((e) => e.generateString(
                allArgs,
                cleaner: cleaner,
                locale: locale,
              ))
          .join();
  static const int type = 6;
}

class StringMessage extends Message {
  final String value;

  /// Maps argument indices to their position in the string, where they are to
  /// be inserted.
  final Map<int, int> argPositions;

  StringMessage(this.value, {this.argPositions = const {}, String? id})
      : super(id);

  static const int type = 1;

  @override
  generateString(
    List allArgs, {
    String Function(String p1)? cleaner,
    String? locale,
  }) {
    var s = cleaner?.call(value) ?? value;
    if (argPositions.isNotEmpty) {
      var positions = argPositions.keys.toList();
      var sb = StringBuffer(value.substring(0, positions[0]));
      for (var i = 0; i < positions.length; i++) {
        var position = positions[i];
        sb.write(allArgs[argPositions[position]!]);
        sb.write(value.substring(
          position,
          i + 1 < positions.length ? positions[i + 1] : s.length,
        ));
      }
      return sb.toString();
    } else {
      return s;
    }
  }
}

class GenderMessage extends Message {
  final Message? male;
  final Message? female;
  final Message other;
  final int argIndex;

  GenderMessage({
    this.male,
    this.female,
    required this.other,
    required this.argIndex,
    String? id,
  }) : super(id);

  static const int type = 5;

  @override
  String generateString(List allArgs,
      {String Function(String p1)? cleaner, String? locale}) {
    return old_intl.Intl.genderLogic(
      allArgs[argIndex],
      female: female,
      male: male,
      other: other,
    ).generateString(allArgs, cleaner: cleaner, locale: locale);
  }
}

class PluralMessage extends Message {
  final Message? zeroWord;
  final Message? zeroNumber;
  final Message? oneWord;
  final Message? oneNumber;
  final Message? twoWord;
  final Message? twoNumber;
  final Message? few;
  final Message? many;
  final Message other;
  final int argIndex;

  PluralMessage({
    this.few,
    this.many,
    required this.other,
    this.zeroWord,
    this.zeroNumber,
    this.oneWord,
    this.oneNumber,
    this.twoWord,
    this.twoNumber,
    required this.argIndex,
    String? id,
  }) : super(id);

  static const int type = 3;

  @override
  String generateString(List allArgs,
      {String Function(String p1)? cleaner, String? locale}) {
    return old_intl.Intl.pluralLogic(
      allArgs[argIndex],
      few: few,
      many: many,
      zero: zeroNumber ?? zeroWord,
      one: oneNumber ?? oneWord,
      two: twoNumber ?? twoWord,
      other: other,
      locale: locale,
    ).generateString(allArgs, cleaner: cleaner, locale: locale);
  }
}

class SelectMessage extends Message {
  final Message other;
  final Map<String, Message> cases;
  final int argIndex;
  SelectMessage(
    this.other,
    this.cases,
    this.argIndex, [
    super.id,
  ]);

  static const int type = 4;

  @override
  String generateString(List allArgs,
      {String Function(String p1)? cleaner, String? locale}) {
    return old_intl.Intl.selectLogic(
      allArgs[argIndex],
      cases,
    ).generateString(allArgs, cleaner: cleaner, locale: locale);
  }
}
