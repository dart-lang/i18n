// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../locale/locale.dart';
import 'number_format_impl.dart';
import 'number_format_options.dart';

NumberFormatImpl getNumberFormatterECMA(
  Locale locale,
  NumberFormatOptions options,
) => _NumberFormatECMA.tryToBuild(locale, options);

@JS('Intl.NumberFormat')
extension type NumberFormat._(JSObject _) implements JSObject {
  external factory NumberFormat([JSArray<JSString> locale, JSAny options]);
  external String format(JSAny num);

  external static JSArray<JSString> supportedLocalesOf(
    JSArray<JSString> locales, [
    JSAny options,
  ]);
}

class _NumberFormatECMA extends NumberFormatImpl {
  _NumberFormatECMA(super.locale, super.options);

  static NumberFormatImpl tryToBuild(
    Locale locale,
    NumberFormatOptions options,
  ) {
    final supportedLocales = supportedLocalesOf(locale);
    return _NumberFormatECMA(
      supportedLocales.firstOrNull ?? Locale.parse('und'),
      options,
    );
  }

  static List<Locale> supportedLocalesOf(Locale locale) => NumberFormat.supportedLocalesOf(
      [locale.toLanguageTag().toJS].toJS,
    ).toDart.whereType<String>().map(Locale.parse).toList();

  @override
  String formatImpl(Object number) {
    final numberFormatJS = NumberFormat(
      [locale.toLanguageTag().toJS].toJS,
      options.toJsOptions(),
    );
    return numberFormatJS.format(number.jsify()!);
  }
}

extension on NumberFormatOptions {
  JSAny toJsOptions() {
    Map<String, dynamic> styleOptions;
    if (style is CurrencyStyle) {
      final currencyStyle = style as CurrencyStyle;
      styleOptions = {
        'currency': currencyStyle.currency,
        'currencyDisplay': currencyStyle.display.name,
        'currencySign': currencyStyle.sign.name,
      };
    } else if (style is UnitStyle) {
      final unitStyle = style as UnitStyle;
      styleOptions = {
        'unit': unitStyle.unit.jsName,
        'unitDisplay': unitStyle.unitDisplay.name,
      };
    } else {
      styleOptions = {};
    }
    return {
      ...styleOptions,
      'sign': signDisplay.name,
      if (notation is CompactNotation)
        'compactDisplay': (notation as CompactNotation).compactDisplay.name,
      'notation': notation.name,
      if (numberingSystem != null) 'numberingSystem': numberingSystem,
      'signDisplay': signDisplay.name,
      'style': style.name,
      'useGrouping': useGrouping.jsName,
      'roundingMode': roundingMode.name,
      if (digits?.roundingPriority != null)
        'roundingPriority': digits?.roundingPriority!.name,
      if (digits?.roundingIncrement != null)
        'roundingIncrement': digits?.roundingIncrement!,
      'minimumIntegerDigits': minimumIntegerDigits,
      if (digits?.fractionDigits.$1 != null)
        'minimumFractionDigits': digits?.fractionDigits.$1,
      if (digits?.fractionDigits.$2 != null)
        'maximumFractionDigits': digits?.fractionDigits.$2,
      if (digits?.significantDigits.$1 != null)
        'minimumSignificantDigits': digits?.significantDigits.$1,
      if (digits?.significantDigits.$2 != null)
        'maximumSignificantDigits': digits?.significantDigits.$2,
      'trailingZeroDisplay': trailingZeroDisplay.name,
    }.jsify()!;
  }
}
