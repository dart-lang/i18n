// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Locale-sensitive date and time formatting.
///
/// Use the [DateTimeFormat] class to format dates and times in a
/// locale-sensitive manner.
///
/// ```dart
/// import 'package:intl4x/datetime_format.dart';
///
/// void main() {
///   final timeZone = 'Europe/Paris';
///   final dateTime = DateTime.parse('2024-07-01T08:50:07');
///
///   final formatter = DateTimeFormat.yearMonthDayTime(
///     locale: Locale.parse('en'),
///     length: DateTimeLength.long,
///   ).withTimeZoneShort();
///   print(
///     formatter.format(dateTime, timeZone),
///   ); // prints 'July 1, 2024 at 8:50:07 AM GMT+2'
/// }
/// ```
library;

import 'src/datetime_format/datetime_format.dart' show DateTimeFormat;

export 'src/datetime_format/datetime_format.dart' show DateTimeFormat;
export 'src/datetime_format/datetime_format_impl.dart'
    show DateTimeFormatter, ZonedDateTimeFormatter;
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
