import 'dart:io';
import 'package:icu/icu.dart' as icu;
import 'data.dart';

extension DataProvider on Data {
  icu.DataProvider to4X() {
    final icu4xDataProvider = switch (this) {
      AssetData() => icu.DataProvider.fromByteSlice(
          File((this as AssetData).key).readAsBytesSync()),
      BundleData() => icu.DataProvider.compiled(),
      NoData() => icu.DataProvider.empty(),
    };
    return icu4xDataProvider;
  }
}
