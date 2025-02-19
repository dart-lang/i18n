// generated by diplomat-tool

part of 'lib.g.dart';

/// A locale canonicalizer.
///
/// See the [Rust documentation for `LocaleCanonicalizer`](https://docs.rs/icu/latest/icu/locid_transform/struct.LocaleCanonicalizer.html) for more information.
final class LocaleCanonicalizer implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  LocaleCanonicalizer._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  @RecordSymbol('ICU4XLocaleCanonicalizer_destroy')
  static final _finalizer = ffi.NativeFinalizer(
    ffi.Native.addressOf(_ICU4XLocaleCanonicalizer_destroy),
  );

  /// Create a new [`LocaleCanonicalizer`].
  ///
  /// See the [Rust documentation for `new`](https://docs.rs/icu/latest/icu/locid_transform/struct.LocaleCanonicalizer.html#method.new) for more information.
  ///
  /// Throws [Error] on failure.
  factory LocaleCanonicalizer(DataProvider provider) {
    final result = _ICU4XLocaleCanonicalizer_create(provider._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return LocaleCanonicalizer._fromFfi(result.union.ok, []);
  }

  /// Create a new [`LocaleCanonicalizer`] with extended data.
  ///
  /// See the [Rust documentation for `new_with_expander`](https://docs.rs/icu/latest/icu/locid_transform/struct.LocaleCanonicalizer.html#method.new_with_expander) for more information.
  ///
  /// Throws [Error] on failure.
  factory LocaleCanonicalizer.extended(DataProvider provider) {
    final result = _ICU4XLocaleCanonicalizer_create_extended(provider._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return LocaleCanonicalizer._fromFfi(result.union.ok, []);
  }

  /// See the [Rust documentation for `canonicalize`](https://docs.rs/icu/latest/icu/locid_transform/struct.LocaleCanonicalizer.html#method.canonicalize) for more information.
  TransformResult canonicalize(Locale locale) {
    final result = _ICU4XLocaleCanonicalizer_canonicalize(_ffi, locale._ffi);
    return TransformResult.values[result];
  }
}

@RecordSymbol('ICU4XLocaleCanonicalizer_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
  isLeaf: true,
  symbol: 'ICU4XLocaleCanonicalizer_destroy',
)
// ignore: non_constant_identifier_names
external void _ICU4XLocaleCanonicalizer_destroy(ffi.Pointer<ffi.Void> self);

@RecordSymbol('ICU4XLocaleCanonicalizer_create')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XLocaleCanonicalizer_create',
)
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XLocaleCanonicalizer_create(
  ffi.Pointer<ffi.Opaque> provider,
);

@RecordSymbol('ICU4XLocaleCanonicalizer_create_extended')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XLocaleCanonicalizer_create_extended',
)
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XLocaleCanonicalizer_create_extended(
  ffi.Pointer<ffi.Opaque> provider,
);

@RecordSymbol('ICU4XLocaleCanonicalizer_canonicalize')
@ffi.Native<
  ffi.Int32 Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(isLeaf: true, symbol: 'ICU4XLocaleCanonicalizer_canonicalize')
// ignore: non_constant_identifier_names
external int _ICU4XLocaleCanonicalizer_canonicalize(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> locale,
);
