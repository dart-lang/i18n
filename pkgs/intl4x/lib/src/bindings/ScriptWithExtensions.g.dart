// generated by diplomat-tool

part of 'lib.g.dart';

/// An ICU4X ScriptWithExtensions map object, capable of holding a map of codepoints to scriptextensions values
///
/// See the [Rust documentation for `ScriptWithExtensions`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptWithExtensions.html) for more information.
final class ScriptWithExtensions implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  ScriptWithExtensions._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer = ffi.NativeFinalizer(
      ffi.Native.addressOf(_ICU4XScriptWithExtensions_destroy));

  /// See the [Rust documentation for `script_with_extensions`](https://docs.rs/icu/latest/icu/properties/script/fn.script_with_extensions.html) for more information.
  ///
  /// Throws [Error] on failure.
  factory ScriptWithExtensions(DataProvider provider) {
    final result = _ICU4XScriptWithExtensions_create(provider._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return ScriptWithExtensions._fromFfi(result.union.ok, []);
  }

  /// Get the Script property value for a code point
  ///
  /// See the [Rust documentation for `get_script_val`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptWithExtensionsBorrowed.html#method.get_script_val) for more information.
  int getScriptVal(int codePoint) {
    final result = _ICU4XScriptWithExtensions_get_script_val(_ffi, codePoint);
    return result;
  }

  /// Check if the Script_Extensions property of the given code point covers the given script
  ///
  /// See the [Rust documentation for `has_script`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptWithExtensionsBorrowed.html#method.has_script) for more information.
  bool hasScript(int codePoint, int script) {
    final result =
        _ICU4XScriptWithExtensions_has_script(_ffi, codePoint, script);
    return result;
  }

  /// Borrow this object for a slightly faster variant with more operations
  ///
  /// See the [Rust documentation for `as_borrowed`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptWithExtensions.html#method.as_borrowed) for more information.
  ScriptWithExtensionsBorrowed get asBorrowed {
    // This lifetime edge depends on lifetimes: 'a
    core.List<Object> aEdges = [this];
    final result = _ICU4XScriptWithExtensions_as_borrowed(_ffi);
    return ScriptWithExtensionsBorrowed._fromFfi(result, [], aEdges);
  }

  /// Get a list of ranges of code points that contain this script in their Script_Extensions values
  ///
  /// See the [Rust documentation for `get_script_extensions_ranges`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptWithExtensionsBorrowed.html#method.get_script_extensions_ranges) for more information.
  CodePointRangeIterator iterRangesForScript(int script) {
    // This lifetime edge depends on lifetimes: 'a
    core.List<Object> aEdges = [this];
    final result =
        _ICU4XScriptWithExtensions_iter_ranges_for_script(_ffi, script);
    return CodePointRangeIterator._fromFfi(result, [], aEdges);
  }
}

@RecordSymbol('ICU4XScriptWithExtensions_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true, symbol: 'ICU4XScriptWithExtensions_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XScriptWithExtensions_destroy(ffi.Pointer<ffi.Void> self);

@RecordSymbol('ICU4XScriptWithExtensions_create')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XScriptWithExtensions_create')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XScriptWithExtensions_create(
    ffi.Pointer<ffi.Opaque> provider);

@RecordSymbol('ICU4XScriptWithExtensions_get_script_val')
@ffi.Native<ffi.Uint16 Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
    isLeaf: true, symbol: 'ICU4XScriptWithExtensions_get_script_val')
// ignore: non_constant_identifier_names
external int _ICU4XScriptWithExtensions_get_script_val(
    ffi.Pointer<ffi.Opaque> self, int codePoint);

@RecordSymbol('ICU4XScriptWithExtensions_has_script')
@ffi.Native<ffi.Bool Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32, ffi.Uint16)>(
    isLeaf: true, symbol: 'ICU4XScriptWithExtensions_has_script')
// ignore: non_constant_identifier_names
external bool _ICU4XScriptWithExtensions_has_script(
    ffi.Pointer<ffi.Opaque> self, int codePoint, int script);

@RecordSymbol('ICU4XScriptWithExtensions_as_borrowed')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XScriptWithExtensions_as_borrowed')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XScriptWithExtensions_as_borrowed(
    ffi.Pointer<ffi.Opaque> self);

@RecordSymbol('ICU4XScriptWithExtensions_iter_ranges_for_script')
@ffi.Native<
        ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>, ffi.Uint16)>(
    isLeaf: true, symbol: 'ICU4XScriptWithExtensions_iter_ranges_for_script')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque>
    _ICU4XScriptWithExtensions_iter_ranges_for_script(
        ffi.Pointer<ffi.Opaque> self, int script);
