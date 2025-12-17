// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:icu4x/icu4x.dart' as icu;

import '../datetime_format/datetime_format_options.dart' show ClockStyle;
import '../options.dart' show Calendar, NumberingSystem;
import 'locale.dart';

class Locale4x implements Locale {
  final icu.Locale _locale;

  const Locale4x(this._locale);

  icu.Locale get get4X => _locale;

  @override
  String toLanguageTag([String separator = '-']) => _locale.toString();

  @override
  String toString() => toLanguageTag();

  @override
  Locale withCalendar(Calendar calendar) =>
      Locale4x(_locale.clone()..setUnicodeExtension('ca', calendar.jsName));

  @override
  Locale withNumberingSystem(NumberingSystem system) =>
      Locale4x(_locale.clone()..setUnicodeExtension('nu', system.jsName));

  @override
  Locale withClockStyle(ClockStyle clockStyle) => Locale4x(
    _locale.clone()
      ..setUnicodeExtension('hc', clockStyle.hourStyleExtensionString),
  );
}

Locale parseLocale(String s) => Locale4x(icu.Locale.fromString(s));
