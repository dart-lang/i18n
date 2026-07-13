// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import '../locale/locale.dart';
import '../options.dart';

@JS('Intl.Locale')
extension type _LocaleJS._(JSObject _) implements JSObject {
  external factory _LocaleJS(String s);
  external JSObject? get weekInfo;
  external JSObject? getWeekInfo();
}

Weekday getFirstDayOfWeekECMA(Locale locale) {
  final jsLocale = _LocaleJS(locale.toLanguageTag());
  JSObject? weekInfo;
  if (jsLocale.hasProperty('getWeekInfo'.toJS).toDart) {
    weekInfo = jsLocale.getWeekInfo();
  } else if (jsLocale.hasProperty('weekInfo'.toJS).toDart) {
    weekInfo = jsLocale.weekInfo;
  }
  if (weekInfo != null) {
    final firstDayJS = weekInfo.getProperty('firstDay'.toJS);
    if (firstDayJS != null && firstDayJS.isA<JSNumber>()) {
      final firstDay = (firstDayJS as JSNumber).toDartInt;
      if (firstDay >= 1 && firstDay <= 7) {
        return Weekday.fromIsoIndex(firstDay);
      }
    }
  }
  return Weekday.monday;
}
