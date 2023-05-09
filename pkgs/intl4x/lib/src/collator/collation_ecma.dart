// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale.dart';
import '../options.dart';
import '../utils.dart';
import 'collation.dart';
import 'collation_options.dart';

Collation? getCollatorECMA(
  List<Locale> locales,
  LocaleMatcher localeMatcher,
) =>
    CollationECMA.tryToBuild(locales, localeMatcher);

@JS('Intl.Collator')
class CollatorJS {
  external factory CollatorJS([List<String> locale, Object options]);
  external int compare(String a, String b);
}

@JS('Intl.Collator.supportedLocalesOf')
external List<String> supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

class CollationECMA extends CollationImpl {
  CollationECMA(super.locales, super.localeMatcher);

  static Collation? tryToBuild(
    List<Locale> locales,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(localeMatcher, locales);
    return supportedLocales.isNotEmpty
        ? Collation(CollationECMA(supportedLocales, localeMatcher))
        : null;
  }

  static List<String> supportedLocalesOf(
    LocaleMatcher localeMatcher,
    List<Locale> locales,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return List.from(supportedLocalesOfJS(localeToJs(locales), o));
  }

  @override
  int compareImpl(
    String a,
    String b, {
    Usage usage = Usage.sort,
    Sensitivity? sensitivity,
    bool ignorePunctuation = false,
    bool numeric = false,
    CaseFirst? caseFirst,
    String? collation,
  }) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    setProperty(o, 'usage', usage.name);
    if (sensitivity != null) {
      setProperty(o, 'sensitivity', sensitivity.jsName);
    }
    setProperty(o, 'ignorePunctuation', ignorePunctuation);
    setProperty(o, 'numeric', numeric);
    if (caseFirst != null) {
      setProperty(o, 'caseFirst', caseFirst.jsName);
    }
    if (collation != null) {
      setProperty(o, 'collation', collation);
    }
    return CollatorJS(localeToJs(locales), o).compare(a, b);
  }
}
