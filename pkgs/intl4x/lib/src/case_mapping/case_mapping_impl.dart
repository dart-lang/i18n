// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart' show ResourceIdentifier;

import '../../ecma_policy.dart';
import '../data.dart';
import '../ecma/ecma_policy.dart';
import '../locale/locale.dart';
import '../options.dart';
import '../utils.dart';
import 'case_mapping_stub.dart' if (dart.library.js) 'case_mapping_ecma.dart';
import 'case_mapping_stub_4x.dart' if (dart.library.io) 'case_mapping_4x.dart';

abstract class CaseMappingImpl {
  final Locale locale;

  CaseMappingImpl(this.locale);

  String toLowerCase(String input);
  String toUpperCase(String input);

  @ResourceIdentifier('CaseMapping')
  static CaseMappingImpl build(
    Locale locales,
    Data data,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locales,
        data,
        null,
        localeMatcher,
        ecmaPolicy,
        getCaseMappingECMA,
        getCaseMapping4X,
      );
}
