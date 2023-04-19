// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')

import 'dart:convert';

import 'package:messages/message_format.dart';
import 'package:messages/message_json.dart';
import 'package:test/test.dart';

var emptyPreamble = [0, '', '', 0];
void main() {
  test('stringmessage json toString', () {
    var stringMessage = 'Hello World';
    var s = MessageListJson.fromString(jsonEncode([
      ...emptyPreamble,
      stringMessage,
    ])).generateStringAtIndex(0, []);
    expect(s, 'Hello World');
  });
  test('stringmessage with args json toString', () {
    var stringMessage = [
      'Hello  World',
      [6.toRadixString(36), 0]
    ];
    var s = MessageListJson.fromString(jsonEncode([
      ...emptyPreamble,
      stringMessage,
    ])).generateStringAtIndex(0, ['my']);
    expect(s, 'Hello my World');
  });
  test('pluralmessage json toString', () {
    var otherMessage = [
      'Hello other  Worlds',
      [12.toRadixString(36), 1]
    ];
    var fewMessage = 'Hello few...';
    var twoWordMessage = 'Hello twoWord...';
    var pluralMessage = [
      PluralMessage.type,
      1,
      otherMessage,
      [Plural.few, fewMessage],
      [Plural.twoWord, twoWordMessage],
    ];
    var s = MessageListJson.fromString(jsonEncode([
      ...emptyPreamble,
      pluralMessage,
    ])).generateStringAtIndex(0, ['my', 15]);
    expect(s, 'Hello other 15 Worlds');
  });
  test('selectmessage json toString', () {
    var case1Message = 'Hello case1';
    var case2Message = 'Hello case2';
    var selectMessage = [
      SelectMessage.type,
      0,
      'Hello othermessage',
      {'case1': case1Message},
      {'case2': case2Message},
    ];
    var s = MessageListJson.fromString(jsonEncode([
      ...emptyPreamble,
      selectMessage,
    ])).generateStringAtIndex(0, ['case1']);
    expect(s, 'Hello case1');
  });
  test('gendermessage json toString', () {
    var otherMessage = [
      'Hello other  Worlds',
      [12.toRadixString(36), 1]
    ];
    var femaleMessage = ['Hello female!'];
    var genderMessage = [
      GenderMessage.type,
      0,
      otherMessage,
      [Gender.female, femaleMessage],
    ];
    var s = MessageListJson.fromString(jsonEncode([
      ...emptyPreamble,
      genderMessage,
    ])).generateStringAtIndex(0, ['female', 15]);
    expect(s, 'Hello female!');
  });
  test('combined json toString', () {
    var message1 = 'Hello ';
    var message2 = 'World';
    var combinedMessage = [CombinedMessage.type, message1, message2];
    var s = MessageListJson.fromString(jsonEncode([
      ...emptyPreamble,
      combinedMessage,
    ])).generateStringAtIndex(0, []);
    expect(s, 'Hello World');
  });
}
