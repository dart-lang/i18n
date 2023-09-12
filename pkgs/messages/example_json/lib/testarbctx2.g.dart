import 'package:messages/messages_json.dart';

class AboutPageMessages {
  AboutPageMessages(
    this._fileLoader,
    this.intlObject,
  );

  final String Function(String id) _fileLoader;

  String _currentLocale = 'en';

  final Map<String, MessageList> _messages = {};

  final _carbs = {'fr': 'testarbctx2_fr.json', 'en': 'testarbctx2.json'};

  final _messageListHashes = {
    'testarbctx2_fr.json': '3nj3c2',
    'testarbctx2.json': 'skm01b'
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
          AboutPageMessagesIndex.helloAndWelcome, [firstName, lastName]);
  String aboutMessage({required String websitename}) =>
      _currentMessages.generateStringAtIndex(
          AboutPageMessagesIndex.aboutMessage, [websitename]);
  String newMessages({required int newMessages}) => _currentMessages
      .generateStringAtIndex(AboutPageMessagesIndex.newMessages, [newMessages]);
  String newMessages2({
    required String gender,
    required int newVar,
  }) =>
      _currentMessages.generateStringAtIndex(
          AboutPageMessagesIndex.newMessages2, [gender, newVar]);
}

class AboutPageMessagesIndex {
  static const int helloAndWelcome = 0;

  static const int aboutMessage = 1;

  static const int newMessages = 2;

  static const int newMessages2 = 3;
}
