// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';

import '../intl4x_test_checker.dart';

abstract class DatetimeFormatter {
  final Intl intl;
  final DatetimeFormatOptions options;

  DatetimeFormatter(this.intl, this.options);

  String format(DateTime datetime) {
    if (isInTest) {
      return '${datetime.toIso8601String()}-${intl.locale}';
    }
    return formatImpl(datetime);
  }

  String formatImpl(DateTime datetime);

  List<String> supportedLocalesOf(List<String> locales);
}
