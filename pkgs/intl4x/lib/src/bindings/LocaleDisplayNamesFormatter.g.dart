// generated by diplomat-tool

part of 'lib.g.dart';

/// See the [Rust documentation for `LocaleDisplayNamesFormatter`](https://docs.rs/icu/latest/icu/displaynames/struct.LocaleDisplayNamesFormatter.html) for more information.
final class LocaleDisplayNamesFormatter implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  LocaleDisplayNamesFormatter._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer = ffi.NativeFinalizer(
      ffi.Native.addressOf(_ICU4XLocaleDisplayNamesFormatter_destroy));

  /// Creates a new `LocaleDisplayNamesFormatter` from locale data and an options bag.
  ///
  /// See the [Rust documentation for `try_new`](https://docs.rs/icu/latest/icu/displaynames/struct.LocaleDisplayNamesFormatter.html#method.try_new) for more information.
  ///
  /// Throws [Error] on failure.
  factory LocaleDisplayNamesFormatter(
      DataProvider provider, Locale locale, DisplayNamesOptions options) {
    final temp = ffi2.Arena();
    final result = _ICU4XLocaleDisplayNamesFormatter_create(
        provider._ffi, locale._ffi, options._toFfi(temp));
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return LocaleDisplayNamesFormatter._fromFfi(result.union.ok, []);
  }

  /// Returns the locale-specific display name of a locale.
  ///
  /// See the [Rust documentation for `of`](https://docs.rs/icu/latest/icu/displaynames/struct.LocaleDisplayNamesFormatter.html#method.of) for more information.
  ///
  /// Throws [Error] on failure.
  String of(Locale locale) {
    final writeable = _Writeable();
    final result =
        _ICU4XLocaleDisplayNamesFormatter_of(_ffi, locale._ffi, writeable._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }
}

@meta.ResourceIdentifier('ICU4XLocaleDisplayNamesFormatter_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true, symbol: 'ICU4XLocaleDisplayNamesFormatter_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XLocaleDisplayNamesFormatter_destroy(
    ffi.Pointer<ffi.Void> self);

@meta.ResourceIdentifier('ICU4XLocaleDisplayNamesFormatter_create')
@ffi.Native<
        _ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Opaque>, _DisplayNamesOptionsFfi)>(
    isLeaf: true, symbol: 'ICU4XLocaleDisplayNamesFormatter_create')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XLocaleDisplayNamesFormatter_create(
    ffi.Pointer<ffi.Opaque> provider,
    ffi.Pointer<ffi.Opaque> locale,
    _DisplayNamesOptionsFfi options);

@meta.ResourceIdentifier('ICU4XLocaleDisplayNamesFormatter_of')
@ffi.Native<
        _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XLocaleDisplayNamesFormatter_of')
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XLocaleDisplayNamesFormatter_of(
    ffi.Pointer<ffi.Opaque> self,
    ffi.Pointer<ffi.Opaque> locale,
    ffi.Pointer<ffi.Opaque> writeable);
