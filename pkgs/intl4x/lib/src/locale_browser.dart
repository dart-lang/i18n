// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';

import 'locale.dart';

@JS('Intl.Locale')
class LocaleJS {
  external factory LocaleJS(String s);
  external String? get script;
  external String get language;
  external String? get region;
}

Locale parseLocale(String s) {
  final parsed = LocaleJS(s);
  return Locale(
    language: parsed.language,
    region: parsed.region ?? '',
    variant: parsed.script ?? '',
  );
}
