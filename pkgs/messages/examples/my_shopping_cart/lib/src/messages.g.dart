// Generated by package:messages_builder.

import 'package:intl/intl.dart';
import 'package:messages/messages_json.dart';

Message _pluralSelector(
  num howMany,
  String locale, {
  required Message other,
  Message? few,
  Message? many,
  Map<int, Message>? numberCases,
  Map<int, Message>? wordCases,
}) {
  return Intl.pluralLogic(
    howMany,
    few: few,
    many: many,
    zero: numberCases?[0] ?? wordCases?[0],
    one: numberCases?[1] ?? wordCases?[1],
    two: numberCases?[2] ?? wordCases?[2],
    other: other,
    locale: locale,
  );
}

class ShoppingCartMessages {
  ShoppingCartMessages(this._fileLoader);

  final Future<String> Function(String id) _fileLoader;

  String _currentLocale = 'en_US';

  final Map<String, MessageList> _messages = {};

  static const _dataFiles = {
    'en_US': ('package:my_shopping_cart/assets/l10n/messages.json', 'Nj229ee7')
  };

  String get currentLocale => _currentLocale;

  MessageList get _currentMessages => _messages[currentLocale]!;

  static Iterable<String> get knownLocales => _dataFiles.keys;

  Future<void> loadLocale(String locale) async {
    if (!_messages.containsKey(locale)) {
      final info = _dataFiles[locale];
      final carb = info?.$1;
      if (carb == null) {
        throw ArgumentError('Locale $locale is not in $knownLocales');
      }
      final data = await _fileLoader(carb);
      final messageList = MessageListJson.fromString(data, _pluralSelector);
      if (messageList.preamble.hash != info?.$2) {
        throw ArgumentError('''
              Messages file for locale $locale has different hash "${messageList.preamble.hash}" than generated code "${info?.$2}".''');
      }
      _messages[locale] = messageList;
    }
    _currentLocale = locale;
  }

  Future<void> loadAllLocales() async {
    for (final locale in knownLocales) {
      await loadLocale(locale);
    }
  }

  String itemsInCart(int count) =>
      _currentMessages.generateStringAtIndex(0, [count]);
}
