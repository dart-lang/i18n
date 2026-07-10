// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import '../datetime_format/datetime_format_options.dart' show ClockStyle;
import '../options.dart';
import 'locale.dart';

@JS('Intl.Locale')
extension type LocaleJS._(JSObject _) implements JSObject {
  external factory LocaleJS(String s);
  external factory LocaleJS.constructor(String language, JSAny options);
  external LocaleJS minimize();
  external LocaleJS maximize();
  external String get language;
  external String? get script;
  external String? get region;
  external JSObject? get weekInfo;
}

Locale parseLocale(String s) => LocaleEcma(LocaleJS(s));

class LocaleEcma implements Locale {
  final LocaleJS _locale;

  LocaleEcma(this._locale);

  @override
  String toLanguageTag([String separator = '-']) => _locale.toString();

  @override
  Weekday get firstDayOfWeek {
    final weekInfo = _locale.weekInfo;
    if (weekInfo != null) {
      final firstDay = weekInfo.getProperty('firstDay'.toJS);
      if (firstDay != null && firstDay.isA<JSNumber>()) {
        return Weekday.values[(firstDay as JSNumber).toDartInt];
      }
    }
    return Weekday.monday; // Default fallback to Monday (1)
  }

  @override
  String toString() => toLanguageTag();

  @override
  Locale withCalendar(Calendar calendar) => LocaleEcma(
    LocaleJS.constructor(
      _locale.toString(),
      {'calendar': calendar.jsName}.jsify()!,
    ),
  );

  @override
  Locale withNumberingSystem(NumberingSystem system) => LocaleEcma(
    LocaleJS.constructor(
      _locale.toString(),
      {'numberingSystem': system.jsName}.jsify()!,
    ),
  );

  @override
  Locale withClockStyle(ClockStyle clockStyle) => LocaleEcma(
    LocaleJS.constructor(
      _locale.toString(),
      {
        'hour12': clockStyle.is12Hour,
        'hourCycle': clockStyle.hourStyleExtensionString,
      }.jsify()!,
    ),
  );
}
