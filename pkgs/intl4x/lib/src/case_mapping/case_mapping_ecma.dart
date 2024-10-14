// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../locale/locale.dart';
import '../options.dart';
import 'case_mapping_impl.dart';

CaseMappingImpl? getCaseMappingECMA(
  Locale locale,
  Null __,
  LocaleMatcher _,
) =>
    _CaseMappingECMA.tryToBuild(locale);

extension on JSString {
  @JS('String.toLocaleUpperCase')
  external String toLocaleUpperCase(String locale);
  @JS('String.toLocaleLowerCase')
  external String toLocaleLowerCase(String locale);
}

class _CaseMappingECMA extends CaseMappingImpl {
  _CaseMappingECMA(super.locale);

  static CaseMappingImpl? tryToBuild(
    Locale locale,
  ) =>
      _CaseMappingECMA(locale);
  @override
  String toUpperCase(String input) =>
      input.toJS.toLocaleUpperCase(locale.toLanguageTag());

  @override
  String toLowerCase(String input) =>
      input.toJS.toLocaleLowerCase(locale.toLanguageTag());
}
