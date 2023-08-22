// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale.dart';
import '../options.dart';
import 'number_format_impl.dart';
import 'number_format_options.dart';

NumberFormatImpl? getNumberFormatterECMA(
  Locale locale,
  LocaleMatcher localeMatcher,
) =>
    _NumberFormatECMA.tryToBuild(locale, localeMatcher);

@JS('Intl.NumberFormat')
class _NumberFormatJS {
  external factory _NumberFormatJS([List<String> locale, Object options]);
  external String format(Object num);
}

@JS('Intl.NumberFormat.supportedLocalesOf')
external List<String> _supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

class _NumberFormatECMA extends NumberFormatImpl {
  _NumberFormatECMA(super.locales);

  static NumberFormatImpl? tryToBuild(
    Locale locale,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(localeMatcher, locale);
    return supportedLocales.isNotEmpty
        ? _NumberFormatECMA(supportedLocales.first)
        : _NumberFormatECMA(const Locale(language: 'en'));
  }

  static List<Locale> supportedLocalesOf(
    LocaleMatcher localeMatcher,
    Locale locale,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return List.from(_supportedLocalesOfJS([locale.toLanguageTag()], o))
        .whereType<String>()
        .map(Locale.parse)
        .toList();
  }

  @override
  String formatImpl(Object number, NumberFormatOptions options) {
    final numberFormatJS = _NumberFormatJS(
      [locale.toLanguageTag()],
      options.toJsOptions(),
    );
    return numberFormatJS.format(number);
  }
}

extension on NumberFormatOptions {
  Object toJsOptions() {
    final o = newObject<Object>();
    setProperty(o, 'sign', signDisplay.name);
    if (notation is CompactNotation) {
      setProperty(o, 'compactDisplay',
          (notation as CompactNotation).compactDisplay.name);
    }
    if (style is CurrencyStyle) {
      final currencyStyle = style as CurrencyStyle;
      setProperty(o, 'currency', currencyStyle.currency);
      setProperty(o, 'currencyDisplay', currencyStyle.display.name);
      setProperty(o, 'currencySign', currencyStyle.sign.name);
    }
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    setProperty(o, 'notation', notation.name);
    if (numberingSystem != null) {
      setProperty(o, 'numberingSystem', numberingSystem);
    }
    setProperty(o, 'signDisplay', signDisplay.name);
    setProperty(o, 'style', style.name);
    if (style is UnitStyle) {
      final unitStyle = style as UnitStyle;
      setProperty(o, 'unit', unitStyle.unit.jsName);
      setProperty(o, 'unitDisplay', unitStyle.unitDisplay.name);
    }
    setProperty(o, 'useGrouping', useGrouping.jsName);
    setProperty(o, 'roundingMode', roundingMode.name);
    if (digits?.roundingPriority != null) {
      setProperty(o, 'roundingPriority', digits?.roundingPriority!.name);
    }
    if (digits?.roundingIncrement != null) {
      setProperty(o, 'roundingIncrement', digits?.roundingIncrement!);
    }
    setProperty(o, 'minimumIntegerDigits', minimumIntegerDigits);
    if (digits?.fractionDigits.$1 != null) {
      setProperty(o, 'minimumFractionDigits', digits?.fractionDigits.$1);
    }
    if (digits?.fractionDigits.$2 != null) {
      setProperty(o, 'maximumFractionDigits', digits?.fractionDigits.$2);
    }
    if (digits?.significantDigits.$1 != null) {
      setProperty(o, 'minimumSignificantDigits', digits?.significantDigits.$1);
    }
    if (digits?.significantDigits.$2 != null) {
      setProperty(o, 'maximumSignificantDigits', digits?.significantDigits.$2);
    }
    setProperty(o, 'trailingZeroDisplay', trailingZeroDisplay.name);
    return o;
  }
}
