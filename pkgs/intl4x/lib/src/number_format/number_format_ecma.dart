// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../../intl4x.dart';
@JS()
import '../utils.dart';
import 'number_formatter.dart';

NumberFormatter getNumberFormatter(Intl intl, NumberFormatOptions options) =>
    _NumberFormatECMA(intl, options);

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

class _NumberFormatECMA extends NumberFormatter {
  const _NumberFormatECMA(super.intl, super.numberFormatOptions);

  @override
  String formatImpl(Object number) {
    var o = newObject<Object>();
    setProperty(o, 'sign', options.signDisplay.name);
    if (options.notation is CompactNotation) {
      setProperty(o, 'compactDisplay', options.signDisplay.name);
    }
    if (options.style is CurrencyStyle) {
      var currencyStyle = options.style as CurrencyStyle;
      setProperty(o, 'currency', currencyStyle.currency);
      setProperty(o, 'currencyDisplay', currencyStyle.display.name);
      setProperty(o, 'currencySign', currencyStyle.sign.name);
    }
    setProperty(o, 'localeMatcher', options.localeMatcher.jsName);
    setProperty(o, 'notation', options.notation.name);
    if (options.numberingSystem != null) {
      setProperty(o, 'numberingSystem', options.numberingSystem!);
    }
    setProperty(o, 'signDisplay', options.signDisplay.name);
    setProperty(o, 'style', options.style.name);
    if (options.style is UnitStyle) {
      var unitStyle = options.style as UnitStyle;
      setProperty(o, 'unit', unitStyle.unit.jsName);
      setProperty(o, 'unitDisplay', unitStyle.unitDisplay.name);
    }
    setProperty(o, 'useGrouping', options.useGrouping.name);
    setProperty(o, 'roundingMode', options.roundingMode.name);
    if (options.roundingPriority != null) {
      setProperty(o, 'roundingPriority', options.roundingPriority!.name);
    }
    if (options.roundingIncrement != null) {
      setProperty(o, 'roundingIncrement', options.roundingIncrement!);
    }
    setProperty(o, 'minimumIntegerDigits', options.minimumIntegerDigits);
    if (options.fractionDigits != null) {
      if (options.fractionDigits!.$1 != null) {
        setProperty(o, 'minimumFractionDigits', options.fractionDigits!.$1);
      }
      if (options.fractionDigits!.$2 != null) {
        setProperty(o, 'maximumFractionDigits', options.fractionDigits!.$2);
      }
    }
    if (options.significantDigits != null) {
      setProperty(o, 'minimumSignificantDigits', options.significantDigits!.$1);
      setProperty(o, 'maximumSignificantDigits', options.significantDigits!.$2);
    }
    setProperty(o, 'trailingZeroDisplay', options.trailingZeroDisplay.name);
    return _NumberFormatJS(localeToJs(intl.locale), o).format(number);
  }

  @override
  List<String> supportedLocalesOf(List<String> locales) {
    var o = newObject<Object>();
    setProperty(o, 'localeMatcher', options.localeMatcher.jsName);
    return _supportedLocalesOfJS(locales.map(localeToJs).toList(), o);
  }
}
