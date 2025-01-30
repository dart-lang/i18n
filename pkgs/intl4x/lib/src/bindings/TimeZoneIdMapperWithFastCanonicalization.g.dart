// generated by diplomat-tool

part of 'lib.g.dart';

/// A mapper between IANA time zone identifiers and BCP-47 time zone identifiers.
///
/// This mapper supports two-way mapping, but it is optimized for the case of IANA to BCP-47.
/// It also supports normalizing and canonicalizing the IANA strings.
///
/// See the [Rust documentation for `TimeZoneIdMapperWithFastCanonicalization`](https://docs.rs/icu/latest/icu/timezone/struct.TimeZoneIdMapperWithFastCanonicalization.html) for more information.
final class TimeZoneIdMapperWithFastCanonicalization
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  TimeZoneIdMapperWithFastCanonicalization._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer = ffi.NativeFinalizer(ffi.Native.addressOf(
      _ICU4XTimeZoneIdMapperWithFastCanonicalization_destroy));

  /// See the [Rust documentation for `new`](https://docs.rs/icu/latest/icu/timezone/struct.TimeZoneIdMapperWithFastCanonicalization.html#method.new) for more information.
  ///
  /// Throws [Error] on failure.
  factory TimeZoneIdMapperWithFastCanonicalization(DataProvider provider) {
    final result =
        _ICU4XTimeZoneIdMapperWithFastCanonicalization_create(provider._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return TimeZoneIdMapperWithFastCanonicalization._fromFfi(
        result.union.ok, []);
  }

  /// See the [Rust documentation for `canonicalize_iana`](https://docs.rs/icu/latest/icu/timezone/struct.TimeZoneIdMapperWithFastCanonicalizationBorrowed.html#method.canonicalize_iana) for more information.
  ///
  /// Throws [Error] on failure.
  String canonicalizeIana(String value) {
    final temp = ffi2.Arena();
    final valueView = value.utf8View;
    final writeable = _Writeable();
    final result =
        _ICU4XTimeZoneIdMapperWithFastCanonicalization_canonicalize_iana(
            _ffi, valueView.allocIn(temp), valueView.length, writeable._ffi);
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }

  /// See the [Rust documentation for `canonical_iana_from_bcp47`](https://docs.rs/icu/latest/icu/timezone/struct.TimeZoneIdMapperWithFastCanonicalizationBorrowed.html#method.canonical_iana_from_bcp47) for more information.
  ///
  /// Throws [Error] on failure.
  String canonicalIanaFromBcp47(String value) {
    final temp = ffi2.Arena();
    final valueView = value.utf8View;
    final writeable = _Writeable();
    final result =
        _ICU4XTimeZoneIdMapperWithFastCanonicalization_canonical_iana_from_bcp47(
            _ffi, valueView.allocIn(temp), valueView.length, writeable._ffi);
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }
}

@RecordSymbol('ICU4XTimeZoneIdMapperWithFastCanonicalization_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true,
    symbol: 'ICU4XTimeZoneIdMapperWithFastCanonicalization_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XTimeZoneIdMapperWithFastCanonicalization_destroy(
    ffi.Pointer<ffi.Void> self);

@RecordSymbol('ICU4XTimeZoneIdMapperWithFastCanonicalization_create')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true,
    symbol: 'ICU4XTimeZoneIdMapperWithFastCanonicalization_create')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32
    _ICU4XTimeZoneIdMapperWithFastCanonicalization_create(
        ffi.Pointer<ffi.Opaque> provider);

@RecordSymbol('ICU4XTimeZoneIdMapperWithFastCanonicalization_canonicalize_iana')
@ffi.Native<
        _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Uint8>, ffi.Size, ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true,
    symbol: 'ICU4XTimeZoneIdMapperWithFastCanonicalization_canonicalize_iana')
// ignore: non_constant_identifier_names
external _ResultVoidInt32
    _ICU4XTimeZoneIdMapperWithFastCanonicalization_canonicalize_iana(
        ffi.Pointer<ffi.Opaque> self,
        ffi.Pointer<ffi.Uint8> valueData,
        int valueLength,
        ffi.Pointer<ffi.Opaque> writeable);

@RecordSymbol(
    'ICU4XTimeZoneIdMapperWithFastCanonicalization_canonical_iana_from_bcp47')
@ffi.Native<
        _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Uint8>, ffi.Size, ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true,
    symbol:
        'ICU4XTimeZoneIdMapperWithFastCanonicalization_canonical_iana_from_bcp47')
// ignore: non_constant_identifier_names
external _ResultVoidInt32
    _ICU4XTimeZoneIdMapperWithFastCanonicalization_canonical_iana_from_bcp47(
        ffi.Pointer<ffi.Opaque> self,
        ffi.Pointer<ffi.Uint8> valueData,
        int valueLength,
        ffi.Pointer<ffi.Opaque> writeable);
