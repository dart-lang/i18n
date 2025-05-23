// generated by diplomat-tool

part of 'lib.g.dart';

/// An ICU4X DateTime object capable of containing a date and time for any calendar.
///
/// See the [Rust documentation for `DateTime`](https://docs.rs/icu/latest/icu/calendar/struct.DateTime.html) for more information.
final class DateTime implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  DateTime._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  @_DiplomatFfiUse('ICU4XDateTime_destroy')
  static final _finalizer = ffi.NativeFinalizer(
    ffi.Native.addressOf(_ICU4XDateTime_destroy),
  );

  /// Creates a new [`DateTime`] representing the ISO date and time
  /// given but in a given calendar
  ///
  /// See the [Rust documentation for `new_from_iso`](https://docs.rs/icu/latest/icu/struct.DateTime.html#method.new_from_iso) for more information.
  ///
  /// Throws [Error] on failure.
  factory DateTime.fromIsoInCalendar(
    int year,
    int month,
    int day,
    int hour,
    int minute,
    int second,
    int nanosecond,
    Calendar calendar,
  ) {
    final result = _ICU4XDateTime_create_from_iso_in_calendar(
      year,
      month,
      day,
      hour,
      minute,
      second,
      nanosecond,
      calendar._ffi,
    );
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return DateTime._fromFfi(result.union.ok, []);
  }

  /// Creates a new [`DateTime`] from the given codes, which are interpreted in the given calendar system
  ///
  /// See the [Rust documentation for `try_new_from_codes`](https://docs.rs/icu/latest/icu/calendar/struct.DateTime.html#method.try_new_from_codes) for more information.
  ///
  /// Throws [Error] on failure.
  factory DateTime.fromCodesInCalendar(
    String eraCode,
    int year,
    String monthCode,
    int day,
    int hour,
    int minute,
    int second,
    int nanosecond,
    Calendar calendar,
  ) {
    final temp = ffi2.Arena();
    final eraCodeView = eraCode.utf8View;
    final monthCodeView = monthCode.utf8View;
    final result = _ICU4XDateTime_create_from_codes_in_calendar(
      eraCodeView.allocIn(temp),
      eraCodeView.length,
      year,
      monthCodeView.allocIn(temp),
      monthCodeView.length,
      day,
      hour,
      minute,
      second,
      nanosecond,
      calendar._ffi,
    );
    temp.releaseAll();
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return DateTime._fromFfi(result.union.ok, []);
  }

  /// Creates a new [`DateTime`] from an [`Date`] and [`Time`] object
  ///
  /// See the [Rust documentation for `new`](https://docs.rs/icu/latest/icu/calendar/struct.DateTime.html#method.new) for more information.
  factory DateTime.fromDateAndTime(Date date, Time time) {
    final result = _ICU4XDateTime_create_from_date_and_time(
      date._ffi,
      time._ffi,
    );
    return DateTime._fromFfi(result, []);
  }

  /// Gets a copy of the date contained in this object
  ///
  /// See the [Rust documentation for `date`](https://docs.rs/icu/latest/icu/calendar/struct.DateTime.html#structfield.date) for more information.
  Date get date {
    final result = _ICU4XDateTime_date(_ffi);
    return Date._fromFfi(result, []);
  }

  /// Gets the time contained in this object
  ///
  /// See the [Rust documentation for `time`](https://docs.rs/icu/latest/icu/calendar/struct.DateTime.html#structfield.time) for more information.
  Time get time {
    final result = _ICU4XDateTime_time(_ffi);
    return Time._fromFfi(result, []);
  }

  /// Converts this date to ISO
  ///
  /// See the [Rust documentation for `to_iso`](https://docs.rs/icu/latest/icu/calendar/struct.DateTime.html#method.to_iso) for more information.
  IsoDateTime toIso() {
    final result = _ICU4XDateTime_to_iso(_ffi);
    return IsoDateTime._fromFfi(result, []);
  }

  /// Convert this datetime to one in a different calendar
  ///
  /// See the [Rust documentation for `to_calendar`](https://docs.rs/icu/latest/icu/calendar/struct.DateTime.html#method.to_calendar) for more information.
  DateTime toCalendar(Calendar calendar) {
    final result = _ICU4XDateTime_to_calendar(_ffi, calendar._ffi);
    return DateTime._fromFfi(result, []);
  }

  /// Returns the hour in this time
  ///
  /// See the [Rust documentation for `hour`](https://docs.rs/icu/latest/icu/calendar/struct.Time.html#structfield.hour) for more information.
  int get hour {
    final result = _ICU4XDateTime_hour(_ffi);
    return result;
  }

  /// Returns the minute in this time
  ///
  /// See the [Rust documentation for `minute`](https://docs.rs/icu/latest/icu/calendar/struct.Time.html#structfield.minute) for more information.
  int get minute {
    final result = _ICU4XDateTime_minute(_ffi);
    return result;
  }

  /// Returns the second in this time
  ///
  /// See the [Rust documentation for `second`](https://docs.rs/icu/latest/icu/calendar/struct.Time.html#structfield.second) for more information.
  int get second {
    final result = _ICU4XDateTime_second(_ffi);
    return result;
  }

  /// Returns the nanosecond in this time
  ///
  /// See the [Rust documentation for `nanosecond`](https://docs.rs/icu/latest/icu/calendar/struct.Time.html#structfield.nanosecond) for more information.
  int get nanosecond {
    final result = _ICU4XDateTime_nanosecond(_ffi);
    return result;
  }

  /// Returns the 1-indexed day in the year for this date
  ///
  /// See the [Rust documentation for `day_of_year_info`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.day_of_year_info) for more information.
  int get dayOfYear {
    final result = _ICU4XDateTime_day_of_year(_ffi);
    return result;
  }

  /// Returns the 1-indexed day in the month for this date
  ///
  /// See the [Rust documentation for `day_of_month`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.day_of_month) for more information.
  int get dayOfMonth {
    final result = _ICU4XDateTime_day_of_month(_ffi);
    return result;
  }

  /// Returns the day in the week for this day
  ///
  /// See the [Rust documentation for `day_of_week`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.day_of_week) for more information.
  IsoWeekday get dayOfWeek {
    final result = _ICU4XDateTime_day_of_week(_ffi);
    return IsoWeekday.values.firstWhere((v) => v._ffi == result);
  }

  /// Returns the week number in this month, 1-indexed, based on what
  /// is considered the first day of the week (often a locale preference).
  ///
  /// `first_weekday` can be obtained via `first_weekday()` on [`WeekCalculator`]
  ///
  /// See the [Rust documentation for `week_of_month`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.week_of_month) for more information.
  int weekOfMonth(IsoWeekday firstWeekday) {
    final result = _ICU4XDateTime_week_of_month(_ffi, firstWeekday._ffi);
    return result;
  }

  /// Returns the week number in this year, using week data
  ///
  /// See the [Rust documentation for `week_of_year`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.week_of_year) for more information.
  ///
  /// Throws [Error] on failure.
  WeekOf weekOfYear(WeekCalculator calculator) {
    final result = _ICU4XDateTime_week_of_year(_ffi, calculator._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return WeekOf._fromFfi(result.union.ok);
  }

  /// Returns 1-indexed number of the month of this date in its year
  ///
  /// Note that for lunar calendars this may not lead to the same month
  /// having the same ordinal month across years; use month_code if you care
  /// about month identity.
  ///
  /// See the [Rust documentation for `month`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.month) for more information.
  int get ordinalMonth {
    final result = _ICU4XDateTime_ordinal_month(_ffi);
    return result;
  }

  /// Returns the month code for this date. Typically something
  /// like "M01", "M02", but can be more complicated for lunar calendars.
  ///
  /// See the [Rust documentation for `month`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.month) for more information.
  ///
  /// Throws [Error] on failure.
  String get monthCode {
    final writeable = _Writeable();
    final result = _ICU4XDateTime_month_code(_ffi, writeable._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }

  /// Returns the year number in the current era for this date
  ///
  /// See the [Rust documentation for `year`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.year) for more information.
  int get yearInEra {
    final result = _ICU4XDateTime_year_in_era(_ffi);
    return result;
  }

  /// Returns the era for this date,
  ///
  /// See the [Rust documentation for `year`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.year) for more information.
  ///
  /// Throws [Error] on failure.
  String get era {
    final writeable = _Writeable();
    final result = _ICU4XDateTime_era(_ffi, writeable._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return writeable.finalize();
  }

  /// Returns the number of months in the year represented by this date
  ///
  /// See the [Rust documentation for `months_in_year`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.months_in_year) for more information.
  int get monthsInYear {
    final result = _ICU4XDateTime_months_in_year(_ffi);
    return result;
  }

  /// Returns the number of days in the month represented by this date
  ///
  /// See the [Rust documentation for `days_in_month`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.days_in_month) for more information.
  int get daysInMonth {
    final result = _ICU4XDateTime_days_in_month(_ffi);
    return result;
  }

  /// Returns the number of days in the year represented by this date
  ///
  /// See the [Rust documentation for `days_in_year`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.days_in_year) for more information.
  int get daysInYear {
    final result = _ICU4XDateTime_days_in_year(_ffi);
    return result;
  }

  /// Returns the [`Calendar`] object backing this date
  ///
  /// See the [Rust documentation for `calendar`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.calendar) for more information.
  Calendar get calendar {
    final result = _ICU4XDateTime_calendar(_ffi);
    return Calendar._fromFfi(result, []);
  }
}

@_DiplomatFfiUse('ICU4XDateTime_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_destroy',
)
// ignore: non_constant_identifier_names
external void _ICU4XDateTime_destroy(ffi.Pointer<ffi.Void> self);

@_DiplomatFfiUse('ICU4XDateTime_create_from_iso_in_calendar')
@ffi.Native<
  _ResultOpaqueInt32 Function(
    ffi.Int32,
    ffi.Uint8,
    ffi.Uint8,
    ffi.Uint8,
    ffi.Uint8,
    ffi.Uint8,
    ffi.Uint32,
    ffi.Pointer<ffi.Opaque>,
  )
>(isLeaf: true, symbol: 'ICU4XDateTime_create_from_iso_in_calendar')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XDateTime_create_from_iso_in_calendar(
  int year,
  int month,
  int day,
  int hour,
  int minute,
  int second,
  int nanosecond,
  ffi.Pointer<ffi.Opaque> calendar,
);

@_DiplomatFfiUse('ICU4XDateTime_create_from_codes_in_calendar')
@ffi.Native<
  _ResultOpaqueInt32 Function(
    ffi.Pointer<ffi.Uint8>,
    ffi.Size,
    ffi.Int32,
    ffi.Pointer<ffi.Uint8>,
    ffi.Size,
    ffi.Uint8,
    ffi.Uint8,
    ffi.Uint8,
    ffi.Uint8,
    ffi.Uint32,
    ffi.Pointer<ffi.Opaque>,
  )
>(isLeaf: true, symbol: 'ICU4XDateTime_create_from_codes_in_calendar')
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XDateTime_create_from_codes_in_calendar(
  ffi.Pointer<ffi.Uint8> eraCodeData,
  int eraCodeLength,
  int year,
  ffi.Pointer<ffi.Uint8> monthCodeData,
  int monthCodeLength,
  int day,
  int hour,
  int minute,
  int second,
  int nanosecond,
  ffi.Pointer<ffi.Opaque> calendar,
);

@_DiplomatFfiUse('ICU4XDateTime_create_from_date_and_time')
@ffi.Native<
  ffi.Pointer<ffi.Opaque> Function(
    ffi.Pointer<ffi.Opaque>,
    ffi.Pointer<ffi.Opaque>,
  )
>(isLeaf: true, symbol: 'ICU4XDateTime_create_from_date_and_time')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XDateTime_create_from_date_and_time(
  ffi.Pointer<ffi.Opaque> date,
  ffi.Pointer<ffi.Opaque> time,
);

@_DiplomatFfiUse('ICU4XDateTime_date')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_date',
)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XDateTime_date(
  ffi.Pointer<ffi.Opaque> self,
);

@_DiplomatFfiUse('ICU4XDateTime_time')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_time',
)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XDateTime_time(
  ffi.Pointer<ffi.Opaque> self,
);

@_DiplomatFfiUse('ICU4XDateTime_to_iso')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_to_iso',
)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XDateTime_to_iso(
  ffi.Pointer<ffi.Opaque> self,
);

@_DiplomatFfiUse('ICU4XDateTime_to_calendar')
@ffi.Native<
  ffi.Pointer<ffi.Opaque> Function(
    ffi.Pointer<ffi.Opaque>,
    ffi.Pointer<ffi.Opaque>,
  )
>(isLeaf: true, symbol: 'ICU4XDateTime_to_calendar')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XDateTime_to_calendar(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> calendar,
);

@_DiplomatFfiUse('ICU4XDateTime_hour')
@ffi.Native<ffi.Uint8 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_hour',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_hour(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XDateTime_minute')
@ffi.Native<ffi.Uint8 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_minute',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_minute(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XDateTime_second')
@ffi.Native<ffi.Uint8 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_second',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_second(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XDateTime_nanosecond')
@ffi.Native<ffi.Uint32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_nanosecond',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_nanosecond(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XDateTime_day_of_year')
@ffi.Native<ffi.Uint16 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_day_of_year',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_day_of_year(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XDateTime_day_of_month')
@ffi.Native<ffi.Uint32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_day_of_month',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_day_of_month(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XDateTime_day_of_week')
@ffi.Native<ffi.Int32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_day_of_week',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_day_of_week(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XDateTime_week_of_month')
@ffi.Native<ffi.Uint32 Function(ffi.Pointer<ffi.Opaque>, ffi.Int32)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_week_of_month',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_week_of_month(
  ffi.Pointer<ffi.Opaque> self,
  int firstWeekday,
);

@_DiplomatFfiUse('ICU4XDateTime_week_of_year')
@ffi.Native<
  _ResultWeekOfFfiInt32 Function(
    ffi.Pointer<ffi.Opaque>,
    ffi.Pointer<ffi.Opaque>,
  )
>(isLeaf: true, symbol: 'ICU4XDateTime_week_of_year')
// ignore: non_constant_identifier_names
external _ResultWeekOfFfiInt32 _ICU4XDateTime_week_of_year(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> calculator,
);

@_DiplomatFfiUse('ICU4XDateTime_ordinal_month')
@ffi.Native<ffi.Uint32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_ordinal_month',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_ordinal_month(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XDateTime_month_code')
@ffi.Native<
  _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(isLeaf: true, symbol: 'ICU4XDateTime_month_code')
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XDateTime_month_code(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> writeable,
);

@_DiplomatFfiUse('ICU4XDateTime_year_in_era')
@ffi.Native<ffi.Int32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_year_in_era',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_year_in_era(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XDateTime_era')
@ffi.Native<
  _ResultVoidInt32 Function(ffi.Pointer<ffi.Opaque>, ffi.Pointer<ffi.Opaque>)
>(isLeaf: true, symbol: 'ICU4XDateTime_era')
// ignore: non_constant_identifier_names
external _ResultVoidInt32 _ICU4XDateTime_era(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> writeable,
);

@_DiplomatFfiUse('ICU4XDateTime_months_in_year')
@ffi.Native<ffi.Uint8 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_months_in_year',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_months_in_year(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XDateTime_days_in_month')
@ffi.Native<ffi.Uint8 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_days_in_month',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_days_in_month(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XDateTime_days_in_year')
@ffi.Native<ffi.Uint16 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_days_in_year',
)
// ignore: non_constant_identifier_names
external int _ICU4XDateTime_days_in_year(ffi.Pointer<ffi.Opaque> self);

@_DiplomatFfiUse('ICU4XDateTime_calendar')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XDateTime_calendar',
)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XDateTime_calendar(
  ffi.Pointer<ffi.Opaque> self,
);
