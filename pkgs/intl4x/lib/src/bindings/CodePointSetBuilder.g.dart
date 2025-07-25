// generated by diplomat-tool
// dart format off

part of 'lib.g.dart';

/// See the [Rust documentation for `CodePointInversionListBuilder`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html) for more information.
final class CodePointSetBuilder implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  CodePointSetBuilder._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  @_DiplomatFfiUse('icu4x_CodePointSetBuilder_destroy_mv1')
 static final _finalizer = ffi.NativeFinalizer(ffi.Native.addressOf(_icu4x_CodePointSetBuilder_destroy_mv1));

  /// Make a new set builder containing nothing
  ///
  /// See the [Rust documentation for `new`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.new) for more information.
  factory CodePointSetBuilder() {
    final result = _icu4x_CodePointSetBuilder_create_mv1();
    return CodePointSetBuilder._fromFfi(result, []);
  }

  /// Build this into a set
  ///
  /// This object is repopulated with an empty builder
  ///
  /// See the [Rust documentation for `build`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.build) for more information.
  CodePointSetData build() {
    final result = _icu4x_CodePointSetBuilder_build_mv1(_ffi);
    return CodePointSetData._fromFfi(result, []);
  }

  /// Complements this set
  ///
  /// (Elements in this set are removed and vice versa)
  ///
  /// See the [Rust documentation for `complement`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.complement) for more information.
  void complement() {
    _icu4x_CodePointSetBuilder_complement_mv1(_ffi);
  }

  /// Returns whether this set is empty
  ///
  /// See the [Rust documentation for `is_empty`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.is_empty) for more information.
  bool get isEmpty {
    final result = _icu4x_CodePointSetBuilder_is_empty_mv1(_ffi);
    return result;
  }

  /// Add a single character to the set
  ///
  /// See the [Rust documentation for `add_char`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.add_char) for more information.
  void addChar(Rune ch) {
    _icu4x_CodePointSetBuilder_add_char_mv1(_ffi, ch);
  }

  /// Add an inclusive range of characters to the set
  ///
  /// See the [Rust documentation for `add_range`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.add_range) for more information.
  void addInclusiveRange(Rune start, Rune end) {
    _icu4x_CodePointSetBuilder_add_inclusive_range_mv1(_ffi, start, end);
  }

  /// Add all elements that belong to the provided set to the set
  ///
  /// See the [Rust documentation for `add_set`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.add_set) for more information.
  void addSet(CodePointSetData data) {
    _icu4x_CodePointSetBuilder_add_set_mv1(_ffi, data._ffi);
  }

  /// Remove a single character to the set
  ///
  /// See the [Rust documentation for `remove_char`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.remove_char) for more information.
  void removeChar(Rune ch) {
    _icu4x_CodePointSetBuilder_remove_char_mv1(_ffi, ch);
  }

  /// Remove an inclusive range of characters from the set
  ///
  /// See the [Rust documentation for `remove_range`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.remove_range) for more information.
  void removeInclusiveRange(Rune start, Rune end) {
    _icu4x_CodePointSetBuilder_remove_inclusive_range_mv1(_ffi, start, end);
  }

  /// Remove all elements that belong to the provided set from the set
  ///
  /// See the [Rust documentation for `remove_set`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.remove_set) for more information.
  void removeSet(CodePointSetData data) {
    _icu4x_CodePointSetBuilder_remove_set_mv1(_ffi, data._ffi);
  }

  /// Removes all elements from the set except a single character
  ///
  /// See the [Rust documentation for `retain_char`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.retain_char) for more information.
  void retainChar(Rune ch) {
    _icu4x_CodePointSetBuilder_retain_char_mv1(_ffi, ch);
  }

  /// Removes all elements from the set except an inclusive range of characters f
  ///
  /// See the [Rust documentation for `retain_range`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.retain_range) for more information.
  void retainInclusiveRange(Rune start, Rune end) {
    _icu4x_CodePointSetBuilder_retain_inclusive_range_mv1(_ffi, start, end);
  }

  /// Removes all elements from the set except all elements in the provided set
  ///
  /// See the [Rust documentation for `retain_set`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.retain_set) for more information.
  void retainSet(CodePointSetData data) {
    _icu4x_CodePointSetBuilder_retain_set_mv1(_ffi, data._ffi);
  }

  /// Complement a single character to the set
  ///
  /// (Characters which are in this set are removed and vice versa)
  ///
  /// See the [Rust documentation for `complement_char`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.complement_char) for more information.
  void complementChar(Rune ch) {
    _icu4x_CodePointSetBuilder_complement_char_mv1(_ffi, ch);
  }

  /// Complement an inclusive range of characters from the set
  ///
  /// (Characters which are in this set are removed and vice versa)
  ///
  /// See the [Rust documentation for `complement_range`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.complement_range) for more information.
  void complementInclusiveRange(Rune start, Rune end) {
    _icu4x_CodePointSetBuilder_complement_inclusive_range_mv1(_ffi, start, end);
  }

  /// Complement all elements that belong to the provided set from the set
  ///
  /// (Characters which are in this set are removed and vice versa)
  ///
  /// See the [Rust documentation for `complement_set`](https://docs.rs/icu/2.0.0/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.complement_set) for more information.
  void complementSet(CodePointSetData data) {
    _icu4x_CodePointSetBuilder_complement_set_mv1(_ffi, data._ffi);
  }

}

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_destroy_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_destroy_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_destroy_mv1(ffi.Pointer<ffi.Void> self);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_create_mv1')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function()>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_create_mv1')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _icu4x_CodePointSetBuilder_create_mv1();

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_build_mv1')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_build_mv1')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _icu4x_CodePointSetBuilder_build_mv1(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_complement_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_complement_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_complement_mv1(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_is_empty_mv1')
@ffi.Native<ffi.Bool Function(ffi.Pointer<ffi.Opaque>)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_is_empty_mv1')
// ignore: non_constant_identifier_names
external bool _icu4x_CodePointSetBuilder_is_empty_mv1(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_add_char_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_add_char_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_add_char_mv1(ffi.Pointer<ffi.Opaque> self, Rune ch);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_add_inclusive_range_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32, ffi.Uint32)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_add_inclusive_range_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_add_inclusive_range_mv1(ffi.Pointer<ffi.Opaque> self, Rune start, Rune end);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_add_set_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_add_set_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_add_set_mv1(ffi.Pointer<ffi.Opaque> self, ffi.Pointer<ffi.Opaque> data);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_remove_char_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_remove_char_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_remove_char_mv1(ffi.Pointer<ffi.Opaque> self, Rune ch);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_remove_inclusive_range_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32, ffi.Uint32)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_remove_inclusive_range_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_remove_inclusive_range_mv1(ffi.Pointer<ffi.Opaque> self, Rune start, Rune end);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_remove_set_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_remove_set_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_remove_set_mv1(ffi.Pointer<ffi.Opaque> self, ffi.Pointer<ffi.Opaque> data);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_retain_char_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_retain_char_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_retain_char_mv1(ffi.Pointer<ffi.Opaque> self, Rune ch);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_retain_inclusive_range_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32, ffi.Uint32)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_retain_inclusive_range_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_retain_inclusive_range_mv1(ffi.Pointer<ffi.Opaque> self, Rune start, Rune end);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_retain_set_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_retain_set_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_retain_set_mv1(ffi.Pointer<ffi.Opaque> self, ffi.Pointer<ffi.Opaque> data);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_complement_char_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_complement_char_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_complement_char_mv1(ffi.Pointer<ffi.Opaque> self, Rune ch);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_complement_inclusive_range_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32, ffi.Uint32)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_complement_inclusive_range_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_complement_inclusive_range_mv1(ffi.Pointer<ffi.Opaque> self, Rune start, Rune end);

@_DiplomatFfiUse('icu4x_CodePointSetBuilder_complement_set_mv1')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)>(isLeaf: true, symbol: 'icu4x_CodePointSetBuilder_complement_set_mv1')
// ignore: non_constant_identifier_names
external void _icu4x_CodePointSetBuilder_complement_set_mv1(ffi.Pointer<ffi.Opaque> self, ffi.Pointer<ffi.Opaque> data);

// dart format on
