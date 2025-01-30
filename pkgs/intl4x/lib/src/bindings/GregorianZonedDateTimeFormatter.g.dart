// generated by diplomat-tool

part of 'lib.g.dart';

/// An object capable of formatting a date time with time zone to a string.
///
/// See the [Rust documentation for `TypedZonedDateTimeFormatter`](https://docs.rs/icu/latest/icu/datetime/struct.TypedZonedDateTimeFormatter.html) for more information.
final class GregorianZonedDateTimeFormatter implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  GregorianZonedDateTimeFormatter._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer = ffi.NativeFinalizer(
      ffi.Native.addressOf(_ICU4XGregorianZonedDateTimeFormatter_destroy));

  /// Creates a new [`GregorianZonedDateTimeFormatter`] from locale data.
  ///
  /// This function has `date_length` and `time_length` arguments and uses default options
  /// for the time zone.
  ///
  /// See the [Rust documentation for `try_new`](https://docs.rs/icu/latest/icu/datetime/struct.TypedZonedDateTimeFormatter.html#method.try_new) for more information.
  ///
  /// Throws [Error] on failure.
  factory GregorianZonedDateTimeFormatter.withLengths(DataProvider provider,
      Locale locale, DateLength dateLength, TimeLength timeLength) {
    final result = _ICU4XGregorianZonedDateTimeFormatter_create_with_lengths(
        provider._ffi, locale._ffi, dateLength.index, timeLength.index);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return GregorianZonedDateTimeFormatter._fromFfi(result.union.ok, []);
  }

  /// Creates a new [`GregorianZonedDateTimeFormatter`] from locale data.
  ///
  /// This function has `date_length` and `time_length` arguments and uses an ISO-8601 style
  /// fallback for the time zone with the given configurations.
  ///
  /// See the [Rust documentation for `try_new`](https://docs.rs/icu/latest/icu/datetime/struct.TypedZonedDateTimeFormatter.html#method.try_new) for more information.
  ///
  /// Throws [Error] on failure.
  factory GregorianZonedDateTimeFormatter.withLengthsAndIso8601TimeZoneFallback(
      DataProvider provider,
      Locale locale,
      DateLength dateLength,
      TimeLength timeLength,
      IsoTimeZoneOptions zoneOptions) {
    final temp = ffi2.Arena();
    final result =
        _ICU4XGregorianZonedDateTimeFormatter_create_with_lengths_and_iso_8601_time_zone_fallback(
            provider._ffi,
            locale._ffi,
            dateLength.index,
            timeLength.index,
            zoneOptions._toFfi(temp));
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return GregorianZonedDateTimeFormatter._fromFfi(result.union.ok, []);
  }

  /// Formats a [`IsoDateTime`] and [`CustomTimeZone`] to a string.
  ///
  /// See the [Rust documentation for `format`](https://docs.rs/icu/latest/icu/datetime/struct.TypedZonedDateTimeFormatter.html#method.format) for more information.
  ///
  /// Throws [Error] on failure.
  String formatIsoDatetimeWithCustomTimeZone(
      IsoDateTime datetime, CustomTimeZone timeZone) {
    final writeable = _Writeable();
    final result =
        _ICU4XGregorianZonedDateTimeFormatter_format_iso_datetime_with_custom_time_zone(
            _ffi, datetime._ffi, timeZone._ffi, writeable._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }
}

@RecordSymbol('ICU4XGregorianZonedDateTimeFormatter_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true, symbol: 'ICU4XGregorianZonedDateTimeFormatter_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XGregorianZonedDateTimeFormatter_destroy(
    ffi.Pointer<ffi.Void> self);

@RecordSymbol('ICU4XGregorianZonedDateTimeFormatter_create_with_lengths')
@ffi.Native<
        _ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Opaque>, ffi.Int32, ffi.Int32)>(
    isLeaf: true,
    symbol: 'ICU4XGregorianZonedDateTimeFormatter_create_with_lengths')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32
    _ICU4XGregorianZonedDateTimeFormatter_create_with_lengths(
        ffi.Pointer<ffi.Opaque> provider,
        ffi.Pointer<ffi.Opaque> locale,
        int dateLength,
        int timeLength);

@RecordSymbol(
    'ICU4XGregorianZonedDateTimeFormatter_create_with_lengths_and_iso_8601_time_zone_fallback')
@ffi.Native<
        _ResultOpaqueInt32 Function(
            ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Opaque>,
            ffi.Int32,
            ffi.Int32,
            _IsoTimeZoneOptionsFfi)>(
    isLeaf: true,
    symbol:
        'ICU4XGregorianZonedDateTimeFormatter_create_with_lengths_and_iso_8601_time_zone_fallback')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32
    _ICU4XGregorianZonedDateTimeFormatter_create_with_lengths_and_iso_8601_time_zone_fallback(
        ffi.Pointer<ffi.Opaque> provider,
        ffi.Pointer<ffi.Opaque> locale,
        int dateLength,
        int timeLength,
        _IsoTimeZoneOptionsFfi zoneOptions);

@RecordSymbol(
    'ICU4XGregorianZonedDateTimeFormatter_format_iso_datetime_with_custom_time_zone')
@ffi.Native<
        _ResultVoidInt32 Function(
            ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true,
    symbol:
        'ICU4XGregorianZonedDateTimeFormatter_format_iso_datetime_with_custom_time_zone')
// ignore: non_constant_identifier_names
external _ResultVoidInt32
    _ICU4XGregorianZonedDateTimeFormatter_format_iso_datetime_with_custom_time_zone(
        ffi.Pointer<ffi.Opaque> self,
        ffi.Pointer<ffi.Opaque> datetime,
        ffi.Pointer<ffi.Opaque> timeZone,
        ffi.Pointer<ffi.Opaque> writeable);
