// generated by diplomat-tool

part of 'lib.g.dart';

final class _TitlecaseOptionsFfi extends ffi.Struct {
  @ffi.Int32()
  external int leadingAdjustment;
  @ffi.Int32()
  external int trailingCase;
}

/// See the [Rust documentation for `TitlecaseOptions`](https://docs.rs/icu/latest/icu/casemap/titlecase/struct.TitlecaseOptions.html) for more information.
final class TitlecaseOptions {
  LeadingAdjustment leadingAdjustment;
  TrailingCase trailingCase;

  // This struct contains borrowed fields, so this takes in a list of
  // "edges" corresponding to where each lifetime's data may have been borrowed from
  // and passes it down to individual fields containing the borrow.
  // This method does not attempt to handle any dependencies between lifetimes, the caller
  // should handle this when constructing edge arrays.
  // ignore: unused_element
  TitlecaseOptions._fromFfi(_TitlecaseOptionsFfi ffi)
    : leadingAdjustment = LeadingAdjustment.values[ffi.leadingAdjustment],
      trailingCase = TrailingCase.values[ffi.trailingCase];

  // ignore: unused_element
  _TitlecaseOptionsFfi _toFfi(ffi.Allocator temp) {
    final struct = ffi.Struct.create<_TitlecaseOptionsFfi>();
    struct.leadingAdjustment = leadingAdjustment.index;
    struct.trailingCase = trailingCase.index;
    return struct;
  }

  /// See the [Rust documentation for `default`](https://docs.rs/icu/latest/icu/casemap/titlecase/struct.TitlecaseOptions.html#method.default) for more information.
  factory TitlecaseOptions({
    LeadingAdjustment? leadingAdjustment,
    TrailingCase? trailingCase,
  }) {
    final result = _ICU4XTitlecaseOptionsV1_default_options();
    final dart = TitlecaseOptions._fromFfi(result);
    if (leadingAdjustment != null) {
      dart.leadingAdjustment = leadingAdjustment;
    }
    if (trailingCase != null) {
      dart.trailingCase = trailingCase;
    }
    return dart;
  }

  @override
  bool operator ==(Object other) =>
      other is TitlecaseOptions &&
      other.leadingAdjustment == leadingAdjustment &&
      other.trailingCase == trailingCase;

  @override
  int get hashCode => Object.hashAll([leadingAdjustment, trailingCase]);
}

@RecordSymbol('ICU4XTitlecaseOptionsV1_default_options')
@ffi.Native<_TitlecaseOptionsFfi Function()>(
  isLeaf: true,
  symbol: 'ICU4XTitlecaseOptionsV1_default_options',
)
// ignore: non_constant_identifier_names
external _TitlecaseOptionsFfi _ICU4XTitlecaseOptionsV1_default_options();
