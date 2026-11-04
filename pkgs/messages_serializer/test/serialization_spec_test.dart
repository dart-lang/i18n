// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:intl/intl.dart' as old_intl;
import 'package:messages/messages_json.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:test/test.dart';

Message intlPluralSelector(
  num howMany,
  String locale, {
  Map<int, Message>? numberCases,
  Map<int, Message>? wordCases,
  Message? few,
  Message? many,
  required Message other,
}) {
  return old_intl.Intl.pluralLogic(
    howMany,
    few: few,
    many: many,
    zero: numberCases?[0] ?? wordCases?[0],
    one: numberCases?[1] ?? wordCases?[1],
    two: numberCases?[2] ?? wordCases?[2],
    other: other,
    locale: locale,
  );
}

void main() {
  group('Serialization Spec Conformance', () {
    group('Preamble & Header Format', () {
      test('serializes correct 3-element preamble header', () {
        final serializer = JsonSerializer();
        final result = serializer.serialize('hash1234', 'en_US', []);
        final jsonList = jsonDecode(result.data) as List;

        expect(jsonList[0], serializationVersion);
        expect(jsonList[1], 'en_US');
        expect(jsonList[2], 'hash1234');
        expect(jsonList[3], null); // mapping = null
      });

      test('deserializer throws ArgumentError on version mismatch', () {
        final invalidVersionJson = jsonEncode([
          999, // incompatible version
          'en_US',
          'hash',
          null,
        ]);
        expect(
          () => JsonDeserializer(invalidVersionJson).deserialize(),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Index Mapping Encoding', () {
      test('encodes index mapping as List<int> when keepOnly is specified', () {
        final messages = List.generate(40, (i) => StringMessage('Message $i'));
        final serializer = JsonSerializer();
        final result = serializer.serialize('hash', 'en', messages, [0, 35]);
        final jsonList = jsonDecode(result.data) as List;

        final mapping = (jsonList[3] as List).cast<int>();
        expect(mapping, [0, 35]);

        final data = JsonDeserializer(result.data).deserialize();
        final deserialized = MessageListJson(data, intlPluralSelector);
        expect(deserialized.generateStringAtIndex(0, []), 'Message 0');
        expect(deserialized.generateStringAtIndex(35, []), 'Message 35');
      });
    });

    group('StringMessage Encoding', () {
      test(
        'encodes static string without placeholders as a plain JSON string',
        () {
          final serializer = JsonSerializer();
          final result = serializer.serialize('hash', 'en', [
            StringMessage('Hello'),
          ]);
          final jsonList = jsonDecode(result.data) as List;

          expect(jsonList[4], 'Hello');
        },
      );

      test(
        'encodes StringMessage with placeholders as array with offset pairs',
        () {
          final msg = StringMessage(
            'Hello , welcome to !',
            argPositions: [
              (stringIndex: 6, argIndex: 0),
              (stringIndex: 19, argIndex: 1),
            ],
          );
          final serializer = JsonSerializer();
          final result = serializer.serialize('hash', 'en', [msg]);
          final jsonList = jsonDecode(result.data) as List;

          final encodedMsg = jsonList[4] as List;
          expect(encodedMsg[0], 'Hello , welcome to !');
          expect(encodedMsg[1], [6, 0]);
          expect(encodedMsg[2], [19, 1]);
        },
      );
    });

    group('PluralMessage Encoding', () {
      test('encodes PluralMessage with type code 3 and marker categories', () {
        final plural = PluralMessage(
          numberCases: {1: StringMessage('1 item')},
          wordCases: {0: StringMessage('no items')},
          few: StringMessage('few items'),
          many: StringMessage('many items'),
          other: StringMessage('other items'),
          argIndex: 0,
        );

        final serializer = JsonSerializer();
        final result = serializer.serialize('hash', 'en', [plural]);
        final jsonList = jsonDecode(result.data) as List;

        final encodedPlural = jsonList[4] as List;
        expect(encodedPlural[0], PluralMessage.type); // 3
        expect(encodedPlural[1], 0); // argIndex
        expect(encodedPlural[2], 'other items'); // fallback

        final cases = encodedPlural[3] as List;
        expect(
          cases,
          containsAll([
            'f',
            'few items',
            'm',
            'many items',
            1,
            '1 item',
            'w0',
            'no items',
          ]),
        );
      });
    });

    group('SelectMessage Encoding', () {
      test('encodes SelectMessage with type code 4 and case map', () {
        final select = SelectMessage(StringMessage('other person'), {
          'female': StringMessage('female person'),
          'male': StringMessage('male person'),
        }, 0);

        final serializer = JsonSerializer();
        final result = serializer.serialize('hash', 'en', [select]);
        final jsonList = jsonDecode(result.data) as List;

        final encodedSelect = jsonList[4] as List;
        expect(encodedSelect[0], SelectMessage.type); // 4
        expect(encodedSelect[1], 0); // argIndex
        expect(encodedSelect[2], 'other person'); // fallback

        final casesMap = encodedSelect[3] as Map<String, dynamic>;
        expect(casesMap['female'], 'female person');
        expect(casesMap['male'], 'male person');
      });
    });

    group('CombinedMessage Encoding', () {
      test('encodes CombinedMessage with type code 6 and submessage list', () {
        final combined = CombinedMessage([
          StringMessage('Part 1 '),
          StringMessage('Part 2'),
        ]);

        final serializer = JsonSerializer();
        final result = serializer.serialize('hash', 'en', [combined]);
        final jsonList = jsonDecode(result.data) as List;

        final encodedCombined = jsonList[4] as List;
        expect(encodedCombined[0], CombinedMessage.type); // 6
        expect(encodedCombined[1], 'Part 1 ');
        expect(encodedCombined[2], 'Part 2');
      });
    });
  });
}
