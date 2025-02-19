// generated by diplomat-tool

part of 'lib.g.dart';

/// See the [Rust documentation for `CaseMapCloser`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapCloser.html) for more information.
final class CaseMapCloser implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  CaseMapCloser._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer = ffi.NativeFinalizer(
    ffi.Native.addressOf(_ICU4XCaseMapCloser_destroy),
  );

  /// Construct a new ICU4XCaseMapper instance
  ///
  /// See the [Rust documentation for `new`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapCloser.html#method.new) for more information.
  ///
  /// Throws [Error] on failure.
  factory CaseMapCloser(DataProvider provider) {
    final result = _ICU4XCaseMapCloser_create(provider._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return CaseMapCloser._fromFfi(result.union.ok, []);
  }

  /// Adds all simple case mappings and the full case folding for `c` to `builder`.
  /// Also adds special case closure mappings.
  ///
  /// See the [Rust documentation for `add_case_closure_to`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapCloser.html#method.add_case_closure_to) for more information.
  void addCaseClosureTo(Rune c, CodePointSetBuilder builder) {
    _ICU4XCaseMapCloser_add_case_closure_to(_ffi, c, builder._ffi);
  }

  /// Finds all characters and strings which may casemap to `s` as their full case folding string
  /// and adds them to the set.
  ///
  /// Returns true if the string was found
  ///
  /// See the [Rust documentation for `add_string_case_closure_to`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapCloser.html#method.add_string_case_closure_to) for more information.
  bool addStringCaseClosureTo(String s, CodePointSetBuilder builder) {
    final temp = ffi2.Arena();
    final sView = s.utf8View;
    final result = _ICU4XCaseMapCloser_add_string_case_closure_to(
      _ffi,
      sView.allocIn(temp),
      sView.length,
      builder._ffi,
    );
    temp.releaseAll();
    return result;
  }
}

@RecordSymbol('ICU4XCaseMapCloser_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
  isLeaf: true,
  symbol: 'ICU4XCaseMapCloser_destroy',
)
// ignore: non_constant_identifier_names
external void _ICU4XCaseMapCloser_destroy(ffi.Pointer<ffi.Void> self);

@RecordSymbol('ICU4XCaseMapCloser_create')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XCaseMapCloser_create',
)
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XCaseMapCloser_create(
  ffi.Pointer<ffi.Opaque> provider,
);

@RecordSymbol('ICU4XCaseMapCloser_add_case_closure_to')
@ffi.Native<
  ffi.Void Function(
    ffi.Pointer<ffi.Opaque>,
    ffi.Uint32,
    ffi.Pointer<ffi.Opaque>,
  )
>(isLeaf: true, symbol: 'ICU4XCaseMapCloser_add_case_closure_to')
// ignore: non_constant_identifier_names
external void _ICU4XCaseMapCloser_add_case_closure_to(
  ffi.Pointer<ffi.Opaque> self,
  Rune c,
  ffi.Pointer<ffi.Opaque> builder,
);

@RecordSymbol('ICU4XCaseMapCloser_add_string_case_closure_to')
@ffi.Native<
  ffi.Bool Function(
    ffi.Pointer<ffi.Opaque>,
    ffi.Pointer<ffi.Uint8>,
    ffi.Size,
    ffi.Pointer<ffi.Opaque>,
  )
>(isLeaf: true, symbol: 'ICU4XCaseMapCloser_add_string_case_closure_to')
// ignore: non_constant_identifier_names
external bool _ICU4XCaseMapCloser_add_string_case_closure_to(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Uint8> sData,
  int sLength,
  ffi.Pointer<ffi.Opaque> builder,
);
