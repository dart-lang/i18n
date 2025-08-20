// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../locale/locale.dart';
import '../options.dart';
import 'plural_rules.dart';
import 'plural_rules_impl.dart';
import 'plural_rules_options.dart';

PluralRulesImpl getPluralSelectECMA(
  Locale locale,
  PluralRulesOptions options,
  LocaleMatcher localeMatcher,
) => _PluralRulesECMA.tryToBuild(locale, options, localeMatcher);

@JS('Intl.PluralRules')
extension type PluralRules._(JSObject _) implements JSObject {
  external factory PluralRules([JSArray<JSString> locales, JSAny options]);
  external String select(JSNumber number);

  external static JSArray<JSString> supportedLocalesOf(
    JSArray<JSString> locales, [
    JSAny options,
  ]);
}

class _PluralRulesECMA extends PluralRulesImpl {
  _PluralRulesECMA(super.locale, super.options);

  static PluralRulesImpl tryToBuild(
    Locale locale,
    PluralRulesOptions options,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(locale, localeMatcher);
    return _PluralRulesECMA(
      supportedLocales.firstOrNull ?? Locale.parse('und'),
      options,
    );
  }

  static List<Locale> supportedLocalesOf(
    Locale locale,
    LocaleMatcher localeMatcher,
  ) {
    final o = {'localeMatcher': localeMatcher.jsName}.jsify()!;
    return PluralRules.supportedLocalesOf(
      [locale.toLanguageTag().toJS].toJS,
      o,
    ).toDart.whereType<String>().map(Locale.parse).toList();
  }

  @override
  PluralCategory selectImpl(num number) {
    final categoryString = PluralRules(
      [locale.toLanguageTag().toJS].toJS,
      options.toJsOptions(),
    ).select(number.toJS);
    return PluralCategory.values.firstWhere(
      (category) => category.name == categoryString,
    );
  }
}

extension on PluralRulesOptions {
  JSAny toJsOptions() {
    return {
      'localeMatcher': localeMatcher.jsName,
      'type': type.name,
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
