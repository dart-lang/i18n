import 'dart:io';
import 'package:icu/icu.dart';
import 'data.dart';

extension DataProvider on Data {
  ICU4XDataProvider to4X() {
    final icu4xDataProvider = switch (this) {
      AssetData() => ICU4XDataProvider.fromByteSlice(
          File((this as AssetData).key).readAsBytesSync()),
      BundleData() => ICU4XDataProvider.compiled(),
      NoData() => ICU4XDataProvider.empty(),
    };
    return icu4xDataProvider;
  }
}
