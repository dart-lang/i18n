// generated by diplomat-tool

part of 'lib.g.dart';

/// See the [Rust documentation for `PluralCategory`](https://docs.rs/icu/latest/icu/plurals/enum.PluralCategory.html) for more information.
enum PluralCategory {
  zero,

  one,

  two,

  few,

  many,

  other;

  /// Construct from a string in the format
  /// [specified in TR35](https://unicode.org/reports/tr35/tr35-numbers.html#Language_Plural_Rules)
  ///
  /// See the [Rust documentation for `get_for_cldr_string`](https://docs.rs/icu/latest/icu/plurals/enum.PluralCategory.html#method.get_for_cldr_string) for more information.
  ///
  /// See the [Rust documentation for `get_for_cldr_bytes`](https://docs.rs/icu/latest/icu/plurals/enum.PluralCategory.html#method.get_for_cldr_bytes) for more information.
  static PluralCategory? getForCldrString(String s) {
    final temp = ffi2.Arena();
    final sView = s.utf8View;
    final result = _ICU4XPluralCategory_get_for_cldr_string(
      sView.allocIn(temp),
      sView.length,
    );
    temp.releaseAll();
    if (!result.isOk) {
      return null;
    }
    return PluralCategory.values[result.union.ok];
  }
}

@RecordSymbol('ICU4XPluralCategory_get_for_cldr_string')
@ffi.Native<_ResultInt32Void Function(ffi.Pointer<ffi.Uint8>, ffi.Size)>(
  isLeaf: true,
  symbol: 'ICU4XPluralCategory_get_for_cldr_string',
)
// ignore: non_constant_identifier_names
external _ResultInt32Void _ICU4XPluralCategory_get_for_cldr_string(
  ffi.Pointer<ffi.Uint8> sData,
  int sLength,
);
