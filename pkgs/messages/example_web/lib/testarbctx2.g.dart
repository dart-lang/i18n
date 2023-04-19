// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/message_format.dart';
import 'package:messages/message_json.dart';

import 'testarbctx2.carb.dart' deferred as testarbctx2;
import 'testarbctx2_fr.carb.dart' deferred as testarbctx2_fr;

class AboutPageMessages {
  AboutPageMessages();

  String _currentLocale = 'en';

  final Map<String, MessageList> _messages = {};

  final _carbs = {
    'fr': 'testarbctx2_fr.carb.dart',
    'en': 'testarbctx2.carb.dart'
  };

  final _messageListHashes = {
    'testarbctx2_fr.carb.dart': '3nj3c2',
    'testarbctx2.carb.dart': 'skm01b'
  };

  Future<String> _loadingStrategy(String id) async {
    if (id == 'testarbctx2_fr.carb.dart') {
      await testarbctx2_fr.loadLibrary();
      return testarbctx2_fr.JsonData.jsonData;
    } else if (id == 'testarbctx2.carb.dart') {
      await testarbctx2.loadLibrary();
      return testarbctx2.JsonData.jsonData;
    }

    throw ArgumentError();
  }

  String get currentLocale => _currentLocale;
  MessageList get _currentMessages => _messages[currentLocale]!;
  String getById(
    String id, [
    List<dynamic> args = const [],
  ]) {
    return _currentMessages.generateStringAtId(id, args);
  }

  @pragma('dart2js:noInline')
  String getByIndex(
    int index, [
    List<dynamic> args = const [],
  ]) =>
      _currentMessages.generateStringAtIndex(index, args);
  Iterable<String> get knownLocales => _carbs.keys;
  Future<void> loadLocale(String locale) async {
    if (!_messages.containsKey(locale)) {
      var carb = _carbs[locale];
      if (carb == null) {
        throw ArgumentError('Locale $locale is not in $knownLocales');
      }
      String data = await _loadingStrategy(carb);
      var messageList = MessageListJson.fromString(data);

      if (messageList.hash != _messageListHashes[carb]) {
        throw ArgumentError(
            'Messages file has different hash "${messageList.hash}" than generated code "${_messageListHashes[carb]}".');
      }
      _messages[locale] = messageList;
    }
    _currentLocale = locale;
  }

  Future<void> loadAllLocales() async {
    for (var locale in knownLocales) {
      await loadLocale(locale);
    }
  }

  String helloAndWelcome(
    String firstName,
    String lastName,
  ) =>
      _currentMessages.generateStringAtIndex(
          AboutPageMessagesIndex.helloAndWelcome, [firstName, lastName]);
  String aboutMessage(String websitename) =>
      _currentMessages.generateStringAtIndex(
          AboutPageMessagesIndex.aboutMessage, [websitename]);
  String newMessages(int newMessages) => _currentMessages
      .generateStringAtIndex(AboutPageMessagesIndex.newMessages, [newMessages]);
  String newMessages2(
    String gender,
    int newVar,
  ) =>
      _currentMessages.generateStringAtIndex(
          AboutPageMessagesIndex.newMessages2, [gender, newVar]);
}

class StaticIconProvider {
  const StaticIconProvider();
}

// StaticIconProvider annotation to have constant finder ignore this class
@staticIconProvider
class AboutPageMessagesIndex {
  static const int helloAndWelcome = 0;

  static const int aboutMessage = 1;

  static const int newMessages = 2;

  static const int newMessages2 = 3;
}

const staticIconProvider = StaticIconProvider();
