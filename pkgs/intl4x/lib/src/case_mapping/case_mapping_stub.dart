// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale/locale.dart';
import '../options.dart';
import 'case_mapping_impl.dart';

CaseMappingImpl? getCaseMappingECMA(
  Locale locale,
  Null _,
  LocaleMatcher __,
) =>
    throw UnimplementedError('Cannot use ECMA outside of web environments.');
