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
          HomePageMessagesIndex.helloAndWelcome, [firstName, lastName]);
  String newMessages({required int newMessages}) => _currentMessages
      .generateStringAtIndex(HomePageMessagesIndex.newMessages, [newMessages]);
  String newMessages2({
    required String gender,
    required int newVar,
  }) =>
      _currentMessages.generateStringAtIndex(
          HomePageMessagesIndex.newMessages2, [gender, newVar]);
  String helloAndWelcome2({
    required String firstName,
    required String lastName,
  }) =>
      _currentMessages.generateStringAtIndex(
          HomePageMessagesIndex.helloAndWelcome2, [firstName, lastName]);
}

class HomePageMessagesIndex {
  static const int helloAndWelcome = 0;

  static const int newMessages = 1;

  static const int newMessages2 = 2;

  static const int helloAndWelcome2 = 3;
}
