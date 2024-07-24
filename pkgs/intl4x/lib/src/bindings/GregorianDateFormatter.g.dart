// generated by diplomat-tool

part of 'lib.g.dart';

/// An ICU4X TypedDateFormatter object capable of formatting a [`IsoDateTime`] as a string,
/// using the Gregorian Calendar.
///
/// See the [Rust documentation for `TypedDateFormatter`](https://docs.rs/icu/latest/icu/datetime/struct.TypedDateFormatter.html) for more information.
final class GregorianDateFormatter implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  GregorianDateFormatter._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer = ffi.NativeFinalizer(
      ffi.Native.addressOf(_ICU4XGregorianDateFormatter_destroy));

  /// Creates a new [`GregorianDateFormatter`] from locale data.
  ///
  /// See the [Rust documentation for `try_new_with_length`](https://docs.rs/icu/latest/icu/datetime/struct.TypedDateFormatter.html#method.try_new_with_length) for more information.
  ///
  /// Throws [Error] on failure.
  factory GregorianDateFormatter.withLength(
      DataProvider provider, Locale locale, DateLength length) {
    final result = _ICU4XGregorianDateFormatter_create_with_length(
        provider._ffi, locale._ffi, length.index);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return GregorianDateFormatter._fromFfi(result.union.ok, []);
  }

  /// Formats a [`IsoDate`] to a string.
  ///
  /// See the [Rust documentation for `format`](https://docs.rs/icu/latest/icu/datetime/struct.TypedDateFormatter.html#method.format) for more information.
  ///
  /// Throws [Error] on failure.
  String formatIsoDate(IsoDate value) {
    final writeable = _Writeable();
    final result = _ICU4XGregorianDateFormatter_format_iso_date(
        _ffi, value._ffi, writeable._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }

  /// Formats a [`IsoDateTime`] to a string.
  ///
  /// See the [Rust documentation for `format`](https://docs.rs/icu/latest/icu/datetime/struct.TypedDateFormatter.html#method.format) for more information.
  ///
  /// Throws [Error] on failure.
  String formatIsoDatetime(IsoDateTime value) {
    final writeable = _Writeable();
    final result = _ICU4XGregorianDateFormatter_format_iso_datetime(
        _ffi, value._ffi, writeable._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }
}

@meta.ResourceIdentifier('ICU4XGregorianDateFormatter_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true, symbol: 'ICU4XGregorianDateFormatter_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XGregorianDateFormatter_destroy(ffi.Pointer<ffi.Void> self);

@meta.ResourceIdentifier('ICU4XGregorianDateFormatter_create_with_length')
@ffi.Native<
        _ResultOpaqueInt32 Function(
            ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>, ffi.Int32)>(
    isLeaf: true, symbol: 'ICU4XGregorianDateFormatter_create_with_length')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XGregorianDateFormatter_create_with_length(
    ffi.Pointer<ffi.Opaque> provider,
    ffi.Pointer<ffi.Opaque> locale,
    int length);

@meta.ResourceIdentifier('ICU4XGregorianDateFormatter_format_iso_date')
@ffi.Native<
        _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XGregorianDateFormatter_format_iso_date')
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XGregorianDateFormatter_format_iso_date(
    ffi.Pointer<ffi.Opaque> self,
    ffi.Pointer<ffi.Opaque> value,
    ffi.Pointer<ffi.Opaque> writeable);

@meta.ResourceIdentifier('ICU4XGregorianDateFormatter_format_iso_datetime')
@ffi.Native<
        _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XGregorianDateFormatter_format_iso_datetime')
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XGregorianDateFormatter_format_iso_datetime(
    ffi.Pointer<ffi.Opaque> self,
    ffi.Pointer<ffi.Opaque> value,
    ffi.Pointer<ffi.Opaque> writeable);
