rm pkgs/intl4x/lib/src/bindings/*
cd pkgs/intl4x/lib/src/bindings/
cp -a ../../../../../submodules/icu4x/ffi/capi/bindings/dart/*.dart .
cd ../../../../../

cp submodules/icu4x/ffi/dart/tool/build_libs.dart pkgs/intl4x/tool/build_libs.g.dart
cp submodules/icu4x/ffi/dart/tool/build_libs.dart pkgs/intl4x/lib/src/hook_helpers/build_libs.g.dart
dart format pkgs/intl4x/lib/src/bindings/
dart format pkgs/intl4x/tool/build_libs.g.dart
dart format pkgs/intl4x/lib/src/hook_helpers/build_libs.g.dart
