// generated by diplomat-tool

part of 'lib.g.dart';

/// See the [Rust documentation for `LineBreakIterator`](https://docs.rs/icu/latest/icu/segmenter/struct.LineBreakIterator.html) for more information.
///
/// Additional information: [1](https://docs.rs/icu/latest/icu/segmenter/type.LineBreakIteratorPotentiallyIllFormedUtf8.html)
final class LineBreakIteratorUtf8 implements ffi.Finalizable {
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
  LineBreakIteratorUtf8._fromFfi(this._ffi, this._selfEdge, this._aEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer = ffi.NativeFinalizer(
      ffi.Native.addressOf(_ICU4XLineBreakIteratorUtf8_destroy));

  /// Finds the next breakpoint. Returns -1 if at the end of the string or if the index is
  /// out of range of a 32-bit signed integer.
  ///
  /// See the [Rust documentation for `next`](https://docs.rs/icu/latest/icu/segmenter/struct.LineBreakIterator.html#method.next) for more information.
  int next() {
    final result = _ICU4XLineBreakIteratorUtf8_next(_ffi);
    return result;
  }
}

@RecordSymbol('ICU4XLineBreakIteratorUtf8_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true, symbol: 'ICU4XLineBreakIteratorUtf8_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XLineBreakIteratorUtf8_destroy(ffi.Pointer<ffi.Void> self);

@RecordSymbol('ICU4XLineBreakIteratorUtf8_next')
@ffi.Native<ffi.Int32 Function(ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XLineBreakIteratorUtf8_next')
// ignore: non_constant_identifier_names
external int _ICU4XLineBreakIteratorUtf8_next(ffi.Pointer<ffi.Opaque> self);
