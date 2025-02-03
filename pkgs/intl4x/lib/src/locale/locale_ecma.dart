// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop'
    show BoolToJSBoolean, JSAny, JSObject, StringToJSString;
import 'dart:js_interop_unsafe';

import 'package:js/js.dart';

import '../../collation.dart';
import '../datetime_format/datetime_format_options.dart';
import 'locale.dart';

@JS('Intl.Locale')
class LocaleJS {
  external factory LocaleJS(String s);
  external factory LocaleJS.constructor(String language, Object options);
  external LocaleJS minimize();
  external LocaleJS maximize();
  external String get language;
  external String? get script;
  external String? get region;
  external String? get calendar;
  external String? get caseFirst;
  external String? get collation;
  external String? get hourCycle;
  external String? get numberingSystem;
  external String? get numeric;
}

Locale parseLocale(String s) => toLocale(LocaleJS(s));

Locale toLocale(LocaleJS parsed) {
  return Locale(
    language: parsed.language,
    region: parsed.region,
    script: parsed.script,
    calendar: Calendar.values
        .where((element) => element.jsName == parsed.calendar)
        .firstOrNull,
    caseFirst: CaseFirst.values
        .where((element) => element.jsName == parsed.caseFirst)
        .firstOrNull,
    collation: parsed.collation,
    hourCycle: HourCycle.values
        .where((element) => element.name == parsed.hourCycle)
        .firstOrNull,
    numberingSystem: parsed.numberingSystem,
    numeric: bool.tryParse(parsed.numeric ?? ''),
  );
}

String toLanguageTagImpl(Locale l, [String separator = '-']) {
  // return fromLocale(l).toString(); Uncomment as soon as https://github.com/dart-lang/sdk/issues/53106 is resolved

  final subtags = <String>[
    if (l.calendar != null) ...['ca', l.calendar!.jsName],
    if (l.caseFirst != null) l.caseFirst!.jsName,
    if (l.collation != null) l.collation!,
    if (l.hourCycle != null) ...['hc', l.hourCycle!.name],
    if (l.numberingSystem != null) l.numberingSystem!,
    if (l.numeric != null) l.numeric!.toString(),
  ];
  return <String>[
    l.language,
    if (l.script != null) l.script!,
    if (l.region != null) l.region!,
    if (subtags.isNotEmpty) 'u',
    ...subtags,
  ].join(separator);
}

LocaleJS fromLocale(Locale l) {
  final options = JSObject();
  if (l.region != null) setProperty(options, 'region', l.region!.toJS);
  if (l.script != null) setProperty(options, 'script', l.script!.toJS);
  if (l.calendar != null) {
    setProperty(options, 'calendar', l.calendar!.jsName.toJS);
  }
  if (l.caseFirst != null) {
    setProperty(options, 'caseFirst', l.caseFirst!.jsName.toJS);
  }
  if (l.collation != null) setProperty(options, 'collation', l.collation!.toJS);
  if (l.hourCycle != null) {
    setProperty(options, 'hourCycle', l.hourCycle!.name.toJS);
  }
  if (l.numberingSystem != null) {
    setProperty(options, 'numberingSystem', l.numberingSystem!.toJS);
  }
  if (l.numeric != null) setProperty(options, 'numeric', l.numeric!.toJS);
  final localeJS = LocaleJS.constructor(l.language, options);
  return localeJS;
}

void setProperty(JSObject options, String s, JSAny t) =>
    options.setProperty(s.toJS, t);

Locale minimizeImpl(Locale l) => toLocale(fromLocale(l).minimize());
Locale maximizeImpl(Locale l) => toLocale(fromLocale(l).maximize());
