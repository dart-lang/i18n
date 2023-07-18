// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../test_checker.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

class DatetimeFormat {
  final DatetimeFormatOptions _options;
  final DatetimeFormatImpl impl;

  DatetimeFormat(this._options, this.impl);

  String format(DateTime datetime) {
    if (isInTest) {
      return '$datetime//${impl.locale}';
    } else {
      return impl.formatImpl(datetime, _options);
    }
  }
}
