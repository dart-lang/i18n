sealed class Data {
  const Data();
}

final class AssetData extends Data {
  final String key;

  const AssetData(this.key);
}

final class BundleData extends Data {}

final class NoData extends Data {
  const NoData();
}
