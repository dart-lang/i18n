// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart' as old_intl;
import 'package:messages/messages_json.dart';
import 'package:messages_builder/arb_parser.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:messages_shrinker/messages_shrinker.dart';
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
  final intl = intlPluralSelector;
  late String dataFileContents;
  late String dataFile;

  setUp(() {
    dataFileContents = readArbFileToDataFile();
    dataFile = 'test/testarb.json';
    File(dataFile).writeAsStringSync(dataFileContents);
  });

  String getMessage(int i, List<int> args) => JsonDeserializer(dataFileContents)
      .deserialize(intlPluralSelector)
      .generateStringAtIndex(i, args);

  test('Shrink a json', () {
    final messageIndex = 1;
    final output =
        MessageShrinker().shrinkJson(dataFileContents, [messageIndex]);
    final deserialize =
        JsonDeserializer(output).deserialize(intlPluralSelector);
    final args = [2];
    final generateStringAtIndex = deserialize.generateStringAtIndex(1, args);
    expect(generateStringAtIndex, getMessage(messageIndex, args));
  });
  test(
    'Shrink a json with const from file',
    () {
      final outputFile = '/tmp/shrunkFile.json';
      MessageShrinker().shrink(
        dataFile,
        'test/const_files.json',
        outputFile,
      );

      final dataFileContentsShrunk = File(outputFile).readAsStringSync();
      expect(dataFileContentsShrunk.length, lessThan(dataFileContents.length));
      final deserialize =
          JsonDeserializer(dataFileContentsShrunk).deserialize(intl);
      final args = [2];
      final generateStringAtIndex = deserialize.generateStringAtIndex(1, args);
      expect(generateStringAtIndex, getMessage(1, args));
    },
  );
}

String readArbFileToDataFile() {
  final path = 'test/testarb.arb';
  final arbFile = File(path).readAsStringSync();
  final arb = jsonDecode(arbFile) as Map<String, dynamic>;
  final parsed = ArbParser().parseMessageFile(arb);
  return JsonSerializer()
      .serialize('', '', parsed.messages.map((e) => e.message).toList())
      .data;
}
