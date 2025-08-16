// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale/locale.dart';
import '../test_checker.dart' show isInTest;
import '../utils.dart';
import 'datetime_format.dart';
import 'datetime_format_options.dart';
import 'datetime_format_stub.dart'
    if (dart.library.js) 'datetime_format_ecma.dart';
import 'datetime_format_stub_4x.dart'
    if (dart.library.io) 'datetime_format_4x.dart';

/// This is an intermediate to defer to the actual implementations of
/// datetime formatting.
abstract class DateTimeFormatImpl {
  final Locale locale;
  final DateTimeFormatOptions options;

  DateTimeFormatImpl(this.locale, this.options);

  static DateTimeFormatImpl build(
    Locale locale,
    DateTimeFormatOptions options,
  ) => buildFormatter(
    locale,
    options,

    getDateTimeFormatterECMA,
    getDateTimeFormatter4X,
  );

  DateFormatterImpl d();
  DateFormatterImpl m();
  DateFormatterImpl y();
  DateFormatterImpl md();
  DateFormatterImpl ymd();
  DateFormatterImpl ymde();

  String ymdt(DateTime datetime, {TimeZone? timeZone});
  String ymdet(DateTime datetime);
  String time(DateTime datetime, {TimeZone? timeZone});
}

abstract class FormatterImpl {
  String formatInternal(DateTime datetime);
}

abstract class DateFormatterImpl implements DateFormatter, FormatterImpl {
  final DateTimeFormatImpl _impl;

  DateFormatterImpl(this._impl);

  @override
  String format(DateTime datetime) => _format(formatInternal, datetime, _impl);
}

abstract class DateFormatterZonedImpl
    implements DateFormatterZoned, FormatterImpl {
  final DateTimeFormatImpl _impl;

  DateFormatterZonedImpl(this._impl);

  @override
  String format(DateTime datetime) => _format(formatInternal, datetime, _impl);
}

String _format(
  String Function(DateTime datetime) format,
  DateTime datetime,
  DateTimeFormatImpl impl,
) {
  if (isInTest) {
    return '$datetime//${impl.locale}';
  } else {
    return format(datetime);
  }
}
