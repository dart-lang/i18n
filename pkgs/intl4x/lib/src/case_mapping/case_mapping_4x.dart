// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../bindings/lib.g.dart' as icu;
import '../data.dart';
import '../data_4x.dart';
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'case_mapping_impl.dart';

CaseMappingImpl getCaseMapping4X(
  Locale locale,
  Data data,
  Null _,
) =>
    CaseMapping4X(locale, data);

class CaseMapping4X extends CaseMappingImpl {
  final icu.CaseMapper _caseMapper;

  CaseMapping4X(super.locale, Data data)
      : _caseMapper = icu.CaseMapper(data.to4X());

  @override
  String toLowerCase(String input) =>
      _caseMapper.lowercase(input, locale.to4X());

  @override
  String toUpperCase(String input) =>
      _caseMapper.uppercase(input, locale.to4X());
}
