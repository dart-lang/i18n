// generated by diplomat-tool

part of 'lib.g.dart';

/// An ICU4X TimeZoneFormatter object capable of formatting an [`CustomTimeZone`] type (and others) as a string
///
/// See the [Rust documentation for `TimeZoneFormatter`](https://docs.rs/icu/latest/icu/datetime/time_zone/struct.TimeZoneFormatter.html) for more information.
final class TimeZoneFormatter implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  TimeZoneFormatter._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  @_DiplomatFfiUse('ICU4XTimeZoneFormatter_destroy')
  static final _finalizer = ffi.NativeFinalizer(
    ffi.Native.addressOf(_ICU4XTimeZoneFormatter_destroy),
  );

  /// Creates a new [`TimeZoneFormatter`] from locale data.
  ///
  /// Uses localized GMT as the fallback format.
  ///
  /// See the [Rust documentation for `try_new`](https://docs.rs/icu/latest/icu/datetime/time_zone/struct.TimeZoneFormatter.html#method.try_new) for more information.
  ///
  /// Additional information: [1](https://docs.rs/icu/latest/icu/datetime/time_zone/enum.FallbackFormat.html)
  ///
  /// Throws [Error] on failure.
  factory TimeZoneFormatter.withLocalizedGmtFallback(
    DataProvider provider,
    Locale locale,
  ) {
    final result = _ICU4XTimeZoneFormatter_create_with_localized_gmt_fallback(
      provider._ffi,
      locale._ffi,
    );
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return TimeZoneFormatter._fromFfi(result.union.ok, []);
  }

  /// Creates a new [`TimeZoneFormatter`] from locale data.
  ///
  /// Uses ISO-8601 as the fallback format.
  ///
  /// See the [Rust documentation for `try_new`](https://docs.rs/icu/latest/icu/datetime/time_zone/struct.TimeZoneFormatter.html#method.try_new) for more information.
  ///
  /// Additional information: [1](https://docs.rs/icu/latest/icu/datetime/time_zone/enum.FallbackFormat.html)
  ///
  /// Throws [Error] on failure.
  factory TimeZoneFormatter.withIso8601Fallback(
    DataProvider provider,
    Locale locale,
    IsoTimeZoneOptions options,
  ) {
    final temp = ffi2.Arena();
    final result = _ICU4XTimeZoneFormatter_create_with_iso_8601_fallback(
      provider._ffi,
      locale._ffi,
      options._toFfi(temp),
    );
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return TimeZoneFormatter._fromFfi(result.union.ok, []);
  }

  /// Loads generic non-location long format. Example: "Pacific Time"
  ///
  /// See the [Rust documentation for `include_generic_non_location_long`](https://docs.rs/icu/latest/icu/datetime/time_zone/struct.TimeZoneFormatter.html#method.include_generic_non_location_long) for more information.
  ///
  /// Throws [Error] on failure.
  void loadGenericNonLocationLong(DataProvider provider) {
    final result = _ICU4XTimeZoneFormatter_load_generic_non_location_long(
      _ffi,
      provider._ffi,
    );
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
  }

  /// Loads generic non-location short format. Example: "PT"
  ///
  /// See the [Rust documentation for `include_generic_non_location_short`](https://docs.rs/icu/latest/icu/datetime/time_zone/struct.TimeZoneFormatter.html#method.include_generic_non_location_short) for more information.
  ///
  /// Throws [Error] on failure.
  void loadGenericNonLocationShort(DataProvider provider) {
    final result = _ICU4XTimeZoneFormatter_load_generic_non_location_short(
      _ffi,
      provider._ffi,
    );
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
  }

  /// Loads specific non-location long format. Example: "Pacific Standard Time"
  ///
  /// See the [Rust documentation for `include_specific_non_location_long`](https://docs.rs/icu/latest/icu/datetime/time_zone/struct.TimeZoneFormatter.html#method.include_specific_non_location_long) for more information.
  ///
  /// Throws [Error] on failure.
  void loadSpecificNonLocationLong(DataProvider provider) {
    final result = _ICU4XTimeZoneFormatter_load_specific_non_location_long(
      _ffi,
      provider._ffi,
    );
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
  }

  /// Loads specific non-location short format. Example: "PST"
  ///
  /// See the [Rust documentation for `include_specific_non_location_short`](https://docs.rs/icu/latest/icu/datetime/time_zone/struct.TimeZoneFormatter.html#method.include_specific_non_location_short) for more information.
  ///
  /// Throws [Error] on failure.
  void loadSpecificNonLocationShort(DataProvider provider) {
    final result = _ICU4XTimeZoneFormatter_load_specific_non_location_short(
      _ffi,
      provider._ffi,
    );
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
  }

  /// Loads generic location format. Example: "Los Angeles Time"
  ///
  /// See the [Rust documentation for `include_generic_location_format`](https://docs.rs/icu/latest/icu/datetime/time_zone/struct.TimeZoneFormatter.html#method.include_generic_location_format) for more information.
  ///
  /// Throws [Error] on failure.
  void loadGenericLocationFormat(DataProvider provider) {
    final result = _ICU4XTimeZoneFormatter_load_generic_location_format(
      _ffi,
      provider._ffi,
    );
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
  }

  /// Loads localized GMT format. Example: "GMT-07:00"
  ///
  /// See the [Rust documentation for `include_localized_gmt_format`](https://docs.rs/icu/latest/icu/datetime/time_zone/struct.TimeZoneFormatter.html#method.include_localized_gmt_format) for more information.
  ///
  /// Throws [Error] on failure.
  void includeLocalizedGmtFormat() {
    final result = _ICU4XTimeZoneFormatter_include_localized_gmt_format(_ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
  }

  /// Loads ISO-8601 format. Example: "-07:00"
  ///
  /// See the [Rust documentation for `include_iso_8601_format`](https://docs.rs/icu/latest/icu/datetime/time_zone/struct.TimeZoneFormatter.html#method.include_iso_8601_format) for more information.
  ///
  /// Throws [Error] on failure.
  void loadIso8601Format(IsoTimeZoneOptions options) {
    final temp = ffi2.Arena();
    final result = _ICU4XTimeZoneFormatter_load_iso_8601_format(
      _ffi,
      options._toFfi(temp),
    );
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
  }

  /// Formats a [`CustomTimeZone`] to a string.
  ///
  /// See the [Rust documentation for `format`](https://docs.rs/icu/latest/icu/datetime/time_zone/struct.TimeZoneFormatter.html#method.format) for more information.
  ///
  /// See the [Rust documentation for `format_to_string`](https://docs.rs/icu/latest/icu/datetime/time_zone/struct.TimeZoneFormatter.html#method.format_to_string) for more information.
  ///
  /// Throws [Error] on failure.
  String formatCustomTimeZone(CustomTimeZone value) {
    final writeable = _Writeable();
    final result = _ICU4XTimeZoneFormatter_format_custom_time_zone(
      _ffi,
      value._ffi,
      writeable._ffi,
    );
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }

  /// Formats a [`CustomTimeZone`] to a string, performing no fallback
  ///
  /// See the [Rust documentation for `write_no_fallback`](https://docs.rs/icu/latest/icu/datetime/struct.FormattedTimeZone.html#method.write_no_fallback) for more information.
  ///
  /// Throws [Error] on failure.
  String formatCustomTimeZoneNoFallback(CustomTimeZone value) {
    final writeable = _Writeable();
    final result = _ICU4XTimeZoneFormatter_format_custom_time_zone_no_fallback(
      _ffi,
      value._ffi,
      writeable._ffi,
    );
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }
}

@_DiplomatFfiUse('ICU4XTimeZoneFormatter_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
  isLeaf: true,
  symbol: 'ICU4XTimeZoneFormatter_destroy',
)
// ignore: non_constant_identifier_names
external void _ICU4XTimeZoneFormatter_destroy(ffi.Pointer<ffi.Void> self);

@_DiplomatFfiUse('ICU4XTimeZoneFormatter_create_with_localized_gmt_fallback')
@ffi.Native<
  _ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(
  isLeaf: true,
  symbol: 'ICU4XTimeZoneFormatter_create_with_localized_gmt_fallback',
)
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32
_ICU4XTimeZoneFormatter_create_with_localized_gmt_fallback(
  ffi.Pointer<ffi.Opaque> provider,
  ffi.Pointer<ffi.Opaque> locale,
);

@_DiplomatFfiUse('ICU4XTimeZoneFormatter_create_with_iso_8601_fallback')
@ffi.Native<
  _ResultOpaqueInt32 Function(
    ffi.Pointer<ffi.Opaque>,
    ffi.Pointer<ffi.Opaque>,
    _IsoTimeZoneOptionsFfi,
  )
>(isLeaf: true, symbol: 'ICU4XTimeZoneFormatter_create_with_iso_8601_fallback')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32
_ICU4XTimeZoneFormatter_create_with_iso_8601_fallback(
  ffi.Pointer<ffi.Opaque> provider,
  ffi.Pointer<ffi.Opaque> locale,
  _IsoTimeZoneOptionsFfi options,
);

@_DiplomatFfiUse('ICU4XTimeZoneFormatter_load_generic_non_location_long')
@ffi.Native<
  _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(isLeaf: true, symbol: 'ICU4XTimeZoneFormatter_load_generic_non_location_long')
// ignore: non_constant_identifier_names
external _ResultVoidInt32
_ICU4XTimeZoneFormatter_load_generic_non_location_long(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> provider,
);

@_DiplomatFfiUse('ICU4XTimeZoneFormatter_load_generic_non_location_short')
@ffi.Native<
  _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(
  isLeaf: true,
  symbol: 'ICU4XTimeZoneFormatter_load_generic_non_location_short',
)
// ignore: non_constant_identifier_names
external _ResultVoidInt32
_ICU4XTimeZoneFormatter_load_generic_non_location_short(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> provider,
);

@_DiplomatFfiUse('ICU4XTimeZoneFormatter_load_specific_non_location_long')
@ffi.Native<
  _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(
  isLeaf: true,
  symbol: 'ICU4XTimeZoneFormatter_load_specific_non_location_long',
)
// ignore: non_constant_identifier_names
external _ResultVoidInt32
_ICU4XTimeZoneFormatter_load_specific_non_location_long(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> provider,
);

@_DiplomatFfiUse('ICU4XTimeZoneFormatter_load_specific_non_location_short')
@ffi.Native<
  _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(
  isLeaf: true,
  symbol: 'ICU4XTimeZoneFormatter_load_specific_non_location_short',
)
// ignore: non_constant_identifier_names
external _ResultVoidInt32
_ICU4XTimeZoneFormatter_load_specific_non_location_short(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> provider,
);

@_DiplomatFfiUse('ICU4XTimeZoneFormatter_load_generic_location_format')
@ffi.Native<
  _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(isLeaf: true, symbol: 'ICU4XTimeZoneFormatter_load_generic_location_format')
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XTimeZoneFormatter_load_generic_location_format(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> provider,
);

@_DiplomatFfiUse('ICU4XTimeZoneFormatter_include_localized_gmt_format')
@ffi.Native<_ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XTimeZoneFormatter_include_localized_gmt_format',
)
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XTimeZoneFormatter_include_localized_gmt_format(
  ffi.Pointer<ffi.Opaque> self,
);

@_DiplomatFfiUse('ICU4XTimeZoneFormatter_load_iso_8601_format')
@ffi.Native<
  _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>, _IsoTimeZoneOptionsFfi)
>(isLeaf: true, symbol: 'ICU4XTimeZoneFormatter_load_iso_8601_format')
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XTimeZoneFormatter_load_iso_8601_format(
  ffi.Pointer<ffi.Opaque> self,
  _IsoTimeZoneOptionsFfi options,
);

@_DiplomatFfiUse('ICU4XTimeZoneFormatter_format_custom_time_zone')
@ffi.Native<
  _ResultVoidInt32 Function(
    ffi.Pointer<ffi.Opaque>,
    ffi.Pointer<ffi.Opaque>,
    ffi.Pointer<ffi.Opaque>,
  )
>(isLeaf: true, symbol: 'ICU4XTimeZoneFormatter_format_custom_time_zone')
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XTimeZoneFormatter_format_custom_time_zone(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> value,
  ffi.Pointer<ffi.Opaque> writeable,
);

@_DiplomatFfiUse('ICU4XTimeZoneFormatter_format_custom_time_zone_no_fallback')
@ffi.Native<
  _ResultVoidInt32 Function(
    ffi.Pointer<ffi.Opaque>,
    ffi.Pointer<ffi.Opaque>,
    ffi.Pointer<ffi.Opaque>,
  )
>(
  isLeaf: true,
  symbol: 'ICU4XTimeZoneFormatter_format_custom_time_zone_no_fallback',
)
// ignore: non_constant_identifier_names
external _ResultVoidInt32
_ICU4XTimeZoneFormatter_format_custom_time_zone_no_fallback(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> value,
  ffi.Pointer<ffi.Opaque> writeable,
);
