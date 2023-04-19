import 'package:messages/message_format.dart';
import 'package:messages/message_json.dart';

import 'testarb.carb.dart' as testarb;
import 'testarb_de.carb.dart' as testarb_de;

class HomePageMessages {
  HomePageMessages() {
    loadAllLocales();
  }

  String _currentLocale = 'en';

  final Map<String, MessageList> _messages = {};

  final _carbs = {'de': 'testarb_de.carb.dart', 'en': 'testarb.carb.dart'};

  final _messageListHashes = {
    'testarb_de.carb.dart': '8qk919',
    'testarb.carb.dart': 's69t31'
  };

  String _loadingStrategy(String id) {
    if (id == 'testarb_de.carb.dart') {
      return testarb_de.JsonData.jsonData;
    } else if (id == 'testarb.carb.dart') {
      return testarb.JsonData.jsonData;
    }

    throw ArgumentError();
  }

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
      String data = _loadingStrategy(carb);
      var messageList = MessageListJson.fromString(data);

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
      _currentMessages.generateStringAtIndex(
          HomePageMessagesIndex.helloAndWelcome, [firstName, lastName]);
  String newMessages(int newMessages) => _currentMessages
      .generateStringAtIndex(HomePageMessagesIndex.newMessages, [newMessages]);
  String newMessages2(
    String gender,
    int newVar,
  ) =>
      _currentMessages.generateStringAtIndex(
          HomePageMessagesIndex.newMessages2, [gender, newVar]);
  String helloAndWelcome2(
    String firstName,
    String lastName,
  ) =>
      _currentMessages.generateStringAtIndex(
          HomePageMessagesIndex.helloAndWelcome2, [firstName, lastName]);
}

class StaticIconProvider {
  const StaticIconProvider();
}

// StaticIconProvider annotation to have constant finder ignore this class
@staticIconProvider
class HomePageMessagesIndex {
  static const int helloAndWelcome = 0;

  static const int newMessages = 1;

  static const int newMessages2 = 2;

  static const int helloAndWelcome2 = 3;
}

const staticIconProvider = StaticIconProvider();
