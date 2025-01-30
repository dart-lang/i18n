// generated by diplomat-tool

part of 'lib.g.dart';

/// An object containing bidi information for a given string, produced by `for_text()` on `Bidi`
///
/// See the [Rust documentation for `BidiInfo`](https://docs.rs/unicode_bidi/latest/unicode_bidi/struct.BidiInfo.html) for more information.
final class BidiInfo implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;
  // ignore: unused_field
  final core.List<Object> _textEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  BidiInfo._fromFfi(this._ffi, this._selfEdge, this._textEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer =
      ffi.NativeFinalizer(ffi.Native.addressOf(_ICU4XBidiInfo_destroy));

  /// The number of paragraphs contained here
  int get paragraphCount {
    final result = _ICU4XBidiInfo_paragraph_count(_ffi);
    return result;
  }

  /// Get the nth paragraph, returning `None` if out of bounds
  BidiParagraph? paragraphAt(int n) {
    // This lifetime edge depends on lifetimes: 'text
    core.List<Object> textEdges = [this];
    final result = _ICU4XBidiInfo_paragraph_at(_ffi, n);
    return result.address == 0
        ? null
        : BidiParagraph._fromFfi(result, [], textEdges);
  }

  /// The number of bytes in this full text
  int get size {
    final result = _ICU4XBidiInfo_size(_ffi);
    return result;
  }

  /// Get the BIDI level at a particular byte index in the full text.
  /// This integer is conceptually a `unicode_bidi::Level`,
  /// and can be further inspected using the static methods on ICU4XBidi.
  ///
  /// Returns 0 (equivalent to `Level::ltr()`) on error
  int levelAt(int pos) {
    final result = _ICU4XBidiInfo_level_at(_ffi, pos);
    return result;
  }
}

@RecordSymbol('ICU4XBidiInfo_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true, symbol: 'ICU4XBidiInfo_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XBidiInfo_destroy(ffi.Pointer<ffi.Void> self);

@RecordSymbol('ICU4XBidiInfo_paragraph_count')
@ffi.Native<ffi.Size Function(ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XBidiInfo_paragraph_count')
// ignore: non_constant_identifier_names
external int _ICU4XBidiInfo_paragraph_count(ffi.Pointer<ffi.Opaque> self);

@RecordSymbol('ICU4XBidiInfo_paragraph_at')
@ffi.Native<
        ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>, ffi.Size)>(
    isLeaf: true, symbol: 'ICU4XBidiInfo_paragraph_at')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XBidiInfo_paragraph_at(
    ffi.Pointer<ffi.Opaque> self, int n);

@RecordSymbol('ICU4XBidiInfo_size')
@ffi.Native<ffi.Size Function(ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XBidiInfo_size')
// ignore: non_constant_identifier_names
external int _ICU4XBidiInfo_size(ffi.Pointer<ffi.Opaque> self);

@RecordSymbol('ICU4XBidiInfo_level_at')
@ffi.Native<ffi.Uint8 Function(ffi.Pointer<ffi.Opaque>, ffi.Size)>(
    isLeaf: true, symbol: 'ICU4XBidiInfo_level_at')
// ignore: non_constant_identifier_names
external int _ICU4XBidiInfo_level_at(ffi.Pointer<ffi.Opaque> self, int pos);
