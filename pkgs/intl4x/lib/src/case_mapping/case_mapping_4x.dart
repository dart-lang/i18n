// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'case_mapping_impl.dart';

CaseMappingImpl getCaseMapping4X(Locale locale, Null _) =>
    CaseMapping4X(locale as Locale4x);

class CaseMapping4X extends CaseMappingImpl {
  final icu.CaseMapper _caseMapper;
  final Locale4x _locale;

  CaseMapping4X(this._locale) : _caseMapper = icu.CaseMapper(), super(_locale);

  @override
  String toLowerCase(String input) =>
      _caseMapper.lowercase(input, _locale.get4X);

  @override
  String toUpperCase(String input) =>
      _caseMapper.uppercase(input, _locale.get4X);
}
