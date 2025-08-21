// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale/locale.dart';
import '../test_checker.dart' show isInTest;
import '../utils.dart';
import 'datetime_format.dart';
import 'datetime_format_options.dart';
import 'datetime_format_stub.dart'
    if (dart.library.js_interop) 'datetime_format_ecma.dart';
import 'datetime_format_stub_4x.dart'
    if (dart.library.ffi) 'icu4x/datetime_format_4x.dart';

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

  FormatterImpl d({DateFormatStyle? dateStyle});
  FormatterImpl m({DateFormatStyle? dateStyle});
  FormatterImpl y({DateFormatStyle? dateStyle});
  FormatterImpl md({DateFormatStyle? dateStyle});
  FormatterImpl ymd({DateFormatStyle? dateStyle});
  FormatterImpl ymde({DateFormatStyle? dateStyle});
  FormatterImpl mdt({DateFormatStyle? dateStyle, TimeFormatStyle? timeStyle});
  FormatterImpl ymdt({DateFormatStyle? dateStyle, TimeFormatStyle? timeStyle});
  FormatterImpl ymdet({DateFormatStyle? dateStyle, TimeFormatStyle? timeStyle});
  FormatterImpl t({TimeFormatStyle? style});
}

abstract class InternalFormatterImpl {
  String formatInternal(DateTime datetime);
}

abstract class FormatterZonedImpl
    implements ZonedFormatter, InternalFormatterImpl {
  final DateTimeFormatImpl _impl;
  final TimeZone timeZone;
  final TimeZoneType timeZoneType;

  FormatterZonedImpl(this._impl, this.timeZone, this.timeZoneType);

  @override
  String format(DateTime datetime) => _format(formatInternal, datetime, _impl);
}

abstract class FormatterImpl
    implements
        DateTimeFormatter,
        TimeFormatter,
        DateFormatter,
        InternalFormatterImpl {
  final DateTimeFormatImpl _impl;

  FormatterImpl(this._impl);

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
