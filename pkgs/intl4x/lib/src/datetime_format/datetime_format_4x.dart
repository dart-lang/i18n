// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

DateTimeFormatImpl getDateTimeFormatter4X(Locale locale) =>
    DateTimeFormat4X(locale);

class DateTimeFormat4X extends DateTimeFormatImpl {
  DateTimeFormat4X(super.locale);

  @override
  String formatImpl(DateTime datetime, DateTimeFormatOptions options) {
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
