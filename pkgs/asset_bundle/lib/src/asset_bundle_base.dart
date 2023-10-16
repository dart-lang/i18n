import 'dart:io';
import 'dart:typed_data';

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
  Future<Uint8List> load(String key) async {
    //TODO: deserialize the asset here?
    if (!assets.containsKey(key)) {
      var request = await client.get('host', 72, 'assets/$key');
      var response = await request.done;
      var b = BytesBuilder();
      response.forEach((element) {
        b.add(element);
      });
      assets[key] = b.toBytes();
    }
    return assets[key]!;
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

  final Map<String, Uint8List> assets = {};

  @override
  Future<Uint8List> load(String key) async {
    //TODO: deserialize the asset here?
    if (!assets.containsKey(key)) {
      var fileContent = await File('assets/$key').readAsBytes();
      assets[key] = fileContent;
    }
    return assets[key]!;
  }

  // Mock, to be called after kernel compilation, after linking.
  @override
  void registerAsset<T extends Object>(String key, T asset) {
    //store asset at filepath
  }
}

abstract class AssetBundle {
  Future<Uint8List> load(String key);

  // Mock, to be called after kernel compilation, after linking.
  void registerAsset<T extends Object>(String key, T asset) {}
}
