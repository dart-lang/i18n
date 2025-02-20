// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

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
}

Locale parseLocale(String s) => toLocale(LocaleJS(s));

Locale toLocale(LocaleJS parsed) => Locale(
  language: parsed.language,
  region: parsed.region,
  script: parsed.script,
);

String toLanguageTagImpl(Locale l, [String separator = '-']) =>
    fromLocale(l).toString();

LocaleJS fromLocale(Locale l) {
  final options = {
    if (l.region != null) 'region': l.region,
    if (l.script != null) 'script': l.script,
  };
  return LocaleJS.constructor(l.language, options.jsify()!);
}

Locale minimizeImpl(Locale l) => toLocale(fromLocale(l).minimize());
Locale maximizeImpl(Locale l) => toLocale(fromLocale(l).maximize());
