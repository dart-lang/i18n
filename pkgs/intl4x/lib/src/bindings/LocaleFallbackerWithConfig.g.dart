// generated by diplomat-tool

part of 'lib.g.dart';

/// An object that runs the ICU4X locale fallback algorithm with specific configurations.
///
/// See the [Rust documentation for `LocaleFallbacker`](https://docs.rs/icu/latest/icu/locid_transform/fallback/struct.LocaleFallbacker.html) for more information.
///
/// See the [Rust documentation for `LocaleFallbackerWithConfig`](https://docs.rs/icu/latest/icu/locid_transform/fallback/struct.LocaleFallbackerWithConfig.html) for more information.
final class LocaleFallbackerWithConfig implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;
  // ignore: unused_field
  final core.List<Object> _aEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  LocaleFallbackerWithConfig._fromFfi(this._ffi, this._selfEdge, this._aEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  @RecordSymbol('ICU4XLocaleFallbackerWithConfig_destroy')
  static final _finalizer = ffi.NativeFinalizer(
      ffi.Native.addressOf(_ICU4XLocaleFallbackerWithConfig_destroy));

  /// Creates an iterator from a locale with each step of fallback.
  ///
  /// See the [Rust documentation for `fallback_for`](https://docs.rs/icu/latest/icu/locid_transform/fallback/struct.LocaleFallbacker.html#method.fallback_for) for more information.
  LocaleFallbackIterator fallbackForLocale(Locale locale) {
    // This lifetime edge depends on lifetimes: 'a, 'b
    core.List<Object> aEdges = [this];
    final result =
        _ICU4XLocaleFallbackerWithConfig_fallback_for_locale(_ffi, locale._ffi);
    return LocaleFallbackIterator._fromFfi(result, [], aEdges);
  }
}

@RecordSymbol('ICU4XLocaleFallbackerWithConfig_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true, symbol: 'ICU4XLocaleFallbackerWithConfig_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XLocaleFallbackerWithConfig_destroy(
    ffi.Pointer<ffi.Void> self);

@RecordSymbol('ICU4XLocaleFallbackerWithConfig_fallback_for_locale')
@ffi.Native<
        ffi.Pointer<ffi.Opaque> Function(
            ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XLocaleFallbackerWithConfig_fallback_for_locale')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque>
    _ICU4XLocaleFallbackerWithConfig_fallback_for_locale(
        ffi.Pointer<ffi.Opaque> self, ffi.Pointer<ffi.Opaque> locale);
