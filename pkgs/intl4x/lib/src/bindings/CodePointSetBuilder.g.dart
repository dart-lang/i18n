// generated by diplomat-tool

part of 'lib.g.dart';

/// See the [Rust documentation for `CodePointInversionListBuilder`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html) for more information.
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

  @_DiplomatFfiUse('ICU4XCodePointSetBuilder_destroy')
  static final _finalizer = ffi.NativeFinalizer(
    ffi.Native.addressOf(_ICU4XCodePointSetBuilder_destroy),
  );

  /// Make a new set builder containing nothing
  ///
  /// See the [Rust documentation for `new`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.new) for more information.
  factory CodePointSetBuilder() {
    final result = _ICU4XCodePointSetBuilder_create();
    return CodePointSetBuilder._fromFfi(result, []);
  }

  /// Build this into a set
  ///
  /// This object is repopulated with an empty builder
  ///
  /// See the [Rust documentation for `build`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.build) for more information.
  CodePointSetData build() {
    final result = _ICU4XCodePointSetBuilder_build(_ffi);
    return CodePointSetData._fromFfi(result, []);
  }

  /// Complements this set
  ///
  /// (Elements in this set are removed and vice versa)
  ///
  /// See the [Rust documentation for `complement`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.complement) for more information.
  void complement() {
    _ICU4XCodePointSetBuilder_complement(_ffi);
  }

  /// Returns whether this set is empty
  ///
  /// See the [Rust documentation for `is_empty`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.is_empty) for more information.
  bool get isEmpty {
    final result = _ICU4XCodePointSetBuilder_is_empty(_ffi);
    return result;
  }

  /// Add a single character to the set
  ///
  /// See the [Rust documentation for `add_char`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.add_char) for more information.
  void addChar(Rune ch) {
    _ICU4XCodePointSetBuilder_add_char(_ffi, ch);
  }

  /// Add an inclusive range of characters to the set
  ///
  /// See the [Rust documentation for `add_range`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.add_range) for more information.
  void addInclusiveRange(Rune start, Rune end) {
    _ICU4XCodePointSetBuilder_add_inclusive_range(_ffi, start, end);
  }

  /// Add all elements that belong to the provided set to the set
  ///
  /// See the [Rust documentation for `add_set`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.add_set) for more information.
  void addSet(CodePointSetData data) {
    _ICU4XCodePointSetBuilder_add_set(_ffi, data._ffi);
  }

  /// Remove a single character to the set
  ///
  /// See the [Rust documentation for `remove_char`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.remove_char) for more information.
  void removeChar(Rune ch) {
    _ICU4XCodePointSetBuilder_remove_char(_ffi, ch);
  }

  /// Remove an inclusive range of characters from the set
  ///
  /// See the [Rust documentation for `remove_range`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.remove_range) for more information.
  void removeInclusiveRange(Rune start, Rune end) {
    _ICU4XCodePointSetBuilder_remove_inclusive_range(_ffi, start, end);
  }

  /// Remove all elements that belong to the provided set from the set
  ///
  /// See the [Rust documentation for `remove_set`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.remove_set) for more information.
  void removeSet(CodePointSetData data) {
    _ICU4XCodePointSetBuilder_remove_set(_ffi, data._ffi);
  }

  /// Removes all elements from the set except a single character
  ///
  /// See the [Rust documentation for `retain_char`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.retain_char) for more information.
  void retainChar(Rune ch) {
    _ICU4XCodePointSetBuilder_retain_char(_ffi, ch);
  }

  /// Removes all elements from the set except an inclusive range of characters f
  ///
  /// See the [Rust documentation for `retain_range`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.retain_range) for more information.
  void retainInclusiveRange(Rune start, Rune end) {
    _ICU4XCodePointSetBuilder_retain_inclusive_range(_ffi, start, end);
  }

  /// Removes all elements from the set except all elements in the provided set
  ///
  /// See the [Rust documentation for `retain_set`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.retain_set) for more information.
  void retainSet(CodePointSetData data) {
    _ICU4XCodePointSetBuilder_retain_set(_ffi, data._ffi);
  }

  /// Complement a single character to the set
  ///
  /// (Characters which are in this set are removed and vice versa)
  ///
  /// See the [Rust documentation for `complement_char`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.complement_char) for more information.
  void complementChar(Rune ch) {
    _ICU4XCodePointSetBuilder_complement_char(_ffi, ch);
  }

  /// Complement an inclusive range of characters from the set
  ///
  /// (Characters which are in this set are removed and vice versa)
  ///
  /// See the [Rust documentation for `complement_range`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.complement_range) for more information.
  void complementInclusiveRange(Rune start, Rune end) {
    _ICU4XCodePointSetBuilder_complement_inclusive_range(_ffi, start, end);
  }

  /// Complement all elements that belong to the provided set from the set
  ///
  /// (Characters which are in this set are removed and vice versa)
  ///
  /// See the [Rust documentation for `complement_set`](https://docs.rs/icu/latest/icu/collections/codepointinvlist/struct.CodePointInversionListBuilder.html#method.complement_set) for more information.
  void complementSet(CodePointSetData data) {
    _ICU4XCodePointSetBuilder_complement_set(_ffi, data._ffi);
  }
}

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_destroy',
)
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_destroy(ffi.Pointer<ffi.Void> self);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_create')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function()>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_create',
)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XCodePointSetBuilder_create();

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_build')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_build',
)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XCodePointSetBuilder_build(
  ffi.Pointer<ffi.Opaque> self,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_complement')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_complement',
)
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_complement(
  ffi.Pointer<ffi.Opaque> self,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_is_empty')
@ffi.Native<ffi.Bool Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_is_empty',
)
// ignore: non_constant_identifier_names
external bool _ICU4XCodePointSetBuilder_is_empty(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_add_char')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_add_char',
)
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_add_char(
  ffi.Pointer<ffi.Opaque> self,
  Rune ch,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_add_inclusive_range')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32, ffi.Uint32)>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_add_inclusive_range',
)
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_add_inclusive_range(
  ffi.Pointer<ffi.Opaque> self,
  Rune start,
  Rune end,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_add_set')
@ffi.Native<
  ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(isLeaf: true, symbol: 'ICU4XCodePointSetBuilder_add_set')
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_add_set(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> data,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_remove_char')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_remove_char',
)
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_remove_char(
  ffi.Pointer<ffi.Opaque> self,
  Rune ch,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_remove_inclusive_range')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32, ffi.Uint32)>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_remove_inclusive_range',
)
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_remove_inclusive_range(
  ffi.Pointer<ffi.Opaque> self,
  Rune start,
  Rune end,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_remove_set')
@ffi.Native<
  ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(isLeaf: true, symbol: 'ICU4XCodePointSetBuilder_remove_set')
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_remove_set(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> data,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_retain_char')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_retain_char',
)
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_retain_char(
  ffi.Pointer<ffi.Opaque> self,
  Rune ch,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_retain_inclusive_range')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32, ffi.Uint32)>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_retain_inclusive_range',
)
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_retain_inclusive_range(
  ffi.Pointer<ffi.Opaque> self,
  Rune start,
  Rune end,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_retain_set')
@ffi.Native<
  ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(isLeaf: true, symbol: 'ICU4XCodePointSetBuilder_retain_set')
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_retain_set(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> data,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_complement_char')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_complement_char',
)
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_complement_char(
  ffi.Pointer<ffi.Opaque> self,
  Rune ch,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_complement_inclusive_range')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32, ffi.Uint32)>(
  isLeaf: true,
  symbol: 'ICU4XCodePointSetBuilder_complement_inclusive_range',
)
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_complement_inclusive_range(
  ffi.Pointer<ffi.Opaque> self,
  Rune start,
  Rune end,
);

@_DiplomatFfiUse('ICU4XCodePointSetBuilder_complement_set')
@ffi.Native<
  ffi.Void Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(isLeaf: true, symbol: 'ICU4XCodePointSetBuilder_complement_set')
// ignore: non_constant_identifier_names
external void _ICU4XCodePointSetBuilder_complement_set(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> data,
);
