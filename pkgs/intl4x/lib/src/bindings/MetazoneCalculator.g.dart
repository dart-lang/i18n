// generated by diplomat-tool

part of 'lib.g.dart';

/// An object capable of computing the metazone from a timezone.
///
/// This can be used via `maybe_calculate_metazone()` on [`CustomTimeZone`].
///
/// [`CustomTimeZone`]: crate::timezone::ffi::ICU4XCustomTimeZone
///
/// See the [Rust documentation for `MetazoneCalculator`](https://docs.rs/icu/latest/icu/timezone/struct.MetazoneCalculator.html) for more information.
final class MetazoneCalculator implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  MetazoneCalculator._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer = ffi.NativeFinalizer(ffi.Native.addressOf(_ICU4XMetazoneCalculator_destroy));

  /// See the [Rust documentation for `new`](https://docs.rs/icu/latest/icu/timezone/struct.MetazoneCalculator.html#method.new) for more information.
  ///
  /// Throws [Error] on failure.
  factory MetazoneCalculator(DataProvider provider) {
    final result = _ICU4XMetazoneCalculator_create(provider._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return MetazoneCalculator._fromFfi(result.union.ok, []);
  }
}

@meta.ResourceIdentifier('ICU4XMetazoneCalculator_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(isLeaf: true, symbol: 'ICU4XMetazoneCalculator_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XMetazoneCalculator_destroy(ffi.Pointer<ffi.Void> self);

@meta.ResourceIdentifier('ICU4XMetazoneCalculator_create')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(isLeaf: true, symbol: 'ICU4XMetazoneCalculator_create')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XMetazoneCalculator_create(ffi.Pointer<ffi.Opaque> provider);
