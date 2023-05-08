// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../options.dart';
@JS()
import '../utils.dart';
import 'number_format.dart';
import 'number_format_options.dart';

NumberFormat getNumberFormatter(String locale) => _NumberFormatECMA(locale);

@JS('Intl.NumberFormat')
class _NumberFormatJS {
  external factory _NumberFormatJS([String locale, Object options]);
  external String format(Object num);
}

@JS('Intl.NumberFormat.supportedLocalesOf')
external List<String> _supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

class _NumberFormatECMA extends NumberFormat {
  _NumberFormatECMA(super.locale);

  @override
  String formatImpl(Object number,
      {Style style = const DecimalStyle(),
      String? currency,
      CurrencyDisplay currencyDisplay = CurrencyDisplay.symbol,
      Unit? unit,
      UnitDisplay unitDisplay = UnitDisplay.short,
      LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
      SignDisplay signDisplay = SignDisplay.auto,
      Notation notation = const StandardNotation(),
      Grouping useGrouping = Grouping.auto,
      String? numberingSystem,
      RoundingMode roundingMode = RoundingMode.halfExpand,
      TrailingZeroDisplay trailingZeroDisplay = TrailingZeroDisplay.auto,
      int minimumIntegerDigits = 1,
      Digits? digits}) {
    var o = newObject<Object>();
    setProperty(o, 'sign', signDisplay.name);
    if (notation is CompactNotation) {
      setProperty(o, 'compactDisplay', notation.compactDisplay.name);
    }
    if (style is CurrencyStyle) {
      var currencyStyle = style;
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
      var unitStyle = style;
      setProperty(o, 'unit', unitStyle.unit.jsName);
      setProperty(o, 'unitDisplay', unitStyle.unitDisplay.name);
    }
    setProperty(o, 'useGrouping', useGrouping.name);
    setProperty(o, 'roundingMode', roundingMode.name);
    if (digits?.roundingPriority != null) {
      setProperty(o, 'roundingPriority', digits?.roundingPriority!.name);
    }
    if (digits?.roundingIncrement != null) {
      setProperty(o, 'roundingIncrement', digits?.roundingIncrement!);
    }
    setProperty(o, 'minimumIntegerDigits', minimumIntegerDigits);
    if (digits?.fractionDigits != null) {
      if (digits?.fractionDigits!.$1 != null) {
        setProperty(o, 'minimumFractionDigits', digits?.fractionDigits!.$1);
      }
      if (digits?.fractionDigits!.$2 != null) {
        setProperty(o, 'maximumFractionDigits', digits?.fractionDigits!.$2);
      }
    }
    if (digits?.significantDigits != null) {
      setProperty(o, 'minimumSignificantDigits', digits?.significantDigits!.$1);
      setProperty(o, 'maximumSignificantDigits', digits?.significantDigits!.$2);
    }
    setProperty(o, 'trailingZeroDisplay', trailingZeroDisplay.name);
    return _NumberFormatJS(localeToJs(locale), o).format(number);
  }

  // List<String> supportedLocalesOf(List<String> locales) {
  //   var o = newObject<Object>();
  //   setProperty(o, 'localeMatcher', localeMatcher.jsName);
  //   return _supportedLocalesOfJS(locales.map(localeToJs).toList(), o);
  // }
}
