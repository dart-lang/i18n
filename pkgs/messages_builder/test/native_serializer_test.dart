import 'dart:typed_data';

import 'package:messages/message_format.dart';
import 'package:messages/varint.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:test/test.dart';

void main() {
  group('nested', () {
    test('plural in plural', () {
      var locale = 'en';
      var pluralMessage = PluralMessage(
        twoNumber: PluralMessage(
          other: StringMessage('Nested ', argPositions: {7: 1}),
          argIndex: 1,
        ),
        other: StringMessage('other'),
        id: 'testid',
        argIndex: 0,
      );
      var message = embedMessage(locale, pluralMessage);
      expect(message, TypeMatcher<PluralMessage>());
      expect(message.other, TypeMatcher<StringMessage>());
      expect((message.other as StringMessage).value, 'other');
      var otherStringMessage =
          (message.twoNumber as PluralMessage).other as StringMessage;
      expect(otherStringMessage.value, 'Nested ');
      expect(otherStringMessage.argPositions, {7: 1});
    });
    test('plural in plural in plural', () {
      var locale = 'en';
      var pluralMessage = PluralMessage(
        twoNumber: PluralMessage(
          other: PluralMessage(
            other: StringMessage('Nested\u0080 {2}'),
            argIndex: 2,
          ),
          argIndex: 1,
        ),
        other: StringMessage('other'),
        id: 'testid',
        argIndex: 0,
      );
      var message = embedMessage(locale, pluralMessage);
      expect(message, TypeMatcher<PluralMessage>());
      expect(message.other, TypeMatcher<StringMessage>());
      expect((message.other as StringMessage).value, 'other');
      expect(
          (((message.twoNumber as PluralMessage).other as PluralMessage).other
                  as StringMessage)
              .value,
          'Nested\u0080 {2}');
    });
  });

  group('Plural tests', () {
    test('simple', () {
      var locale = 'en';
      var pluralMessage = PluralMessage(
        other: StringMessage('other case'),
        few: StringMessage('few case'),
        many: StringMessage('many case'),
        zeroNumber: StringMessage('zero num'),
        zeroWord: StringMessage('zero word'),
        oneNumber: StringMessage('one num'),
        oneWord: StringMessage('one word'),
        twoNumber: StringMessage('two num'),
        twoWord: StringMessage('two word'),
        id: 'testid',
        argIndex: 0,
      );
      var message = embedMessage(locale, pluralMessage);
      expect(message, TypeMatcher<PluralMessage>());
      expect(message.other, TypeMatcher<StringMessage>());
      expect((message.other as StringMessage).value, 'other case');
      expect((message.few as StringMessage).value, 'few case');
      expect((message.many as StringMessage).value, 'many case');
      expect((message.zeroNumber as StringMessage).value, 'zero num');
      expect((message.zeroWord as StringMessage).value, 'zero word');
      expect((message.oneNumber as StringMessage).value, 'one num');
      expect((message.oneWord as StringMessage).value, 'one word');
      expect((message.twoNumber as StringMessage).value, 'two num');
      expect((message.twoWord as StringMessage).value, 'two word');
    });
    test('generateString', () {
      var locale = 'en';
      var pluralMessage = PluralMessage(
        other: StringMessage('other  case', argPositions: {6: 0}),
        few: StringMessage('few case'),
        many: StringMessage('many case'),
        zeroNumber: StringMessage(''),
        zeroWord: StringMessage('zero word'),
        oneNumber: StringMessage('one num'),
        oneWord: StringMessage('one word'),
        twoNumber: PluralMessage(
            other: StringMessage('Nested ', argPositions: {7: 1}), argIndex: 1),
        twoWord: StringMessage('two word'),
        id: 'testid',
        argIndex: 0,
      );
      var message = embedMessage(locale, pluralMessage);
      expect(message.generateString([1], locale: 'en'), 'one num');
      expect(message.generateString([2, 42], locale: 'en'), 'Nested 42');
      expect(message.generateString([0], locale: 'en'), '');
      expect(message.generateString([15], locale: 'en'), 'other 15 case');
    });
  });

  group('String tests', () {
    test('simple', () {
      var locale = 'en';
      var pluralMessage = StringMessage('Hello World', id: 'idt');
      var message = embedMessage(locale, pluralMessage);
      expect(message, TypeMatcher<StringMessage>());
      expect(message.value, TypeMatcher<String>());
      expect(message.value, 'Hello World');
      expect(message.argPositions, const {});
      expect(message.id, 'idt');
    });
    test('with arg', () {
      var locale = 'en';
      var pluralMessage =
          StringMessage('Hello  World', argPositions: {6: 0}, id: 'idt');
      var message = embedMessage(locale, pluralMessage);
      expect(message, TypeMatcher<StringMessage>());
      expect(message.value, TypeMatcher<String>());
      expect(message.value, 'Hello  World');
      expect(message.argPositions, {6: 0});
      expect(message.id, 'idt');
    });
    test('with args', () {
      var locale = 'en';
      var pluralMessage =
          StringMessage('Hello  World', argPositions: {6: 0, 10: 1}, id: 'idt');
      var message = embedMessage(locale, pluralMessage);
      expect(message, TypeMatcher<StringMessage>());
      expect(message.value, TypeMatcher<String>());
      expect(message.value, 'Hello  World');
      expect(message.argPositions, {6: 0, 10: 1});
      expect(message.id, 'idt');
    });
    test('generateString simple', () {
      var locale = 'en';
      var pluralMessage = StringMessage('Hello World');
      var message = embedMessage(locale, pluralMessage);
      expect(message, TypeMatcher<StringMessage>());
      expect(message.generateString([]), TypeMatcher<String>());
      expect(message.generateString([]), 'Hello World');
    });
    test('generateString args', () {
      var locale = 'en';
      var pluralMessage = StringMessage('Hello World', argPositions: {5: 0});
      var message = embedMessage(locale, pluralMessage);
      expect(message, TypeMatcher<StringMessage>());
      expect(message.generateString([', today']), TypeMatcher<String>());
      expect(message.generateString([', today']), 'Hello, today World');
    });
  });

  group('Select tests', () {
    test('simple', () {
      var locale = 'en';
      var selectMessage = SelectMessage(
        StringMessage('other'),
        {
          'case1': StringMessage('case 1'),
        },
        0,
        'testid',
      );
      var message = embedMessage(locale, selectMessage);
      expect(message, TypeMatcher<SelectMessage>());
      expect(message.cases['case1'], TypeMatcher<StringMessage>());
      expect(message.other, TypeMatcher<StringMessage>());
      expect((message.cases['case1'] as StringMessage).value, 'case 1');
      expect((message.other as StringMessage).value, 'other');
    });
    test('generateString', () {
      var locale = 'en';
      var pluralMessage = PluralMessage(
        other: StringMessage('other  case', argPositions: {6: 0}),
        few: StringMessage('few case'),
        many: StringMessage('many case'),
        zeroNumber: StringMessage(''),
        zeroWord: StringMessage('zero word'),
        oneNumber: StringMessage('one num'),
        oneWord: StringMessage('one word'),
        twoNumber: PluralMessage(
            other: StringMessage('Nested ', argPositions: {7: 1}), argIndex: 1),
        twoWord: StringMessage('two word'),
        id: 'testid',
        argIndex: 0,
      );
      var message = embedMessage(locale, pluralMessage);
      expect(message.generateString([1], locale: 'en'), 'one num');
      expect(message.generateString([2, 42], locale: 'en'), 'Nested 42');
      expect(message.generateString([0], locale: 'en'), '');
      expect(message.generateString([15], locale: 'en'), 'other 15 case');
    });
  });

  group('Random tests', () {
    setUp(() {
      // Additional setup goes here.
    });
    test('select', () {
      var locale = 'en';
      var json = NativeSerializer(true).serialize(
        '',
        locale,
        [
          SelectMessage(
              StringMessage('other message'),
              {
                'few': StringMessage('few  message', argPositions: {4: 2}),
              },
              0,
              'idt'),
        ],
      ).data;
      // print(json);
      // print(String.fromCharCodes(json));
      var list = NativeDeserializer(Uint8List.fromList(json)).deserialize();
      expect(list.locale, locale);
      var select = list.messages.first as SelectMessage;
      expect(select, TypeMatcher<SelectMessage>());
      expect((select.other as StringMessage).value, 'other message');
      expect((select.cases['few'] as StringMessage).value, 'few  message');
      expect(select.id, 'idt');
    });

    test('varint', () {
      void testNum(int n) {
        var varint = VarInt.toVarint(n);
        var fromVarint = VarInt.fromVarint(varint);
        expect(fromVarint.value, n);
      }

      testNum(5);
      testNum(50);
      testNum(2000);
      testNum(1112063);
      testNum(268435456);
    });

    test('plural', () {
      var locale = 'en';
      var data = NativeSerializer().serialize('', locale, [
        PluralMessage(
          other: StringMessage(
            'Take me home, country roads',
          ),
          few: StringMessage(
            'Take me home, country {2} roads',
          ),
          argIndex: 0,
        ),
      ]).data;
      var list = NativeDeserializer(Uint8List.fromList(data)).deserialize();
      expect(list.locale, locale);
      expect(list.messages.first, TypeMatcher<PluralMessage>());
    });

    test('string', () {
      var locale = 'en';
      var json = NativeSerializer(true).serialize('', locale, [
        StringMessage('你{1222}好', id: 'idt'),
        StringMessage(
          'Take me home, country roads',
        ),
        StringMessage(
          'Take me home, country {0} roads',
        ),
        StringMessage('Take {1222} me home, country {0} roads', id: 'myid'),
      ]).data;
      // print(json);
      // print(String.fromCharCodes(json));
      var list = NativeDeserializer(Uint8List.fromList(json)).deserialize();
      expect(list.locale, locale);
      expect((list.messages.first as StringMessage).id, 'idt');
      expect((list.messages.first as StringMessage).value, '你{1222}好');
      var message = list.messages[2] as StringMessage;
      expect(message.id, null);
      var message3 = list.messages[3] as StringMessage;
      expect(message3.id, 'myid');
    });
  });
}

T embedMessage<T extends Message>(String locale, T message) {
  var data = NativeSerializer(true).serialize('', locale, [message]).data;
  var list = NativeDeserializer(Uint8List.fromList(data)).deserialize();
  return list.messages.first as T;
}
