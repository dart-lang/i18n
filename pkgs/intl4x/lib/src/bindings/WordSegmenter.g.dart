// generated by diplomat-tool

part of 'lib.g.dart';

/// An ICU4X word-break segmenter, capable of finding word breakpoints in strings.
///
/// See the [Rust documentation for `WordSegmenter`](https://docs.rs/icu/latest/icu/segmenter/struct.WordSegmenter.html) for more information.
final class WordSegmenter implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  WordSegmenter._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer =
      ffi.NativeFinalizer(ffi.Native.addressOf(_ICU4XWordSegmenter_destroy));

  /// Construct an [`WordSegmenter`] with automatically selecting the best available LSTM
  /// or dictionary payload data.
  ///
  /// Note: currently, it uses dictionary for Chinese and Japanese, and LSTM for Burmese,
  /// Khmer, Lao, and Thai.
  ///
  /// See the [Rust documentation for `new_auto`](https://docs.rs/icu/latest/icu/segmenter/struct.WordSegmenter.html#method.new_auto) for more information.
  ///
  /// Throws [Error] on failure.
  factory WordSegmenter.auto(DataProvider provider) {
    final result = _ICU4XWordSegmenter_create_auto(provider._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return WordSegmenter._fromFfi(result.union.ok, []);
  }

  /// Construct an [`WordSegmenter`] with LSTM payload data for Burmese, Khmer, Lao, and
  /// Thai.
  ///
  /// Warning: [`WordSegmenter`] created by this function doesn't handle Chinese or
  /// Japanese.
  ///
  /// See the [Rust documentation for `new_lstm`](https://docs.rs/icu/latest/icu/segmenter/struct.WordSegmenter.html#method.new_lstm) for more information.
  ///
  /// Throws [Error] on failure.
  factory WordSegmenter.lstm(DataProvider provider) {
    final result = _ICU4XWordSegmenter_create_lstm(provider._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return WordSegmenter._fromFfi(result.union.ok, []);
  }

  /// Construct an [`WordSegmenter`] with dictionary payload data for Chinese, Japanese,
  /// Burmese, Khmer, Lao, and Thai.
  ///
  /// See the [Rust documentation for `new_dictionary`](https://docs.rs/icu/latest/icu/segmenter/struct.WordSegmenter.html#method.new_dictionary) for more information.
  ///
  /// Throws [Error] on failure.
  factory WordSegmenter.dictionary(DataProvider provider) {
    final result = _ICU4XWordSegmenter_create_dictionary(provider._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return WordSegmenter._fromFfi(result.union.ok, []);
  }

  /// Segments a string.
  ///
  /// Ill-formed input is treated as if errors had been replaced with REPLACEMENT CHARACTERs according
  /// to the WHATWG Encoding Standard.
  ///
  /// See the [Rust documentation for `segment_utf16`](https://docs.rs/icu/latest/icu/segmenter/struct.WordSegmenter.html#method.segment_utf16) for more information.
  WordBreakIteratorUtf16 segment(String input) {
    final inputView = input.utf16View;
    final inputArena = _FinalizedArena();
    // This lifetime edge depends on lifetimes: 'a
    core.List<Object> aEdges = [this, inputArena];
    final result = _ICU4XWordSegmenter_segment_utf16(
        _ffi, inputView.allocIn(inputArena.arena), inputView.length);
    return WordBreakIteratorUtf16._fromFfi(result, [], aEdges);
  }
}

@KeepSymbol('ICU4XWordSegmenter_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true, symbol: 'ICU4XWordSegmenter_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XWordSegmenter_destroy(ffi.Pointer<ffi.Void> self);

@KeepSymbol('ICU4XWordSegmenter_create_auto')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XWordSegmenter_create_auto')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XWordSegmenter_create_auto(
    ffi.Pointer<ffi.Opaque> provider);

@KeepSymbol('ICU4XWordSegmenter_create_lstm')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XWordSegmenter_create_lstm')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XWordSegmenter_create_lstm(
    ffi.Pointer<ffi.Opaque> provider);

@KeepSymbol('ICU4XWordSegmenter_create_dictionary')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XWordSegmenter_create_dictionary')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XWordSegmenter_create_dictionary(
    ffi.Pointer<ffi.Opaque> provider);

@KeepSymbol('ICU4XWordSegmenter_segment_utf16')
@ffi.Native<
    ffi.Pointer<ffi.Opaque> Function(
        ffi.Pointer<ffi.Opaque>,
        ffi.Pointer<ffi.Uint16>,
        ffi.Size)>(isLeaf: true, symbol: 'ICU4XWordSegmenter_segment_utf16')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XWordSegmenter_segment_utf16(
    ffi.Pointer<ffi.Opaque> self,
    ffi.Pointer<ffi.Uint16> inputData,
    int inputLength);
