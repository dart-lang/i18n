import 'dart:convert';

import 'package:asset_bundle/asset_bundle.dart';

import 'messages_json.dart';

class MessagesResourcesAssets extends ResourcesAssets<int> {
  MessagesResourcesAssets.fromJsonString(String resource)
      : super.fromJsonString(deserialize(resource));

  @override
  String serialize() => jsonEncode(
      messageIndexToPart.map((key, value) => MapEntry(key.toString(), value)));

  Map<int, int> get messageIndexToPart => assetToPart;

  static Map<int, int> deserialize(String resource) {
    final decoded = jsonDecode(resource) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(int.parse(key), value as int));
  }
}

typedef Key = String;

class MessagesAssetBundle {
  final AssetBundle assetBundle;
  final String name;
  final IntlObject intl;
  final Map<Key, MessageListJson> loadedParts = {};

  MessagesAssetBundle({
    required this.assetBundle,
    required this.name,
    required this.intl,
  });

  Future<Message> getMessageByIndex(
      {required String locale, required int index}) async {
    final resourcesAssets = MessagesResourcesAssets.fromJsonString(
      utf8.decode(await assetBundle.load('messages_resources')),
    );
    final partIndex = resourcesAssets.messageIndexToPart[index];
    final key = generateKey(partIndex, locale);
    var loadedPart = loadedParts[key];
    if (loadedPart == null) {
      loadedPart = await loadMessage(key);
      loadedParts[key] = loadedPart;
    }
    return loadedPart.messages[index];
  }

  Future<MessageListJson> loadMessage(String key) async {
    final resource = await assetBundle.load(key);
    return MessageListJson.fromString(
      utf8.decode(resource),
      intl,
    );
  }

  String generateKey(int? partIndex, String locale) {
    return [
      name,
      if (partIndex != null) partIndex.toString(),
      locale,
    ].join('_');
  }
}
