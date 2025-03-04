// generated by diplomat-tool

part of 'lib.g.dart';

/// An object that runs the ICU4X locale fallback algorithm.
///
/// See the [Rust documentation for `LocaleFallbacker`](https://docs.rs/icu/latest/icu/locid_transform/fallback/struct.LocaleFallbacker.html) for more information.
final class LocaleFallbacker implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  LocaleFallbacker._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  @_DiplomatFfiUse('ICU4XLocaleFallbacker_destroy')
  static final _finalizer = ffi.NativeFinalizer(
    ffi.Native.addressOf(_ICU4XLocaleFallbacker_destroy),
  );

  /// Creates a new `LocaleFallbacker` from a data provider.
  ///
  /// See the [Rust documentation for `new`](https://docs.rs/icu/latest/icu/locid_transform/fallback/struct.LocaleFallbacker.html#method.new) for more information.
  ///
  /// Throws [Error] on failure.
  factory LocaleFallbacker(DataProvider provider) {
    final result = _ICU4XLocaleFallbacker_create(provider._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return LocaleFallbacker._fromFfi(result.union.ok, []);
  }

  /// Creates a new `LocaleFallbacker` without data for limited functionality.
  ///
  /// See the [Rust documentation for `new_without_data`](https://docs.rs/icu/latest/icu/locid_transform/fallback/struct.LocaleFallbacker.html#method.new_without_data) for more information.
  factory LocaleFallbacker.withoutData() {
    final result = _ICU4XLocaleFallbacker_create_without_data();
    return LocaleFallbacker._fromFfi(result, []);
  }

  /// Associates this `LocaleFallbacker` with configuration options.
  ///
  /// See the [Rust documentation for `for_config`](https://docs.rs/icu/latest/icu/locid_transform/fallback/struct.LocaleFallbacker.html#method.for_config) for more information.
  ///
  /// Throws [Error] on failure.
  LocaleFallbackerWithConfig forConfig(LocaleFallbackConfig config) {
    final temp = ffi2.Arena();
    // This lifetime edge depends on lifetimes: 'a
    core.List<Object> aEdges = [this];
    final result = _ICU4XLocaleFallbacker_for_config(_ffi, config._toFfi(temp));
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return LocaleFallbackerWithConfig._fromFfi(result.union.ok, [], aEdges);
  }
}

@_DiplomatFfiUse('ICU4XLocaleFallbacker_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
  isLeaf: true,
  symbol: 'ICU4XLocaleFallbacker_destroy',
)
// ignore: non_constant_identifier_names
external void _ICU4XLocaleFallbacker_destroy(ffi.Pointer<ffi.Void> self);

@_DiplomatFfiUse('ICU4XLocaleFallbacker_create')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XLocaleFallbacker_create',
)
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XLocaleFallbacker_create(
  ffi.Pointer<ffi.Opaque> provider,
);

@_DiplomatFfiUse('ICU4XLocaleFallbacker_create_without_data')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function()>(
  isLeaf: true,
  symbol: 'ICU4XLocaleFallbacker_create_without_data',
)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XLocaleFallbacker_create_without_data();

@_DiplomatFfiUse('ICU4XLocaleFallbacker_for_config')
@ffi.Native<
  _ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>, _LocaleFallbackConfigFfi)
>(isLeaf: true, symbol: 'ICU4XLocaleFallbacker_for_config')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XLocaleFallbacker_for_config(
  ffi.Pointer<ffi.Opaque> self,
  _LocaleFallbackConfigFfi config,
);
