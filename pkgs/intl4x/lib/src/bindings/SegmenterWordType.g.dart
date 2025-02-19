// generated by diplomat-tool

part of 'lib.g.dart';

/// See the [Rust documentation for `WordType`](https://docs.rs/icu/latest/icu/segmenter/enum.WordType.html) for more information.
enum SegmenterWordType {
  none,

  number,

  letter;

  /// See the [Rust documentation for `is_word_like`](https://docs.rs/icu/latest/icu/segmenter/enum.WordType.html#method.is_word_like) for more information.
  bool get isWordLike {
    final result = _ICU4XSegmenterWordType_is_word_like(index);
    return result;
  }
}

@RecordSymbol('ICU4XSegmenterWordType_is_word_like')
@ffi.Native<ffi.Bool Function(ffi.Int32)>(
  isLeaf: true,
  symbol: 'ICU4XSegmenterWordType_is_word_like',
)
// ignore: non_constant_identifier_names
external bool _ICU4XSegmenterWordType_is_word_like(int self);
