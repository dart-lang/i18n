// generated by diplomat-tool

part of 'lib.g.dart';

/// An iterator over the locale under fallback.
///
/// See the [Rust documentation for `LocaleFallbackIterator`](https://docs.rs/icu/latest/icu/locid_transform/fallback/struct.LocaleFallbackIterator.html) for more information.
final class LocaleFallbackIterator implements ffi.Finalizable, core.Iterator<Locale> {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;
  // ignore: unused_field
  final core.List<Object> _aEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  LocaleFallbackIterator._fromFfi(this._ffi, this._selfEdge, this._aEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer = ffi.NativeFinalizer(ffi.Native.addressOf(_ICU4XLocaleFallbackIterator_destroy));

  Locale? _current;

  Locale get current => _current!;

  bool moveNext() {
    _current = _iteratorNext();
    return _current != null;
  }

  /// A combination of `get` and `step`. Returns the value that `get` would return
  /// and advances the iterator until hitting `und`.
  Locale? _iteratorNext() {
    final result = _ICU4XLocaleFallbackIterator_next(_ffi);
    return result.address == 0 ? null : Locale._fromFfi(result, []);
  }
}

@meta.ResourceIdentifier('ICU4XLocaleFallbackIterator_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(isLeaf: true, symbol: 'ICU4XLocaleFallbackIterator_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XLocaleFallbackIterator_destroy(ffi.Pointer<ffi.Void> self);

@meta.ResourceIdentifier('ICU4XLocaleFallbackIterator_next')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>)>(isLeaf: true, symbol: 'ICU4XLocaleFallbackIterator_next')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XLocaleFallbackIterator_next(ffi.Pointer<ffi.Opaque> self);
