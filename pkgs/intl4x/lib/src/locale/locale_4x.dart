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
  String get language => _locale.language;

  @override
  String? get region => _locale.region;

  @override
  String? get script => _locale.script;

  @override
  Locale maximize() {
    final copy = _locale.clone();
    _expander.maximize(copy);
    return Locale4x(copy);
  }

  @override
  Locale minimize() {
    final copy = _locale.clone();
    _expander.minimize(copy);
    return Locale4x(copy);
  }

  @override
  Locale canonicalize() {
    final copy = _locale.clone();
    _canonicalizer.canonicalize(copy);
    return Locale4x(copy);
  }

  @override
  String toLanguageTag([String separator = '-']) => _locale.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Locale && toLanguageTag() == other.toLanguageTag());

  @override
  int get hashCode => toLanguageTag().hashCode;

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

final icu.LocaleExpander _expander = icu.LocaleExpander.extended();
final icu.LocaleCanonicalizer _canonicalizer =
    icu.LocaleCanonicalizer.extended();
