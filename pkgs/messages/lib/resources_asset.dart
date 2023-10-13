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
  final MessagesResourcesAssets resourcesAssets;
  final Map<Key, SingleMessageAssetBundle> loadedParts = {};

  MessagesAssetBundle({
    required this.assetBundle,
    required this.name,
    required this.resourcesAssets,
  });

  Future<Message> getMessageByIndex(
      {required String locale, required int index}) async {
    final partIndex = resourcesAssets.messageIndexToPart[index]!;
    final key = generateKey(partIndex, locale);
    var loadedPart = loadedParts[key];
    if (loadedPart == null) {
      loadedPart = await loadMessage(key);
      loadedParts[key] = loadedPart;
    }
    return loadedPart.messages.messages[index];
  }

  Future<SingleMessageAssetBundle> loadMessage(String key) =>
      assetBundle.load<SingleMessageAssetBundle>('$name/$key');

  String generateKey(int partIndex, String locale) {
    return [partIndex.toString(), locale, name].join('/');
  }
}

class SingleMessageAssetBundle extends Assets {
  final MessageListJson messages;

  SingleMessageAssetBundle({required this.messages}) : super.fromJsonString();

  @override
  String serialize() {
    // TODO: implement serialize
    throw UnimplementedError();
  }
}
