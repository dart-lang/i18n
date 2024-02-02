// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../bindings/lib.g.dart' as icu;
import '../data.dart';
import '../data_4x.dart';
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

DateTimeFormatImpl getDateTimeFormatter4X(
  Locale locale,
  Data data,
  DateTimeFormatOptions options,
) =>
    DateTimeFormat4X(locale, data, options);

class DateTimeFormat4X extends DateTimeFormatImpl {
  final icu.DateTimeFormatter _formatter;
  DateTimeFormat4X(super.locale, Data data, super.options)
      : _formatter = icu.DateTimeFormatter.withLengths(
          data.to4X(),
          locale.to4X(),
          options.dateFormatStyle?.dateTo4xOptions() ??
              icu.DateLength.short, //TODO: Check defaults
          options.timeFormatStyle?.timeTo4xOptions() ??
              icu.TimeLength.short, //TODO: Check defaults
        );

  @override
  String formatImpl(DateTime datetime) =>
      _formatter.formatIsoDatetime(icu.IsoDateTime(
        datetime.year,
        datetime.month,
        datetime.day,
        datetime.hour,
        datetime.minute,
        datetime.second,
        datetime.microsecond * 1000,
      ));
}

//TODO: No other datetimeoptions supported so far.
extension on TimeFormatStyle {
  icu.TimeLength timeTo4xOptions() => switch (this) {
        TimeFormatStyle.full => icu.TimeLength.full,
        TimeFormatStyle.long => icu.TimeLength.long,
        TimeFormatStyle.medium => icu.TimeLength.medium,
        TimeFormatStyle.short => icu.TimeLength.short,
      };
  icu.DateLength dateTo4xOptions() => switch (this) {
        TimeFormatStyle.full => icu.DateLength.full,
        TimeFormatStyle.long => icu.DateLength.long,
        TimeFormatStyle.medium => icu.DateLength.medium,
        TimeFormatStyle.short => icu.DateLength.short,
      };
}
