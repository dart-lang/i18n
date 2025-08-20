// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale/locale.dart';
import '../options.dart';
import '../utils.dart';
import 'case_mapping_stub.dart'
    if (dart.library.js_interop) 'case_mapping_ecma.dart';
import 'case_mapping_stub_4x.dart' if (dart.library.io) 'case_mapping_4x.dart';

abstract class CaseMappingImpl {
  final Locale locale;

  CaseMappingImpl(this.locale);

  String toLowerCase(String input);
  String toUpperCase(String input);

  static CaseMappingImpl build(Locale locales, LocaleMatcher localeMatcher) =>
      buildFormatter(
        locales,
        null,
        localeMatcher,
        getCaseMappingECMA,
        getCaseMapping4X,
      );
}
