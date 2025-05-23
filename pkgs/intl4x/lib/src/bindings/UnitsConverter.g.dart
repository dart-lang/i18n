// generated by diplomat-tool

part of 'lib.g.dart';

/// An ICU4X Units Converter object, capable of converting between two [`MeasureUnit`]s.
///
/// You can create an instance of this object using [`UnitsConverterFactory`] by calling the `converter` method.
///
/// See the [Rust documentation for `UnitsConverter`](https://docs.rs/icu/latest/icu/experimental/units/converter/struct.UnitsConverter.html) for more information.
final class UnitsConverter implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  UnitsConverter._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  @_DiplomatFfiUse('ICU4XUnitsConverter_destroy')
  static final _finalizer = ffi.NativeFinalizer(
    ffi.Native.addressOf(_ICU4XUnitsConverter_destroy),
  );

  /// Converts the input value in float from the input unit to the output unit (that have been used to create this converter).
  /// NOTE:
  /// The conversion using floating-point operations is not as accurate as the conversion using ratios.
  ///
  /// See the [Rust documentation for `convert`](https://docs.rs/icu/latest/icu/experimental/units/converter/struct.UnitsConverter.html#method.convert) for more information.
  double convertDouble(double value) {
    final result = _ICU4XUnitsConverter_convert_f64(_ffi, value);
    return result;
  }

  /// Clones the current [`UnitsConverter`] object.
  ///
  /// See the [Rust documentation for `clone`](https://docs.rs/icu/latest/icu/experimental/units/converter/struct.UnitsConverter.html#method.clone) for more information.
  UnitsConverter clone() {
    final result = _ICU4XUnitsConverter_clone(_ffi);
    return UnitsConverter._fromFfi(result, []);
  }
}

@_DiplomatFfiUse('ICU4XUnitsConverter_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
  isLeaf: true,
  symbol: 'ICU4XUnitsConverter_destroy',
)
// ignore: non_constant_identifier_names
external void _ICU4XUnitsConverter_destroy(ffi.Pointer<ffi.Void> self);

@_DiplomatFfiUse('ICU4XUnitsConverter_convert_f64')
@ffi.Native<ffi.Double Function(ffi.Pointer<ffi.Opaque>, ffi.Double)>(
  isLeaf: true,
  symbol: 'ICU4XUnitsConverter_convert_f64',
)
// ignore: non_constant_identifier_names
external double _ICU4XUnitsConverter_convert_f64(
  ffi.Pointer<ffi.Opaque> self,
  double value,
);

@_DiplomatFfiUse('ICU4XUnitsConverter_clone')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XUnitsConverter_clone',
)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XUnitsConverter_clone(
  ffi.Pointer<ffi.Opaque> self,
);
