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
