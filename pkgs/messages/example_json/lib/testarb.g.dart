import 'package:messages/messages_json.dart';

class HomePageMessages {
  HomePageMessages(
    this._fileLoader,
    this.intlObject,
  );

  final String Function(String id) _fileLoader;

  String _currentLocale = 'en';

  final Map<String, MessageList> _messages = {};

  final _carbs = {'de': 'testarb_de.json', 'en': 'testarb.json'};

  final _messageListHashes = {
    'testarb_de.json': '8qk919',
    'testarb.json': 's69t31'
  };

  IntlObject intlObject;

  String get currentLocale => _currentLocale;
  MessageList get _currentMessages => _messages[currentLocale]!;
  Iterable<String> get knownLocales => _carbs.keys;
  void loadLocale(String locale) {
    if (!_messages.containsKey(locale)) {
      final carb = _carbs[locale];
      if (carb == null) {
        throw ArgumentError('Locale $locale is not in $knownLocales');
      }
      final data = _fileLoader(carb);
      final messageList = MessageListJson.fromString(data, intlObject);
      if (messageList.preamble.hash != _messageListHashes[carb]) {
        throw ArgumentError('''
              Messages file has different hash "${messageList.preamble.hash}" than generated code "${_messageListHashes[carb]}".''');
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

  String helloAndWelcome({
    required String firstName,
    required String lastName,
  }) =>
      _currentMessages.generateStringAtIndex(
          HomePageMessagesEnum.helloAndWelcome.index, [firstName, lastName]);
  String newMessages({required int newMessages}) =>
      _currentMessages.generateStringAtIndex(
          HomePageMessagesEnum.newMessages.index, [newMessages]);
  String newMessages2({
    required String gender,
    required int newVar,
  }) =>
      _currentMessages.generateStringAtIndex(
          HomePageMessagesEnum.newMessages2.index, [gender, newVar]);
  String helloAndWelcome2({
    required String firstName,
    required String lastName,
  }) =>
      _currentMessages.generateStringAtIndex(
          HomePageMessagesEnum.helloAndWelcome2.index, [firstName, lastName]);
}

enum HomePageMessagesEnum {
  helloAndWelcome,
  newMessages,
  newMessages2,
  helloAndWelcome2
}
