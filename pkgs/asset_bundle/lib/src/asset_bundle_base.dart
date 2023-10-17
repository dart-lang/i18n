import 'dart:io';
import 'dart:typed_data';

abstract class ResourcesAssets<T> extends Assets {
  final Map<T, int> assetToPart;

  ResourcesAssets(this.assetToPart);

  ResourcesAssets.fromJsonString(this.assetToPart) : super.fromJsonString();

  @override
  Map<String, dynamic> serialize();
}

abstract class Assets<T> {
  Assets();

  Assets.fromJsonString();

  Map<String, dynamic> serialize();
}

class NetworkAssetBundle extends CachedAssetBundle {
  NetworkAssetBundle._privateConstructor();

  static final NetworkAssetBundle instance =
      NetworkAssetBundle._privateConstructor();

  final client = HttpClient();

  @override
  Future<Uint8List> fetchAsset(String key) async {
    var request = await client.get('host', 72, 'assets/$key');
    var response = await request.done;
    var b = BytesBuilder();
    response.forEach((element) {
      b.add(element);
    });
    return b.toBytes();
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
    var fileContent = assets[key];
    if (fileContent == null) {
      fileContent = await fetchAsset(key);
      assets[key] = fileContent;
    }
    return fileContent;
  }

  Future<Uint8List> fetchAsset(String key) async {
    return await File('assets/$key').readAsBytes();
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
