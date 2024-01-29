// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale/locale.dart';
import '../options.dart';
import 'plural_rules.dart';
import 'plural_rules_impl.dart';
import 'plural_rules_options.dart';

PluralRulesImpl? getPluralSelectECMA(
  Locale locale,
  PluralRulesOptions options,
  LocaleMatcher localeMatcher,
) =>
    _PluralRulesECMA.tryToBuild(locale, options, localeMatcher);

@JS('Intl.PluralRules')
class PluralRulesJS {
  external factory PluralRulesJS([List<String> locale, Object options]);
  external String select(num number);
}

@JS('Intl.PluralRules.supportedLocalesOf')
external List<String> supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

class _PluralRulesECMA extends PluralRulesImpl {
  _PluralRulesECMA(super.locale, super.options);

  static PluralRulesImpl? tryToBuild(
    Locale locale,
    PluralRulesOptions options,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(locale, localeMatcher);
    return supportedLocales.isNotEmpty
        ? _PluralRulesECMA(supportedLocales.first, options)
        : null;
  }

  static List<Locale> supportedLocalesOf(
    Locale locale,
    LocaleMatcher localeMatcher,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return List<dynamic>.from(supportedLocalesOfJS([locale.toLanguageTag()], o))
        .whereType<String>()
        .map(Locale.parse)
        .toList();
  }

  @override
  PluralCategory selectImpl(num number) {
    final categoryString =
        PluralRulesJS([locale.toLanguageTag()], options.toJsOptions())
            .select(number);
    return PluralCategory.values
        .firstWhere((category) => category.name == categoryString);
  }
}

extension on PluralRulesOptions {
  Object toJsOptions() {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    setProperty(o, 'type', type.name);
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
