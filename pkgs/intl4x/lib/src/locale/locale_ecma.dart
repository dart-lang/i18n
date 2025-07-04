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

Locale parseLocale(String s) => LocaleEcma(LocaleJS(s));

class LocaleEcma implements Locale {
  final LocaleJS _locale;

  LocaleEcma(this._locale);

  @override
  String toLanguageTag([String separator = '-']) => _locale.toString();

  @override
  String toString() => toLanguageTag();
}
