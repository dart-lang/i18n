// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:example_web/testarbctx2.g.dart';

Future<void> main() async {
  querySelector('#output')?.text = 'Your Dart app is running.';
  var myMessagesAbout = AboutPageMessages();
  print('About message en:');
  await myMessagesAbout.loadLocale('en');
  print(myMessagesAbout.aboutMessage('mywebsite.com'));
  print('About message fr:');
  await myMessagesAbout.loadLocale('fr');
  print(myMessagesAbout.aboutMessage('mywebsite.com'));
}
