// generated by diplomat-tool

part of 'lib.g.dart';

/// See the [Rust documentation for `CaseMapper`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html) for more information.
final class CaseMapper implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  CaseMapper._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer =
      ffi.NativeFinalizer(ffi.Native.addressOf(_ICU4XCaseMapper_destroy));

  /// Construct a new ICU4XCaseMapper instance
  ///
  /// See the [Rust documentation for `new`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html#method.new) for more information.
  ///
  /// Throws [Error] on failure.
  factory CaseMapper(DataProvider provider) {
    final result = _ICU4XCaseMapper_create(provider._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return CaseMapper._fromFfi(result.union.ok, []);
  }

  /// Returns the full lowercase mapping of the given string
  ///
  /// See the [Rust documentation for `lowercase`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html#method.lowercase) for more information.
  ///
  /// Throws [Error] on failure.
  String lowercase(String s, Locale locale) {
    final temp = ffi2.Arena();
    final sView = s.utf8View;
    final writeable = _Writeable();
    final result = _ICU4XCaseMapper_lowercase(
        _ffi, sView.allocIn(temp), sView.length, locale._ffi, writeable._ffi);
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }

  /// Returns the full uppercase mapping of the given string
  ///
  /// See the [Rust documentation for `uppercase`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html#method.uppercase) for more information.
  ///
  /// Throws [Error] on failure.
  String uppercase(String s, Locale locale) {
    final temp = ffi2.Arena();
    final sView = s.utf8View;
    final writeable = _Writeable();
    final result = _ICU4XCaseMapper_uppercase(
        _ffi, sView.allocIn(temp), sView.length, locale._ffi, writeable._ffi);
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }

  /// Returns the full titlecase mapping of the given string, performing head adjustment without
  /// loading additional data.
  /// (if head adjustment is enabled in the options)
  ///
  /// The `v1` refers to the version of the options struct, which may change as we add more options
  ///
  /// See the [Rust documentation for `titlecase_segment_with_only_case_data`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html#method.titlecase_segment_with_only_case_data) for more information.
  ///
  /// Throws [Error] on failure.
  String titlecaseSegmentWithOnlyCaseData(
      String s, Locale locale, TitlecaseOptions options) {
    final temp = ffi2.Arena();
    final sView = s.utf8View;
    final writeable = _Writeable();
    final result = _ICU4XCaseMapper_titlecase_segment_with_only_case_data_v1(
        _ffi,
        sView.allocIn(temp),
        sView.length,
        locale._ffi,
        options._toFfi(temp),
        writeable._ffi);
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }

  /// Case-folds the characters in the given string
  ///
  /// See the [Rust documentation for `fold`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html#method.fold) for more information.
  ///
  /// Throws [Error] on failure.
  String fold(String s) {
    final temp = ffi2.Arena();
    final sView = s.utf8View;
    final writeable = _Writeable();
    final result = _ICU4XCaseMapper_fold(
        _ffi, sView.allocIn(temp), sView.length, writeable._ffi);
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }

  /// Case-folds the characters in the given string
  /// using Turkic (T) mappings for dotted/dotless I.
  ///
  /// See the [Rust documentation for `fold_turkic`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html#method.fold_turkic) for more information.
  ///
  /// Throws [Error] on failure.
  String foldTurkic(String s) {
    final temp = ffi2.Arena();
    final sView = s.utf8View;
    final writeable = _Writeable();
    final result = _ICU4XCaseMapper_fold_turkic(
        _ffi, sView.allocIn(temp), sView.length, writeable._ffi);
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }

  /// Adds all simple case mappings and the full case folding for `c` to `builder`.
  /// Also adds special case closure mappings.
  ///
  /// In other words, this adds all characters that this casemaps to, as
  /// well as all characters that may casemap to this one.
  ///
  /// Note that since ICU4XCodePointSetBuilder does not contain strings, this will
  /// ignore string mappings.
  ///
  /// Identical to the similarly named method on `CaseMapCloser`, use that if you
  /// plan on using string case closure mappings too.
  ///
  /// See the [Rust documentation for `add_case_closure_to`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html#method.add_case_closure_to) for more information.
  void addCaseClosureTo(Rune c, CodePointSetBuilder builder) {
    _ICU4XCaseMapper_add_case_closure_to(_ffi, c, builder._ffi);
  }

  /// Returns the simple lowercase mapping of the given character.
  ///
  /// This function only implements simple and common mappings.
  /// Full mappings, which can map one char to a string, are not included.
  /// For full mappings, use `CaseMapper::lowercase`.
  ///
  /// See the [Rust documentation for `simple_lowercase`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html#method.simple_lowercase) for more information.
  Rune simpleLowercase(Rune ch) {
    final result = _ICU4XCaseMapper_simple_lowercase(_ffi, ch);
    return result;
  }

  /// Returns the simple uppercase mapping of the given character.
  ///
  /// This function only implements simple and common mappings.
  /// Full mappings, which can map one char to a string, are not included.
  /// For full mappings, use `CaseMapper::uppercase`.
  ///
  /// See the [Rust documentation for `simple_uppercase`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html#method.simple_uppercase) for more information.
  Rune simpleUppercase(Rune ch) {
    final result = _ICU4XCaseMapper_simple_uppercase(_ffi, ch);
    return result;
  }

  /// Returns the simple titlecase mapping of the given character.
  ///
  /// This function only implements simple and common mappings.
  /// Full mappings, which can map one char to a string, are not included.
  /// For full mappings, use `CaseMapper::titlecase_segment`.
  ///
  /// See the [Rust documentation for `simple_titlecase`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html#method.simple_titlecase) for more information.
  Rune simpleTitlecase(Rune ch) {
    final result = _ICU4XCaseMapper_simple_titlecase(_ffi, ch);
    return result;
  }

  /// Returns the simple casefolding of the given character.
  ///
  /// This function only implements simple folding.
  /// For full folding, use `CaseMapper::fold`.
  ///
  /// See the [Rust documentation for `simple_fold`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html#method.simple_fold) for more information.
  Rune simpleFold(Rune ch) {
    final result = _ICU4XCaseMapper_simple_fold(_ffi, ch);
    return result;
  }

  /// Returns the simple casefolding of the given character in the Turkic locale
  ///
  /// This function only implements simple folding.
  /// For full folding, use `CaseMapper::fold_turkic`.
  ///
  /// See the [Rust documentation for `simple_fold_turkic`](https://docs.rs/icu/latest/icu/casemap/struct.CaseMapper.html#method.simple_fold_turkic) for more information.
  Rune simpleFoldTurkic(Rune ch) {
    final result = _ICU4XCaseMapper_simple_fold_turkic(_ffi, ch);
    return result;
  }
}

@KeepSymbol('ICU4XCaseMapper_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
    isLeaf: true, symbol: 'ICU4XCaseMapper_destroy')
// ignore: non_constant_identifier_names
external void _ICU4XCaseMapper_destroy(ffi.Pointer<ffi.Void> self);

@KeepSymbol('ICU4XCaseMapper_create')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XCaseMapper_create')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XCaseMapper_create(
    ffi.Pointer<ffi.Opaque> provider);

@KeepSymbol('ICU4XCaseMapper_lowercase')
@ffi.Native<
        _ResultVoidInt32 Function(
            ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Uint8>,
            ffi.Size,
            ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XCaseMapper_lowercase')
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XCaseMapper_lowercase(
    ffi.Pointer<ffi.Opaque> self,
    ffi.Pointer<ffi.Uint8> sData,
    int sLength,
    ffi.Pointer<ffi.Opaque> locale,
    ffi.Pointer<ffi.Opaque> writeable);

@KeepSymbol('ICU4XCaseMapper_uppercase')
@ffi.Native<
        _ResultVoidInt32 Function(
            ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Uint8>,
            ffi.Size,
            ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XCaseMapper_uppercase')
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XCaseMapper_uppercase(
    ffi.Pointer<ffi.Opaque> self,
    ffi.Pointer<ffi.Uint8> sData,
    int sLength,
    ffi.Pointer<ffi.Opaque> locale,
    ffi.Pointer<ffi.Opaque> writeable);

@KeepSymbol('ICU4XCaseMapper_titlecase_segment_with_only_case_data_v1')
@ffi.Native<
        _ResultVoidInt32 Function(
            ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Uint8>,
            ffi.Size,
            ffi.Pointer<ffi.Opaque>,
            _TitlecaseOptionsFfi,
            ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true,
    symbol: 'ICU4XCaseMapper_titlecase_segment_with_only_case_data_v1')
// ignore: non_constant_identifier_names
external _ResultVoidInt32
    _ICU4XCaseMapper_titlecase_segment_with_only_case_data_v1(
        ffi.Pointer<ffi.Opaque> self,
        ffi.Pointer<ffi.Uint8> sData,
        int sLength,
        ffi.Pointer<ffi.Opaque> locale,
        _TitlecaseOptionsFfi options,
        ffi.Pointer<ffi.Opaque> writeable);

@KeepSymbol('ICU4XCaseMapper_fold')
@ffi.Native<
    _ResultVoidInt32 Function(
        ffi.Pointer<ffi.Opaque>,
        ffi.Pointer<ffi.Uint8>,
        ffi.Size,
        ffi.Pointer<ffi.Opaque>)>(isLeaf: true, symbol: 'ICU4XCaseMapper_fold')
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XCaseMapper_fold(
    ffi.Pointer<ffi.Opaque> self,
    ffi.Pointer<ffi.Uint8> sData,
    int sLength,
    ffi.Pointer<ffi.Opaque> writeable);

@KeepSymbol('ICU4XCaseMapper_fold_turkic')
@ffi.Native<
        _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>,
            ffi.Pointer<ffi.Uint8>, ffi.Size, ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XCaseMapper_fold_turkic')
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XCaseMapper_fold_turkic(
    ffi.Pointer<ffi.Opaque> self,
    ffi.Pointer<ffi.Uint8> sData,
    int sLength,
    ffi.Pointer<ffi.Opaque> writeable);

@KeepSymbol('ICU4XCaseMapper_add_case_closure_to')
@ffi.Native<
        ffi.Void Function(
            ffi.Pointer<ffi.Opaque>, ffi.Uint32, ffi.Pointer<ffi.Opaque>)>(
    isLeaf: true, symbol: 'ICU4XCaseMapper_add_case_closure_to')
// ignore: non_constant_identifier_names
external void _ICU4XCaseMapper_add_case_closure_to(
    ffi.Pointer<ffi.Opaque> self, Rune c, ffi.Pointer<ffi.Opaque> builder);

@KeepSymbol('ICU4XCaseMapper_simple_lowercase')
@ffi.Native<ffi.Uint32 Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
    isLeaf: true, symbol: 'ICU4XCaseMapper_simple_lowercase')
// ignore: non_constant_identifier_names
external Rune _ICU4XCaseMapper_simple_lowercase(
    ffi.Pointer<ffi.Opaque> self, Rune ch);

@KeepSymbol('ICU4XCaseMapper_simple_uppercase')
@ffi.Native<ffi.Uint32 Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
    isLeaf: true, symbol: 'ICU4XCaseMapper_simple_uppercase')
// ignore: non_constant_identifier_names
external Rune _ICU4XCaseMapper_simple_uppercase(
    ffi.Pointer<ffi.Opaque> self, Rune ch);

@KeepSymbol('ICU4XCaseMapper_simple_titlecase')
@ffi.Native<ffi.Uint32 Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
    isLeaf: true, symbol: 'ICU4XCaseMapper_simple_titlecase')
// ignore: non_constant_identifier_names
external Rune _ICU4XCaseMapper_simple_titlecase(
    ffi.Pointer<ffi.Opaque> self, Rune ch);

@KeepSymbol('ICU4XCaseMapper_simple_fold')
@ffi.Native<ffi.Uint32 Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
    isLeaf: true, symbol: 'ICU4XCaseMapper_simple_fold')
// ignore: non_constant_identifier_names
external Rune _ICU4XCaseMapper_simple_fold(
    ffi.Pointer<ffi.Opaque> self, Rune ch);

@KeepSymbol('ICU4XCaseMapper_simple_fold_turkic')
@ffi.Native<ffi.Uint32 Function(ffi.Pointer<ffi.Opaque>, ffi.Uint32)>(
    isLeaf: true, symbol: 'ICU4XCaseMapper_simple_fold_turkic')
// ignore: non_constant_identifier_names
external Rune _ICU4XCaseMapper_simple_fold_turkic(
    ffi.Pointer<ffi.Opaque> self, Rune ch);
