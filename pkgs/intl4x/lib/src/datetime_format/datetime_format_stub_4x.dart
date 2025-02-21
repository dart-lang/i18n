// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../data.dart';
import '../locale/locale.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

DateTimeFormatImpl getDateTimeFormatter4X(
  Locale locale,
  Data data,
  DateTimeFormatOptions options,
) =>
    throw UnimplementedError('Cannot use ICU4X in web environments.');
