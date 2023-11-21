// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:messages/package_intl_object.dart';
import 'package:messages_builder/arb_parser.dart';
import 'package:messages_deserializer/messages_deserializer.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:messages_shrinker/messages_shrinker.dart';
import 'package:test/test.dart';

void main() {
  final intl = const OldIntlObject();
  late String dataFileContents;
  late String dataFile;

  setUp(() {
    dataFileContents = readArbFileToDataFile();
    dataFile = 'test/testarb.json';
    File(dataFile).writeAsStringSync(dataFileContents);
  });

  String getMessage(int i, List<int> args) => JsonDeserializer(dataFileContents)
      .deserialize(intl)
      .generateStringAtIndex(i, args);

  test('Shrink a json', () {
    final messageIndex = 1;
    final output =
        MessageShrinker().shrinkJson(dataFileContents, [messageIndex]);
    final deserialize = JsonDeserializer(output).deserialize(intl);
    final args = [2];
    final generateStringAtIndex = deserialize.generateStringAtIndex(1, args);
    expect(generateStringAtIndex, getMessage(messageIndex, args));
  });

  test('Shrink a json with const from file', () {
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
  });
}

String readArbFileToDataFile() {
  final path = 'test/testarb.arb';
  final arbFile = File(path).readAsStringSync();
  final arb = jsonDecode(arbFile) as Map<String, dynamic>;
  final parsed =
      ArbParser().parseMessageFile(arb, AssetId('messsages_shrinker', path));
  return JsonSerializer()
      .serialize('', '', parsed.messages.map((e) => e.message).toList())
      .data;
}
