// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'src/case_mapping/case_mapping.dart';
import 'src/locale/locale.dart' show Locale;

export 'src/case_mapping/case_mapping.dart' show CaseMapping;
export 'src/locale/locale.dart' show Locale;

extension CaseMappingWithIntl4X on String {
  String toLocaleLowerCase(Locale locale) =>
      CaseMapping(locale: locale).toLowerCase(this);
  String toLocaleUpperCase(Locale locale) =>
      CaseMapping(locale: locale).toUpperCase(this);
}
