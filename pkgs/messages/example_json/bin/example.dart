// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:io';

import 'package:example_json/testarbctx2.g.dart';
import 'package:messages/package_intl_object.dart';

Future<void> main(List<String> arguments) async {
  final messages = AboutPageMessages(
    (String id) => File('lib/$id').readAsStringSync(),
    OldIntlObject(),
  );
  final index = AboutPageMessagesIndex.aboutMessage;

  messages.loadLocale('en');
  print('AboutMessage en:');
  print('\t${messages.aboutMessage(websitename: 'typesafe.en')}');
  print('\t${messages.getById('aboutMessage', ['get-by-id.en'])}');
  print('\t${messages.getByIndex(index, ['get-by-index.en'])}');

  messages.loadLocale('fr');
  print('AboutMessage fr:');
  print('\t${messages.aboutMessage(websitename: 'typesafe.fr')}');
  print('\t${messages.getById('aboutMessage', ['get-by-id.fr'])}');
  print('\t${messages.getByIndex(index, ['get-by-index.fr'])}');
}
