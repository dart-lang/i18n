import 'dart:typed_data';

import 'package:messages/message_format.dart';
import 'package:messages/message_native.dart';

class AboutPageMessages {
  AboutPageMessages(this._loadingStrategy);

  final Uint8List Function(String id) _loadingStrategy;

  String _currentLocale = 'en';

  final Map<String, MessageList> _messages = {};

  final _carbs = {'fr': 'testarbctx2_fr.carb', 'en': 'testarbctx2.carb'};

  final _messageListHashes = {
    'testarbctx2_fr.carb': '3nj3c2',
    'testarbctx2.carb': 'skm01b'
  };

  String get currentLocale => _currentLocale;
  MessageList get _currentMessages => _messages[currentLocale]!;
  set currentLocale(String locale) {
    if (_currentLocale != locale) {
      loadLocale(locale);
    }
  }

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
  void loadLocale(String locale) {
    if (!_messages.containsKey(locale)) {
      var carb = _carbs[locale];
      if (carb == null) {
        throw ArgumentError('Locale $locale is not in $knownLocales');
      }
      Uint8List data = _loadingStrategy(carb);
      var messageList = MessageListNative.fromBuffer(data);
      if (messageList.hash != _messageListHashes[carb]) {
        throw ArgumentError(
            'Messages file has different hash "${messageList.hash}" than generated code "${_messageListHashes[carb]}".');
      }
      _messages[locale] = messageList;
    }
    _currentLocale = locale;
  }

  void loadAllLocales() {
    for (var locale in knownLocales) {
      loadLocale(locale);
    }
  }

  String helloAndWelcome(
    String firstName,
    String lastName,
  ) =>
      _currentMessages.generateStringAtIndex(0, [firstName, lastName]);
  String aboutMessage(String websitename) =>
      _currentMessages.generateStringAtIndex(1, [websitename]);
  String newMessages(int newMessages) =>
      _currentMessages.generateStringAtIndex(2, [newMessages]);
  String newMessages2(
    String gender,
    int newVar,
  ) =>
      _currentMessages.generateStringAtIndex(3, [gender, newVar]);
}
