import 'dart:io';

abstract class ResourcesAssets<T> extends Assets {
  final Map<T, int> assetToPart;

  ResourcesAssets.fromJsonString(this.assetToPart) : super.fromJsonString();

  @override
  String serialize();
}

abstract class Assets<T> {
  Assets.fromJsonString();

  String serialize();
}

class NetworkAssetBundle extends CachedAssetBundle {
  NetworkAssetBundle._privateConstructor();

  static final NetworkAssetBundle instance =
      NetworkAssetBundle._privateConstructor();

  final client = HttpClient();

  @override
  Future<T> load<T>(String key) async {
    //TODO: deserialize the asset here?
    if (!assets.containsKey(key)) {
      var fileContent = await client.get('host', 72, 'path/to/assets/$key');
      assets[key] = fileContent;
    }
    return assets[key] as T;
  }

  // Mock, to be called after kernel compilation, after linking.
  @override
  void registerAsset<T extends Object>(String key, T asset) {}
}

class CachedAssetBundle extends AssetBundle {
  CachedAssetBundle._privateConstructor();

  static final CachedAssetBundle instance =
      CachedAssetBundle._privateConstructor();

  CachedAssetBundle();

  final Map<String, Object> assets = {};

  @override
  Future<T> load<T>(String key) async {
    //TODO: deserialize the asset here?
    if (!assets.containsKey(key)) {
      var fileContent = await File('path/to/assets/$key').readAsString();
      assets[key] = fileContent;
    }
    return assets[key] as T;
  }

  // Mock, to be called after kernel compilation, after linking.
  @override
  void registerAsset<T extends Object>(String key, T asset) {
    //store asset at filepath
  }
}

abstract class AssetBundle {
  Future<T> load<T>(String key);

  // Mock, to be called after kernel compilation, after linking.
  void registerAsset<T extends Object>(String key, T asset) {}
}
