// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale.dart';
import '../options.dart';
@JS()
import '../utils.dart';
import 'datetime_format_impl.dart';
import 'datetime_format_options.dart';

DatetimeFormatImpl? getDatetimeFormatterECMA(
  Locale locale,
  LocaleMatcher localeMatcher,
) =>
    _DatetimeFormatECMA.tryToBuild(locale, localeMatcher);

@JS('Intl.DateTimeFormat')
class _DatetimeFormatJS {
  external factory _DatetimeFormatJS([List<String> locale, Object options]);
  external String format(Object num);
}

@JS('Intl.DateTimeFormat.supportedLocalesOf')
external List<String> _supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

@JS('Date')
class DateJS {
  external factory DateJS(
    int year,
    int monthIndex,
    int day,
    int hours,
    int minutes,
    int seconds,
    int milliseconds,
  );
  // ignore: non_constant_identifier_names
  external factory DateJS.UTC(
    int year,
    int monthIndex,
    int day,
    int hours,
    int minutes,
    int seconds,
    int milliseconds,
  );
}

class _DatetimeFormatECMA extends DatetimeFormatImpl {
  _DatetimeFormatECMA(super.locales);

  static DatetimeFormatImpl? tryToBuild(
    Locale locale,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(localeMatcher, locale);
    return supportedLocales.isNotEmpty
        ? _DatetimeFormatECMA(supportedLocales.first)
        : null; //TODO: Add support to force return an instance instead of null.
  }

  static List<String> supportedLocalesOf(
    LocaleMatcher localeMatcher,
    Locale locale,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return List.from(_supportedLocalesOfJS([localeToJsFormat(locale)], o));
  }

  @override
  String formatImpl(DateTime datetime, DatetimeFormatOptions options) {
    final datetimeFormatJS = _DatetimeFormatJS(
      [localeToJsFormat(locale)],
      options.toJsOptions(),
    );
    return datetimeFormatJS.format(datetime.toJs());
  }
}

extension on DateTime {
  DateJS toJs() {
    if (isUtc) {
      return DateJS.UTC(year, month, day, hour, minute, second, millisecond);
    } else {
      return DateJS(year, month, day, hour, minute, second, millisecond);
    }
  }
}

extension on DatetimeFormatOptions {
  Object toJsOptions() {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return o;
  }
}
