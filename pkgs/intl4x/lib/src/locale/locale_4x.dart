// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../bindings/lib.g.dart' as icu;

import 'locale.dart';

class Locale4x implements Locale {
  final icu.Locale _locale;

  const Locale4x(this._locale);

  icu.Locale get toX => _locale;

  @override
  String toLanguageTag([String separator = '-']) => _locale.toString();
}

Locale parseLocale(String s) => Locale4x(icu.Locale.fromString(s));
