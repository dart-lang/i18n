import 'dart:convert';
import 'dart:io';

import 'package:messages/package_intl_object.dart';
import 'package:messages_builder/arb_parser.dart';
import 'package:messages_deserializer/messages_deserializer_json.dart';
import 'package:messages_serializer/messages_serializer.dart';
import 'package:messages_shrinker/messages_shrinker.dart';
import 'package:test/test.dart';

void main() {
  final intl = OldIntlObject();
  test('json', () {
    final String input = readArbFile();

    String getMessage(int i, List<int> args) => JsonDeserializer(input)
        .deserialize(intl)
        .generateStringAtIndex(i, args);

    final i = 1;
    final output = MessageShrinker().shrinkJson(input, [i]);
    final deserialize = JsonDeserializer(output).deserialize(intl);
    final args = [2];
    final generateStringAtIndex = deserialize.generateStringAtIndex(1, args);
    expect(generateStringAtIndex, getMessage(i, args));
  });
}

String readArbFile() {
  final arbFile = File('test/testarb.arb').readAsStringSync();
  final arb = jsonDecode(arbFile) as Map<String, dynamic>;
  final parsed = ArbParser().parseMessageFile(arb);
  return JsonSerializer()
      .serialize('', '', parsed.messages.map((e) => e.message).toList())
      .data;
}
