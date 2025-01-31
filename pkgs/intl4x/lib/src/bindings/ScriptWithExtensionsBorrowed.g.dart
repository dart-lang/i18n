// generated by diplomat-tool

part of 'lib.g.dart';

/// A slightly faster ICU4XScriptWithExtensions object
///
/// See the [Rust documentation for `ScriptWithExtensionsBorrowed`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptWithExtensionsBorrowed.html) for more information.
final class ScriptWithExtensionsBorrowed implements ffi.Finalizable {
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
  ScriptWithExtensionsBorrowed._fromFfi(
      this._ffi, this._selfEdge, this._aEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  @RecordSymbol('ICU4XScriptWithExtensionsBorrowed_destroy')
  static final _finalizer = ffi.NativeFinalizer(
      ffi.Native.addressOf(_ICU4XScriptWithExtensionsBorrowed_destroy));

  /// Get the Script property value for a code point
  ///
  /// See the [Rust documentation for `get_script_val`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptWithExtensionsBorrowed.html#method.get_script_val) for more information.
  int getScriptVal(int codePoint) {
    final result =
        _ICU4XScriptWithExtensionsBorrowed_get_script_val(_ffi, codePoint);
    return result;
  }

  /// Get the Script property value for a code point
  ///
  /// See the [Rust documentation for `get_script_extensions_val`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptWithExtensionsBorrowed.html#method.get_script_extensions_val) for more information.
  ScriptExtensionsSet getScriptExtensionsVal(int codePoint) {
    // This lifetime edge depends on lifetimes: 'a
    core.List<Object> aEdges = [this];
    final result = _ICU4XScriptWithExtensionsBorrowed_get_script_extensions_val(
        _ffi, codePoint);
    return ScriptExtensionsSet._fromFfi(result, [], aEdges);
  }

  /// Check if the Script_Extensions property of the given code point covers the given script
  ///
  /// See the [Rust documentation for `has_script`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptWithExtensionsBorrowed.html#method.has_script) for more information.
  bool hasScript(int codePoint, int script) {
    final result =
        _ICU4XScriptWithExtensionsBorrowed_has_script(_ffi, codePoint, script);
    return result;
  }

  /// Build the CodePointSetData corresponding to a codepoints matching a particular script
  /// in their Script_Extensions
  ///
  /// See the [Rust documentation for `get_script_extensions_set`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptWithExtensionsBorrowed.html#method.get_script_extensions_set) for more information.
  CodePointSetData getScriptExtensionsSet(int script) {
    final result = _ICU4XScriptWithExtensionsBorrowed_get_script_extensions_set(
        _ffi, script);
    return CodePointSetData._fromFfi(result, []);
  }
}

@RecordSymbol('ICU4XScriptWithExtensionsBorrowed_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true, symbol: 'ICU4XScriptWithExtensionsBorrowed_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XScriptWithExtensionsBorrowed_destroy(
    ffi.Pointer<ffi.Void> self);

@RecordSymbol('ICU4XScriptWithExtensionsBorrowed_get_script_val')
@ffi.Native<ffi.Uint16 Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
    isLeaf: true, symbol: 'ICU4XScriptWithExtensionsBorrowed_get_script_val')
// ignore: non_constant_identifier_names
external int _ICU4XScriptWithExtensionsBorrowed_get_script_val(
    ffi.Pointer<ffi.Opaque> self, int codePoint);

@RecordSymbol('ICU4XScriptWithExtensionsBorrowed_get_script_extensions_val')
@ffi.Native<
        ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
    isLeaf: true,
    symbol: 'ICU4XScriptWithExtensionsBorrowed_get_script_extensions_val')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque>
    _ICU4XScriptWithExtensionsBorrowed_get_script_extensions_val(
        ffi.Pointer<ffi.Opaque> self, int codePoint);

@RecordSymbol('ICU4XScriptWithExtensionsBorrowed_has_script')
@ffi.Native<ffi.Bool Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32, ffi.Uint16)>(
    isLeaf: true, symbol: 'ICU4XScriptWithExtensionsBorrowed_has_script')
// ignore: non_constant_identifier_names
external bool _ICU4XScriptWithExtensionsBorrowed_has_script(
    ffi.Pointer<ffi.Opaque> self, int codePoint, int script);

@RecordSymbol('ICU4XScriptWithExtensionsBorrowed_get_script_extensions_set')
@ffi.Native<
        ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>, ffi.Uint16)>(
    isLeaf: true,
    symbol: 'ICU4XScriptWithExtensionsBorrowed_get_script_extensions_set')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque>
    _ICU4XScriptWithExtensionsBorrowed_get_script_extensions_set(
        ffi.Pointer<ffi.Opaque> self, int script);
