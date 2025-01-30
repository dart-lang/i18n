// generated by diplomat-tool

part of 'lib.g.dart';

/// An object that represents the Script_Extensions property for a single character
///
/// See the [Rust documentation for `ScriptExtensionsSet`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptExtensionsSet.html) for more information.
final class ScriptExtensionsSet implements ffi.Finalizable {
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
  ScriptExtensionsSet._fromFfi(this._ffi, this._selfEdge, this._aEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer = ffi.NativeFinalizer(
      ffi.Native.addressOf(_ICU4XScriptExtensionsSet_destroy));

  /// Check if the Script_Extensions property of the given code point covers the given script
  ///
  /// See the [Rust documentation for `contains`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptExtensionsSet.html#method.contains) for more information.
  bool contains(int script) {
    final result = _ICU4XScriptExtensionsSet_contains(_ffi, script);
    return result;
  }

  /// Get the number of scripts contained in here
  ///
  /// See the [Rust documentation for `iter`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptExtensionsSet.html#method.iter) for more information.
  int get count {
    final result = _ICU4XScriptExtensionsSet_count(_ffi);
    return result;
  }

  /// Get script at index
  ///
  /// See the [Rust documentation for `iter`](https://docs.rs/icu/latest/icu/properties/script/struct.ScriptExtensionsSet.html#method.iter) for more information.
  int? scriptAt(int index) {
    final result = _ICU4XScriptExtensionsSet_script_at(_ffi, index);
    if (!result.isOk) {
      return null;
    }
    return result.union.ok;
  }
}

@RecordSymbol('ICU4XScriptExtensionsSet_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true, symbol: 'ICU4XScriptExtensionsSet_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XScriptExtensionsSet_destroy(ffi.Pointer<ffi.Void> self);

@RecordSymbol('ICU4XScriptExtensionsSet_contains')
@ffi.Native<ffi.Bool Function(ffi.Pointer<ffi.Opaque>, ffi.Uint16)>(
    isLeaf: true, symbol: 'ICU4XScriptExtensionsSet_contains')
// ignore: non_constant_identifier_names
external bool _ICU4XScriptExtensionsSet_contains(
    ffi.Pointer<ffi.Opaque> self, int script);

@RecordSymbol('ICU4XScriptExtensionsSet_count')
@ffi.Native<ffi.Size Function(ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XScriptExtensionsSet_count')
// ignore: non_constant_identifier_names
external int _ICU4XScriptExtensionsSet_count(ffi.Pointer<ffi.Opaque> self);

@RecordSymbol('ICU4XScriptExtensionsSet_script_at')
@ffi.Native<_ResultUint16Void Function(ffi.Pointer<ffi.Opaque>, ffi.Size)>(
    isLeaf: true, symbol: 'ICU4XScriptExtensionsSet_script_at')
// ignore: non_constant_identifier_names
external _ResultUint16Void _ICU4XScriptExtensionsSet_script_at(
    ffi.Pointer<ffi.Opaque> self, int index);
