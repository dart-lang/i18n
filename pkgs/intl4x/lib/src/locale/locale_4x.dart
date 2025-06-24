// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../bindings/lib.g.dart' as icu;

import 'locale.dart';

class Locale4x implements Locale {
  final icu.Locale _locale;

  const Locale4x(this._locale);

  @override
  String get language => _locale.language;

  @override
  String? get region => _locale.region;

  @override
  String? get script => _locale.script;

  @override
  String toLanguageTag([String separator = '-']) => _locale.toString();
}

Locale parseLocale(String s) => Locale4x(icu.Locale.fromString(s));

extension Locale4X on Locale {
  icu.Locale get toX {
    final icu4xLocale = icu.Locale.unknown()..language = language;
    if (region != null) icu4xLocale.setRegion(region!);
    if (script != null) icu4xLocale.setScript(script!);
    return icu4xLocale;
  }
}
