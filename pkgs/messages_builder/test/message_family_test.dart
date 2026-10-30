// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:messages/messages_json.dart';
import 'package:messages_builder/arb_parser.dart';
import 'package:messages_builder/located_message_file.dart';
import 'package:messages_builder/message_family.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:test/test.dart';

Message _otherSelector(
  num howMany,
  String locale, {
  Map<int, Message>? numberCases,
  Map<int, Message>? wordCases,
  Message? few,
  Message? many,
  required Message other,
}) =>
    other;

/// Parses [arb] the same way as an ARB file read from disk.
LocatedMessageFile _parse(String path, Map<String, Object?> arb) =>
    LocatedMessageFile(
      path: path,
      file: ArbParser().parseMessageFile(
          jsonDecode(jsonEncode(arb)) as Map<String, dynamic>),
    );

/// Serializes [file] and looks up the message at [index], the same way as
/// the generated code does.
String _lookup(LocatedMessageFile file, int index,
    [List<Object> args = const []]) {
  final data = JsonSerializer()
      .serialize(file.hash, file.locale,
          file.file.messages.map((message) => message.message).toList())
      .data;
  return MessageListJson.fromString(data, _otherSelector)
      .generateStringAtIndex(index, args);
}

final _fruits = {
  '@@locale': 'en',
  '@@context': 'Fruits',
  'apple': 'Apple',
  '@apple': {'description': 'A fruit.'},
  'banana': 'Banana',
  'cherry': 'Cherry',
};

final _greeting = {
  '@@locale': 'en',
  '@@context': 'Greeting',
  'greet': 'Hello {first} {last}',
  '@greet': {
    'placeholders': {'first': <String, Object?>{}, 'last': <String, Object?>{}},
  },
};

void main() {
  test('missing translations fall back to the template', () {
    final warnings = <String>[];
    final family = groupIntoFamilies(
      [
        _parse('fruits.arb', _fruits),
        _parse('fruits_fr.arb', {
          '@@locale': 'fr',
          '@@context': 'Fruits',
          'apple': 'Pomme',
          'cherry': 'Cerise',
        }),
      ],
      warn: warnings.add,
    ).single;

    final fr = family.files.singleWhere((file) => file.locale == 'fr');
    expect(fr.file.messages.map((message) => message.name),
        ['apple', 'banana', 'cherry']);
    expect(_lookup(fr, 0), 'Pomme');
    expect(_lookup(fr, 1), 'Banana');
    expect(_lookup(fr, 2), 'Cerise');
    expect(warnings, [contains('banana')]);
  });

  test('messages which are not in the template are dropped', () {
    final warnings = <String>[];
    final family = groupIntoFamilies(
      [
        _parse('fruits.arb', _fruits),
        _parse('fruits_fr.arb', {
          '@@locale': 'fr',
          '@@context': 'Fruits',
          'apple': 'Pomme',
          'avocado': 'Avocat',
          'banana': 'Banane',
          'cherry': 'Cerise',
        }),
      ],
      warn: warnings.add,
    ).single;

    final fr = family.files.singleWhere((file) => file.locale == 'fr');
    expect(fr.file.messages.map((message) => message.name),
        ['apple', 'banana', 'cherry']);
    expect(_lookup(fr, 1), 'Banane');
    expect(warnings, [contains('avocado')]);
  });

  test('translations can reorder placeholders', () {
    final family = groupIntoFamilies([
      _parse('greeting.arb', _greeting),
      _parse('greeting_fr.arb', {
        '@@locale': 'fr',
        '@@context': 'Greeting',
        'greet': 'Bonjour {last} {first}',
      }),
    ]).single;

    final en = family.template;
    final fr = family.files.singleWhere((file) => file.locale == 'fr');
    expect(_lookup(en, 0, ['Ada', 'Lovelace']), 'Hello Ada Lovelace');
    expect(_lookup(fr, 0, ['Ada', 'Lovelace']), 'Bonjour Lovelace Ada');
  });

  test('translations can reorder plural arguments', () {
    final family = groupIntoFamilies([
      _parse('items.arb', {
        '@@locale': 'en',
        '@@context': 'Items',
        'items': '{count, plural, =1{One item} other{{count} items}} '
            'for {name}',
        '@items': {
          'placeholders': {
            'count': {'type': 'int'},
            'name': {'type': 'String'},
          },
        },
      }),
      _parse('items_fr.arb', {
        '@@locale': 'fr',
        '@@context': 'Items',
        'items': '{name} a {count, plural, =1{un article} '
            'other{{count} articles}}',
      }),
    ]).single;

    final en = family.template;
    final fr = family.files.singleWhere((file) => file.locale == 'fr');
    expect(_lookup(en, 0, [3, 'Ada']), '3 items for Ada');
    expect(_lookup(fr, 0, [3, 'Ada']), 'Ada a 3 articles');
  });

  test('translations with unknown placeholders fall back to the template', () {
    final warnings = <String>[];
    final family = groupIntoFamilies(
      [
        _parse('greeting.arb', _greeting),
        _parse('greeting_fr.arb', {
          '@@locale': 'fr',
          '@@context': 'Greeting',
          'greet': 'Bonjour {nom}',
        }),
      ],
      warn: warnings.add,
    ).single;

    final fr = family.files.singleWhere((file) => file.locale == 'fr');
    expect(_lookup(fr, 0, ['Ada', 'Lovelace']), 'Hello Ada Lovelace');
    expect(warnings, [contains('greet')]);
  });

  group('hash', () {
    String hashOf(Map<String, Object?> template,
            [Map<String, Object?>? translation]) =>
        groupIntoFamilies([
          _parse('template.arb', template),
          if (translation != null) _parse('translation.arb', translation),
        ]).single.template.hash;

    final fr = {
      '@@locale': 'fr',
      '@@context': 'Fruits',
      'apple': 'Pomme',
    };

    test('is shared by all files of a family', () {
      final family = groupIntoFamilies([
        _parse('fruits.arb', _fruits),
        _parse('fruits_fr.arb', fr),
      ]).single;
      expect(family.files.map((file) => file.hash).toSet(),
          {family.template.hash});
    });

    test('does not depend on translations or message texts', () {
      final hash = hashOf(_fruits, fr);
      expect(hashOf(_fruits, {...fr, 'apple': 'Pommes'}), hash);
      expect(hashOf({..._fruits, 'apple': 'Apples'}, fr), hash);
    });

    test('depends on message names and placeholders', () {
      final hash = hashOf(_fruits);
      expect(hashOf({..._fruits, 'date': 'Date'}), isNot(hash));
      expect(hashOf({..._fruits, 'apple': 'Apple {variety}'}), isNot(hash));
    });
  });

  test('files are grouped by context', () {
    final families = groupIntoFamilies([
      _parse('fruits.arb', _fruits),
      _parse('greeting.arb', _greeting),
      _parse('fruits_de.arb', {
        '@@locale': 'de',
        '@@context': 'Fruits',
        'apple': 'Apfel',
      }),
    ]);

    expect(families.map((family) => family.template.path),
        ['fruits.arb', 'greeting.arb']);
    expect(families.first.files.map((file) => file.locale), ['de', 'en']);
  });
}
