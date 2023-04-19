import 'package:messages/message_format.dart';
import 'package:messages/message_json.dart';

import 'testarb.carb.dart' deferred as testarb;
import 'testarb_de.carb.dart' deferred as testarb_de;

class HomePageMessages {
  HomePageMessages();

  String _currentLocale = 'en';

  final Map<String, MessageList> _messages = {};

  final _carbs = {'de': 'testarb_de.carb.dart', 'en': 'testarb.carb.dart'};

  final _messageListHashes = {
    'testarb_de.carb.dart': 'gm66hr',
    'testarb.carb.dart': '9i8i52'
  };

  Future<String> _loadingStrategy(String id) async {
    if (id == 'testarb_de.carb.dart') {
      await testarb_de.loadLibrary();
      return testarb_de.JsonData.jsonData;
    } else if (id == 'testarb.carb.dart') {
      await testarb.loadLibrary();
      return testarb.JsonData.jsonData;
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

  String newMessages(int newMessages) => _currentMessages
      .generateStringAtIndex(HomePageMessagesIndex.newMessages, [newMessages]);
}

class StaticIconProvider {
  const StaticIconProvider();
}

// StaticIconProvider annotation to have constant finder ignore this class
@staticIconProvider
class HomePageMessagesIndex {
  static const int newMessages = 0;
}

const staticIconProvider = StaticIconProvider();
