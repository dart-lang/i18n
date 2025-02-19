// generated by diplomat-tool

part of 'lib.g.dart';

/// An ICU4X Date object capable of containing a ISO-8601 date
///
/// See the [Rust documentation for `Date`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html) for more information.
final class IsoDate implements ffi.Finalizable {
  final ffi.Pointer<ffi.Opaque> _ffi;

  // These are "used" in the sense that they keep dependencies alive
  // ignore: unused_field
  final core.List<Object> _selfEdge;

  // This takes in a list of lifetime edges (including for &self borrows)
  // corresponding to data this may borrow from. These should be flat arrays containing
  // references to objects, and this object will hold on to them to keep them alive and
  // maintain borrow validity.
  IsoDate._fromFfi(this._ffi, this._selfEdge) {
    if (_selfEdge.isEmpty) {
      _finalizer.attach(this, _ffi.cast());
    }
  }

  static final _finalizer = ffi.NativeFinalizer(
    ffi.Native.addressOf(_ICU4XIsoDate_destroy),
  );

  /// Creates a new [`IsoDate`] from the specified date and time.
  ///
  /// See the [Rust documentation for `try_new_iso_date`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.try_new_iso_date) for more information.
  ///
  /// Throws [Error] on failure.
  factory IsoDate(int year, int month, int day) {
    final result = _ICU4XIsoDate_create(year, month, day);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return IsoDate._fromFfi(result.union.ok, []);
  }

  /// Creates a new [`IsoDate`] representing January 1, 1970.
  ///
  /// See the [Rust documentation for `unix_epoch`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.unix_epoch) for more information.
  factory IsoDate.forUnixEpoch() {
    final result = _ICU4XIsoDate_create_for_unix_epoch();
    return IsoDate._fromFfi(result, []);
  }

  /// Convert this date to one in a different calendar
  ///
  /// See the [Rust documentation for `to_calendar`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.to_calendar) for more information.
  Date toCalendar(Calendar calendar) {
    final result = _ICU4XIsoDate_to_calendar(_ffi, calendar._ffi);
    return Date._fromFfi(result, []);
  }

  /// See the [Rust documentation for `to_any`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.to_any) for more information.
  Date toAny() {
    final result = _ICU4XIsoDate_to_any(_ffi);
    return Date._fromFfi(result, []);
  }

  /// Returns the 1-indexed day in the year for this date
  ///
  /// See the [Rust documentation for `day_of_year_info`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.day_of_year_info) for more information.
  int get dayOfYear {
    final result = _ICU4XIsoDate_day_of_year(_ffi);
    return result;
  }

  /// Returns the 1-indexed day in the month for this date
  ///
  /// See the [Rust documentation for `day_of_month`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.day_of_month) for more information.
  int get dayOfMonth {
    final result = _ICU4XIsoDate_day_of_month(_ffi);
    return result;
  }

  /// Returns the day in the week for this day
  ///
  /// See the [Rust documentation for `day_of_week`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.day_of_week) for more information.
  IsoWeekday get dayOfWeek {
    final result = _ICU4XIsoDate_day_of_week(_ffi);
    return IsoWeekday.values.firstWhere((v) => v._ffi == result);
  }

  /// Returns the week number in this month, 1-indexed, based on what
  /// is considered the first day of the week (often a locale preference).
  ///
  /// `first_weekday` can be obtained via `first_weekday()` on [`WeekCalculator`]
  ///
  /// See the [Rust documentation for `week_of_month`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.week_of_month) for more information.
  int weekOfMonth(IsoWeekday firstWeekday) {
    final result = _ICU4XIsoDate_week_of_month(_ffi, firstWeekday._ffi);
    return result;
  }

  /// Returns the week number in this year, using week data
  ///
  /// See the [Rust documentation for `week_of_year`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.week_of_year) for more information.
  ///
  /// Throws [Error] on failure.
  WeekOf weekOfYear(WeekCalculator calculator) {
    final result = _ICU4XIsoDate_week_of_year(_ffi, calculator._ffi);
    if (!result.isOk) {
      throw Error.values.firstWhere((v) => v._ffi == result.union.err);
    }
    return WeekOf._fromFfi(result.union.ok);
  }

  /// Returns 1-indexed number of the month of this date in its year
  ///
  /// See the [Rust documentation for `month`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.month) for more information.
  int get month {
    final result = _ICU4XIsoDate_month(_ffi);
    return result;
  }

  /// Returns the year number for this date
  ///
  /// See the [Rust documentation for `year`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.year) for more information.
  int get year {
    final result = _ICU4XIsoDate_year(_ffi);
    return result;
  }

  /// Returns if the year is a leap year for this date
  ///
  /// See the [Rust documentation for `is_in_leap_year`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.is_in_leap_year) for more information.
  bool get isInLeapYear {
    final result = _ICU4XIsoDate_is_in_leap_year(_ffi);
    return result;
  }

  /// Returns the number of months in the year represented by this date
  ///
  /// See the [Rust documentation for `months_in_year`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.months_in_year) for more information.
  int get monthsInYear {
    final result = _ICU4XIsoDate_months_in_year(_ffi);
    return result;
  }

  /// Returns the number of days in the month represented by this date
  ///
  /// See the [Rust documentation for `days_in_month`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.days_in_month) for more information.
  int get daysInMonth {
    final result = _ICU4XIsoDate_days_in_month(_ffi);
    return result;
  }

  /// Returns the number of days in the year represented by this date
  ///
  /// See the [Rust documentation for `days_in_year`](https://docs.rs/icu/latest/icu/calendar/struct.Date.html#method.days_in_year) for more information.
  int get daysInYear {
    final result = _ICU4XIsoDate_days_in_year(_ffi);
    return result;
  }
}

@RecordSymbol('ICU4XIsoDate_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_destroy',
)
// ignore: non_constant_identifier_names
external void _ICU4XIsoDate_destroy(ffi.Pointer<ffi.Void> self);

@RecordSymbol('ICU4XIsoDate_create')
@ffi.Native<_ResultOpaqueInt32 Function(ffi.Int32, ffi.Uint8, ffi.Uint8)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_create',
)
// ignore: non_constant_identifier_names
external _ResultOpaqueInt32 _ICU4XIsoDate_create(int year, int month, int day);

@RecordSymbol('ICU4XIsoDate_create_for_unix_epoch')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function()>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_create_for_unix_epoch',
)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XIsoDate_create_for_unix_epoch();

@RecordSymbol('ICU4XIsoDate_to_calendar')
@ffi.Native<
  ffi.Pointer<ffi.Opaque> Function(
    ffi.Pointer<ffi.Opaque>,
    ffi.Pointer<ffi.Opaque>,
  )
>(isLeaf: true, symbol: 'ICU4XIsoDate_to_calendar')
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XIsoDate_to_calendar(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> calendar,
);

@RecordSymbol('ICU4XIsoDate_to_any')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_to_any',
)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _ICU4XIsoDate_to_any(
  ffi.Pointer<ffi.Opaque> self,
);

@RecordSymbol('ICU4XIsoDate_day_of_year')
@ffi.Native<ffi.Uint16 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_day_of_year',
)
// ignore: non_constant_identifier_names
external int _ICU4XIsoDate_day_of_year(ffi.Pointer<ffi.Opaque> self);

@RecordSymbol('ICU4XIsoDate_day_of_month')
@ffi.Native<ffi.Uint32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_day_of_month',
)
// ignore: non_constant_identifier_names
external int _ICU4XIsoDate_day_of_month(ffi.Pointer<ffi.Opaque> self);

@RecordSymbol('ICU4XIsoDate_day_of_week')
@ffi.Native<ffi.Int32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_day_of_week',
)
// ignore: non_constant_identifier_names
external int _ICU4XIsoDate_day_of_week(ffi.Pointer<ffi.Opaque> self);

@RecordSymbol('ICU4XIsoDate_week_of_month')
@ffi.Native<ffi.Uint32 Function(ffi.Pointer<ffi.Opaque>, ffi.Int32)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_week_of_month',
)
// ignore: non_constant_identifier_names
external int _ICU4XIsoDate_week_of_month(
  ffi.Pointer<ffi.Opaque> self,
  int firstWeekday,
);

@RecordSymbol('ICU4XIsoDate_week_of_year')
@ffi.Native<
  _ResultWeekOfFfiInt32 Function(
    ffi.Pointer<ffi.Opaque>,
    ffi.Pointer<ffi.Opaque>,
  )
>(isLeaf: true, symbol: 'ICU4XIsoDate_week_of_year')
// ignore: non_constant_identifier_names
external _ResultWeekOfFfiInt32 _ICU4XIsoDate_week_of_year(
  ffi.Pointer<ffi.Opaque> self,
  ffi.Pointer<ffi.Opaque> calculator,
);

@RecordSymbol('ICU4XIsoDate_month')
@ffi.Native<ffi.Uint32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_month',
)
// ignore: non_constant_identifier_names
external int _ICU4XIsoDate_month(ffi.Pointer<ffi.Opaque> self);

@RecordSymbol('ICU4XIsoDate_year')
@ffi.Native<ffi.Int32 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_year',
)
// ignore: non_constant_identifier_names
external int _ICU4XIsoDate_year(ffi.Pointer<ffi.Opaque> self);

@RecordSymbol('ICU4XIsoDate_is_in_leap_year')
@ffi.Native<ffi.Bool Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_is_in_leap_year',
)
// ignore: non_constant_identifier_names
external bool _ICU4XIsoDate_is_in_leap_year(ffi.Pointer<ffi.Opaque> self);

@RecordSymbol('ICU4XIsoDate_months_in_year')
@ffi.Native<ffi.Uint8 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_months_in_year',
)
// ignore: non_constant_identifier_names
external int _ICU4XIsoDate_months_in_year(ffi.Pointer<ffi.Opaque> self);

@RecordSymbol('ICU4XIsoDate_days_in_month')
@ffi.Native<ffi.Uint8 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_days_in_month',
)
// ignore: non_constant_identifier_names
external int _ICU4XIsoDate_days_in_month(ffi.Pointer<ffi.Opaque> self);

@RecordSymbol('ICU4XIsoDate_days_in_year')
@ffi.Native<ffi.Uint16 Function(ffi.Pointer<ffi.Opaque>)>(
  isLeaf: true,
  symbol: 'ICU4XIsoDate_days_in_year',
)
// ignore: non_constant_identifier_names
external int _ICU4XIsoDate_days_in_year(ffi.Pointer<ffi.Opaque> self);
