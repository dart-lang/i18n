import 'dart:io';
import 'bindings/lib.g.dart' as icu;
import 'data.dart';

extension DataProvider on Data {
  icu.DataProvider to4X() => switch (this) {
        AssetData() => icu.DataProvider.fromByteSlice(
            File((this as AssetData).key).readAsBytesSync()),
        BundleData() => icu.DataProvider.compiled(),
        NoData() => icu.DataProvider.empty(),
      };
}
