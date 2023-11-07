// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../list_format.dart';
import '../locale/locale.dart';
import 'number_format_impl.dart';
import 'number_format_options.dart';

NumberFormatImpl? getNumberFormatterECMA(
  Locale locale,
  NumberFormatOptions options,
  LocaleMatcher localeMatcher,
) =>
    throw UnimplementedError('Cannot use ECMA outside of web environments.');
