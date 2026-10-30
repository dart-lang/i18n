// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:io';

import 'package:messages_example/AboutPage_messages.g.dart';

Future<void> main(List<String> arguments) async {
  final messages = AboutPageMessages(
    (id) => File(id.split('/').skip(2).join('/')).readAsString(),
  );
  // final index = AboutPageMessagesEnum.aboutMessage;

  await messages.loadLocale('en');
  print('AboutMessage en:');
  print('\t${messages.aboutMessage('typesafe.en')}');

  await messages.loadLocale('fr');
  print('AboutMessage fr:');
  print('\t${messages.aboutMessage('typesafe.fr')}');
  print(getGreeting('Dart'));
}

String getGreeting(String name) {
  // Try clicking on the string literal below to test "Extract to ARB"!
  return 'Welcome back, $name!';
}
