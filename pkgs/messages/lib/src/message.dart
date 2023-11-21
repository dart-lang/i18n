// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'intl_object.dart';

sealed class Message {
  final String? id;

  Message(this.id);

  String generateString(
    List allArgs, {
    required IntlObject intl,
    String? locale,
    String Function(String p1)? cleaner,
  });
}

final class CombinedMessage extends Message {
  final List<Message> messages;

  CombinedMessage(super.id, this.messages);

  @override
  String generateString(
    List allArgs, {
    required IntlObject intl,
    String Function(String p1)? cleaner,
    String? locale,
  }) =>
      messages
          .map((e) => e.generateString(
                allArgs,
                intl: intl,
                cleaner: cleaner,
                locale: locale,
              ))
          .join();
  static const int type = 6;
}

final class StringMessage extends Message {
  final String value;

  /// Maps argument indices to their position in the string, where they are to
  /// be inserted.
  ///
  /// This list is expected to be sorted by `argPositions.stringIndex`
  final List<({int stringIndex, int argIndex})> argPositions;

  StringMessage(this.value, {this.argPositions = const [], String? id})
      : super(id);

  static const int type = 1;

  @override
  String generateString(
    List allArgs, {
    required IntlObject intl,
    String Function(String p1)? cleaner,
    String? locale,
  }) {
    final s = cleaner?.call(value) ?? value;
    if (argPositions.isNotEmpty) {
      final sb = StringBuffer(value.substring(0, argPositions[0].stringIndex));
      for (var i = 0; i < argPositions.length; i++) {
        final position = argPositions[i];
        sb.write(allArgs[position.argIndex]);
        sb.write(value.substring(
          position.stringIndex,
          i + 1 < argPositions.length
              ? argPositions[i + 1].stringIndex
              : s.length,
        ));
      }
      return sb.toString();
    } else {
      return s;
    }
  }
}

final class GenderMessage extends Message {
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
  String generateString(
    List allArgs, {
    required IntlObject intl,
    String Function(String p1)? cleaner,
    String? locale,
  }) {
    return intl
        .gender(
          allArgs[argIndex] as Gender,
          female,
          male,
          other,
        )
        .generateString(
          allArgs,
          intl: intl,
          cleaner: cleaner,
          locale: locale,
        );
  }
}

enum Gender {
  female,
  male,
  other;
}

final class PluralMessage extends Message {
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
  String generateString(
    List allArgs, {
    required IntlObject intl,
    String Function(String p1)? cleaner,
    String? locale,
  }) {
    return intl
        .plural(
          allArgs[argIndex] as num,
          few: few,
          many: many,
          zero: zeroNumber ?? zeroWord,
          one: oneNumber ?? oneWord,
          two: twoNumber ?? twoWord,
          other: other,
          locale: locale,
        )
        .generateString(allArgs, intl: intl, cleaner: cleaner, locale: locale);
  }
}

final class SelectMessage extends Message {
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
  String generateString(
    List allArgs, {
    required IntlObject intl,
    String Function(String p1)? cleaner,
    String? locale,
  }) {
    final selected =
        intl.select(allArgs[argIndex] as Object, {...cases, 'other': other});
    return selected.generateString(
      intl: intl,
      allArgs,
      cleaner: cleaner,
      locale: locale,
    );
  }
}
