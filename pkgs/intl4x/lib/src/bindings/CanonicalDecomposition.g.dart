// generated by diplomat-tool

part of 'lib.g.dart';

/// The raw (non-recursive) canonical decomposition operation.
///
/// Callers should generally use ICU4XDecomposingNormalizer unless they specifically need raw composition operations
///
/// See the [Rust documentation for `CanonicalDecomposition`](https://docs.rs/icu/latest/icu/normalizer/properties/struct.CanonicalDecomposition.html) for more information.
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

  @RecordSymbol('ICU4XCanonicalDecomposition_destroy')
  static final _finalizer = ffi.NativeFinalizer(
    ffi.Native.addressOf(_ICU4XCanonicalDecomposition_destroy),
  );

  /// Construct a new ICU4XCanonicalDecomposition instance for NFC
  ///
  /// See the [Rust documentation for `new`](https://docs.rs/icu/latest/icu/normalizer/properties/struct.CanonicalDecomposition.html#method.new) for more information.
  ///
  /// Throws [Error] on failure.
  factory CanonicalDecomposition(DataProvider provider) {
    final result = _ICU4XCanonicalDecomposition_create(provider._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return CanonicalDecomposition._fromFfi(result.union.ok, []);
  }

  /// Performs non-recursive canonical decomposition (including for Hangul).
  ///
  /// See the [Rust documentation for `decompose`](https://docs.rs/icu/latest/icu/normalizer/properties/struct.CanonicalDecomposition.html#method.decompose) for more information.
  Decomposed decompose(Rune c) {
    final result = _ICU4XCanonicalDecomposition_decompose(_ffi, c);
    return Decomposed._fromFfi(result);
  }
}

@RecordSymbol('ICU4XCanonicalDecomposition_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
  isLeaf: true,
  symbol: 'ICU4XCanonicalDecomposition_destroy',
)
// ignore: non_constant_identifier_names
external void _ICU4XCanonicalDecomposition_destroy(ffi.Pointer<ffi.Void> self);

@RecordSymbol('ICU4XCanonicalDecomposition_create')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XCanonicalDecomposition_create',
)
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XCanonicalDecomposition_create(
  ffi.Pointer<ffi.Opaque> provider,
);

@RecordSymbol('ICU4XCanonicalDecomposition_decompose')
@ffi.Native<_DecomposedFfi Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
  isLeaf: true,
  symbol: 'ICU4XCanonicalDecomposition_decompose',
)
// ignore: non_constant_identifier_names
external _DecomposedFfi _ICU4XCanonicalDecomposition_decompose(
  ffi.Pointer<ffi.Opaque> self,
  Rune c,
);
