// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

DatetimeFormatImpl getDatetimeFormatter4X(Locale locale) =>
    DatetimeFormat4X(locale);

class DatetimeFormat4X extends DatetimeFormatImpl {
  DatetimeFormat4X(super.locale);

  @override
  String formatImpl(DateTime datetime, DatetimeFormatOptions options) {
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
