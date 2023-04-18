// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/intl.dart';

import '../../intl_test.dart';
import 'datetime_format_options.dart';

abstract class DatetimeFormatter {
  final Intl intl;
  final DatetimeFormatOptions datetimeFormatterData;

  DatetimeFormatter(this.intl, this.datetimeFormatterData);

  String format(DateTime datetime) {
    if (isInTest()) {
      return '${datetime.toIso8601String()}-${intl.locale}';
    }
    return formatImpl(datetime);
  }

  String formatImpl(DateTime datetime);

  List<String> supportedLocalesOf(
    List<String> locales,
    LocaleMatcher localeMatcher,
  );
}

enum LocaleMatcher {
  lookup('lookup'),
  bestfit('best fit');

  final String jsName;
  const LocaleMatcher(this.jsName);
}
