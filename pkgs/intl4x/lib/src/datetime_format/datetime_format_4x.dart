// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../intl4x.dart';
import 'datetime_format_options.dart';
import 'datetime_formatter.dart';

DatetimeFormatter getDatetimeFormatter4X(
        Intl intl, DatetimeFormatOptions numberFormatterData) =>
    DatetimeFormat4X(intl, numberFormatterData);

class DatetimeFormat4X extends DatetimeFormatter {
  DatetimeFormat4X(super.intl, super.numberFormatterData);

  @override
  String formatImpl(DateTime datetime) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  List<String> supportedLocalesOf(
    List<String> locales,
    LocaleMatcher localeMatcher,
  ) {
    return intl.availableData.entries
        .where((element) => element.value.contains('NumberFormat'))
        .map((e) => e.key)
        .toList();
  }
}
