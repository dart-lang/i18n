// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Locale-sensitive date and time formatting.
///
/// Use the [DateTimeFormat] class to format dates and times in a
/// locale-sensitive manner.
///
/// {@example ../example/docs/datetime_format.dart#datetime_format}
///
/// The formatters are
/// * [DateTimeFormat.day]
/// * [DateTimeFormat.month]
/// * [DateTimeFormat.monthDay]
/// * [DateTimeFormat.monthDayTime]
/// * [DateTimeFormat.year]
/// * [DateTimeFormat.yearMonthDay]
/// * [DateTimeFormat.yearMonthDayTime]
/// * [DateTimeFormat.yearMonthDayWeekday]
/// * [DateTimeFormat.yearMonthDayWeekdayTime]
/// * [DateTimeFormat.time]
///
/// and the zoned variants through
/// * [DateTimeFormat.withTimeZoneShort]
/// * [DateTimeFormat.withTimeZoneLong]
/// * [DateTimeFormat.withTimeZoneShortOffset]
/// * [DateTimeFormat.withTimeZoneLongOffset]
/// * [DateTimeFormat.withTimeZoneShortGeneric]
/// * [DateTimeFormat.withTimeZoneLongGeneric]
library;

import 'src/datetime_format/datetime_format.dart' show DateTimeFormat;

export 'src/datetime_format/datetime_format.dart'
    show
        DateTimeFormat,
        DateTimeFormatUnzoneable,
        DateTimeFormattable,
        TimeZoneable;
export 'src/datetime_format/datetime_format_impl.dart' show ZonedDateTimeFormat;
export 'src/datetime_format/datetime_format_options.dart'
    show
        Calendar,
        ClockStyle,
        DateTimeAlignment,
        DateTimeLength,
        EnumComparisonOperators,
        NumberingSystem,
        TimePrecision,
        TimeZoneType,
        YearStyle;
export 'src/locale/locale.dart' show Locale;
