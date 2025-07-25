// generated by diplomat-tool
// dart format off

part of 'lib.g.dart';

/// The raw (non-recursive) canonical decomposition operation.
///
/// Callers should generally use DecomposingNormalizer unless they specifically need raw composition operations
///
/// See the [Rust documentation for `CanonicalDecomposition`](https://docs.rs/icu/2.0.0/icu/normalizer/properties/struct.CanonicalDecomposition.html) for more information.
final class CanonicalDecomposition implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  CanonicalDecomposition._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  @_DiplomatFfiUse('icu4x_CanonicalDecomposition_destroy_mv1')
 static final _finalizer = ffi.NativeFinalizer(ffi.Native.addressOf(_icu4x_CanonicalDecomposition_destroy_mv1));

  /// Construct a new CanonicalDecomposition instance for NFC using compiled data.
  ///
  /// See the [Rust documentation for `new`](https://docs.rs/icu/2.0.0/icu/normalizer/properties/struct.CanonicalDecomposition.html#method.new) for more information.
  factory CanonicalDecomposition() {
    final result = _icu4x_CanonicalDecomposition_create_mv1();
    return CanonicalDecomposition._fromFfi(result, []);
  }

  /// Construct a new CanonicalDecomposition instance for NFC using a particular data source.
  ///
  /// See the [Rust documentation for `new`](https://docs.rs/icu/2.0.0/icu/normalizer/properties/struct.CanonicalDecomposition.html#method.new) for more information.
  ///
  /// Throws [DataError] on failure.
  factory CanonicalDecomposition.withProvider(DataProvider provider) {
    final result = _icu4x_CanonicalDecomposition_create_with_provider_mv1(provider._ffi);
    if (!result.isOk) {
      throw DataError.values[result.union.err];
    }
    return CanonicalDecomposition._fromFfi(result.union.ok, []);
  }

  /// Performs non-recursive canonical decomposition (including for Hangul).
  ///
  /// See the [Rust documentation for `decompose`](https://docs.rs/icu/2.0.0/icu/normalizer/properties/struct.CanonicalDecompositionBorrowed.html#method.decompose) for more information.
  Decomposed decompose(Rune c) {
    final result = _icu4x_CanonicalDecomposition_decompose_mv1(_ffi, c);
    return Decomposed._fromFfi(result);
  }

}

@_DiplomatFfiUse('icu4x_CanonicalDecomposition_destroy_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(isLeaf: true, symbol: 'icu4x_CanonicalDecomposition_destroy_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CanonicalDecomposition_destroy_mv1(ffi.Pointer<ffi.Void> self);

@_DiplomatFfiUse('icu4x_CanonicalDecomposition_create_mv1')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function()>(isLeaf: true, symbol: 'icu4x_CanonicalDecomposition_create_mv1')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _icu4x_CanonicalDecomposition_create_mv1();

@_DiplomatFfiUse('icu4x_CanonicalDecomposition_create_with_provider_mv1')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(isLeaf: true, symbol: 'icu4x_CanonicalDecomposition_create_with_provider_mv1')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _icu4x_CanonicalDecomposition_create_with_provider_mv1(ffi.Pointer<ffi.Opaque> provider);

@_DiplomatFfiUse('icu4x_CanonicalDecomposition_decompose_mv1')
@ffi.Native<_DecomposedFfi Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(isLeaf: true, symbol: 'icu4x_CanonicalDecomposition_decompose_mv1')
// ignore: non_constant_identifier_names
external _DecomposedFfi _icu4x_CanonicalDecomposition_decompose_mv1(ffi.Pointer<ffi.Opaque> self, Rune c);

// dart format on
