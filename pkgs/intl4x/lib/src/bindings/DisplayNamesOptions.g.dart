// generated by diplomat-tool

part of 'lib.g.dart';

final class _DisplayNamesOptionsFfi extends ffi.Struct {
  @ffi.Int32()
  external int style;
  @ffi.Int32()
  external int fallback;
  @ffi.Int32()
  external int languageDisplay;
}

/// See the [Rust documentation for `DisplayNamesOptions`](https://docs.rs/icu/latest/icu/displaynames/options/struct.DisplayNamesOptions.html) for more information.
final class DisplayNamesOptions {
  DisplayNamesStyle style;
  DisplayNamesFallback fallback;
  LanguageDisplay languageDisplay;

  DisplayNamesOptions({
    required this.style,
    required this.fallback,
    required this.languageDisplay,
  });

  // This struct contains borrowed fields, so this takes in a list of
  // "edges" corresponding to where each lifetime's data may have been borrowed from
  // and passes it down to individual fields containing the borrow.
  // This method does not attempt to handle any dependencies between lifetimes, the caller
  // should handle this when constructing edge arrays.
  // ignore: unused_element
  DisplayNamesOptions._fromFfi(_DisplayNamesOptionsFfi ffi)
    : style = DisplayNamesStyle.values[ffi.style],
      fallback = DisplayNamesFallback.values[ffi.fallback],
      languageDisplay = LanguageDisplay.values[ffi.languageDisplay];

  // ignore: unused_element
  _DisplayNamesOptionsFfi _toFfi(ffi.Allocator temp) {
    final struct = ffi.Struct.create<_DisplayNamesOptionsFfi>();
    struct.style = style.index;
    struct.fallback = fallback.index;
    struct.languageDisplay = languageDisplay.index;
    return struct;
  }

  @override
  bool operator ==(Object other) =>
      other is DisplayNamesOptions &&
      other.style == style &&
      other.fallback == fallback &&
      other.languageDisplay == languageDisplay;

  @override
  int get hashCode => Object.hashAll([style, fallback, languageDisplay]);
}
