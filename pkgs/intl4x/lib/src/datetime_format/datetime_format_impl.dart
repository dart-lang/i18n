// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale/locale.dart';
import '../test_checker.dart' show isInTest;
import '../utils.dart';
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

abstract class FormatterImpl extends _AbstractDateTimeFormatter
    implements DateTimeFormatter {
  final DateTimeFormatImpl _impl;

  FormatterImpl(this._impl);

  String formatInternal(DateTime datetime);

  @override
  String format(DateTime datetime) {
    if (isInTest) {
      return '$datetime//${_impl.locale}';
    } else {
      return formatInternal(datetime);
    }
  }
}

abstract class FormatterZonedImpl implements ZonedDateTimeFormatter {
  final DateTimeFormatImpl _impl;
  final TimeZoneType timeZoneType;

  String formatInternal(DateTime datetime, TimeZone timeZone);

  FormatterZonedImpl(this._impl, this.timeZoneType);

  @override
  String format(DateTime datetime, TimeZone timeZone) {
    if (isInTest) {
      return '$datetime//${_impl.locale}';
    } else {
      return formatInternal(datetime, timeZone);
    }
  }
}

sealed class DateTimeFormatter extends _AbstractDateTimeFormatter
    with _ZoneableFormatter {}

sealed class ZonedDateTimeFormatter extends _AbstractZonedDateTimeFormatter {}

/// A base class for formatters that can format a [DateTime] into a string.
sealed class _AbstractDateTimeFormatter {
  String format(DateTime datetime);
}

/// A base class for formatters that can format a [DateTime] and [TimeZone] into
/// a string.
sealed class _AbstractZonedDateTimeFormatter {
  String format(DateTime datetime, TimeZone timeZone);
}

/// A [_AbstractDateTimeFormatter] which can also handle time zones.
mixin _ZoneableFormatter {
  ZonedDateTimeFormatter withTimeZoneShort();
  ZonedDateTimeFormatter withTimeZoneLong();
  ZonedDateTimeFormatter withTimeZoneShortOffset();
  ZonedDateTimeFormatter withTimeZoneLongOffset();
  ZonedDateTimeFormatter withTimeZoneShortGeneric();
  ZonedDateTimeFormatter withTimeZoneLongGeneric();
}
