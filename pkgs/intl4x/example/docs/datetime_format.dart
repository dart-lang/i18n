// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';

void main() {
  {
    // #region datetime_format
    final timeZone = 'Europe/Paris';
    final dateTime = DateTime.parse('2024-07-01T08:50:07');
    final formatter = DateTimeFormat.yearMonthDayTime(
      locale: Locale.parse('en'),
      length: DateTimeLength.long,
    ).withTimeZoneLong();
    print(
      formatter.format(dateTime, timeZone),
    ); // July 1, 2024 at 8:50:07 AM Central European Summer Time
    // #endregion datetime_format
  }
  {
    // #region time_fr
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(
      DateTimeFormat.time(locale: Locale.parse('fr')).format(date),
    ); // 04:00:42
    // #endregion time_fr
  }
  {
    // #region day
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(DateTimeFormat.day(locale: Locale.parse('en')).format(date)); // 17
    // #endregion day
  }
  {
    // #region weekday
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(
      DateTimeFormat.weekday(locale: Locale.parse('en')).format(date),
    ); // Fri
    // #endregion weekday
  }
  {
    // #region month
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(DateTimeFormat.month(locale: Locale.parse('en')).format(date)); // 12
    // #endregion month
  }
  {
    // #region month_day
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(
      DateTimeFormat.monthDay(locale: Locale.parse('en')).format(date),
    ); // 12/17
    // #endregion month_day
  }
  {
    // #region month_day_weekday
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(
      DateTimeFormat.monthDayWeekday(locale: Locale.parse('en')).format(date),
    ); // Fri, 12/17
    // #endregion month_day_weekday
  }
  {
    // #region year
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(DateTimeFormat.year(locale: Locale.parse('en')).format(date)); // 21
    // #endregion year
  }
  {
    // #region year_month
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(
      DateTimeFormat.yearMonth(locale: Locale.parse('en')).format(date),
    ); // 12/21
    // #endregion year_month
  }
  {
    // #region year_month_day
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(
      DateTimeFormat.yearMonthDay(locale: Locale.parse('en')).format(date),
    ); // 12/17/21
    // #endregion year_month_day
  }
  {
    // #region year_month_day_weekday
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(
      DateTimeFormat.yearMonthDayWeekday(
        locale: Locale.parse('en'),
      ).format(date),
    ); // Fri, 12/17/21
    // #endregion year_month_day_weekday
  }
  {
    // #region month_day_time
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(
      DateTimeFormat.monthDayTime(locale: Locale.parse('en')).format(date),
    ); // 12/17, 4:00:42 AM
    // #endregion month_day_time
  }
  {
    // #region year_month_day_time
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(
      DateTimeFormat.yearMonthDayTime(locale: Locale.parse('en')).format(date),
    ); // 12/17/21, 4:00:42 AM
    // #endregion year_month_day_time
  }
  {
    // #region year_month_day_weekday_time
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(
      DateTimeFormat.yearMonthDayWeekdayTime(
        locale: Locale.parse('en'),
      ).format(date),
    ); // Fri, 12/17/21, 4:00:42 AM
    // #endregion year_month_day_weekday_time
  }
  {
    // #region time
    final date = DateTime(2021, 12, 17, 4, 0, 42);
    print(
      DateTimeFormat.time(locale: Locale.parse('en')).format(date),
    ); // 4:00:42 AM
    // #endregion time
  }
}
