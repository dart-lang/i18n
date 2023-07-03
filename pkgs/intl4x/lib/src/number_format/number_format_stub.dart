// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale.dart';
import '../options.dart';
import 'number_format_impl.dart';

NumberFormatImpl? getNumberFormatterECMA(
  List<Locale> locales,
  LocaleMatcher localeMatcher,
) =>
    throw UnimplementedError('Cannot use ECMA outside of web environments.');
