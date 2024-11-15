// generated by diplomat-tool

part of 'lib.g.dart';

/// See the [Rust documentation for `GraphemeClusterBreakIterator`](https://docs.rs/icu/latest/icu/segmenter/struct.GraphemeClusterBreakIterator.html) for more information.
final class GraphemeClusterBreakIteratorLatin1 implements ffi.Finalizable {
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
  GraphemeClusterBreakIteratorLatin1._fromFfi(
      this._ffi, this._selfEdge, this._aEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer = ffi.NativeFinalizer(
      ffi.Native.addressOf(_ICU4XGraphemeClusterBreakIteratorLatin1_destroy));

  /// Finds the next breakpoint. Returns -1 if at the end of the string or if the index is
  /// out of range of a 32-bit signed integer.
  ///
  /// See the [Rust documentation for `next`](https://docs.rs/icu/latest/icu/segmenter/struct.GraphemeClusterBreakIterator.html#method.next) for more information.
  int next() {
    final result = _ICU4XGraphemeClusterBreakIteratorLatin1_next(_ffi);
    return result;
  }
}

@meta.ResourceIdentifier('ICU4XGraphemeClusterBreakIteratorLatin1_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true, symbol: 'ICU4XGraphemeClusterBreakIteratorLatin1_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XGraphemeClusterBreakIteratorLatin1_destroy(
    ffi.Pointer<ffi.Void> self);

@meta.ResourceIdentifier('ICU4XGraphemeClusterBreakIteratorLatin1_next')
@ffi.Native<ffi.Int32 Function(ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XGraphemeClusterBreakIteratorLatin1_next')
// ignore: non_constant_identifier_names
external int _ICU4XGraphemeClusterBreakIteratorLatin1_next(
    ffi.Pointer<ffi.Opaque> self);
