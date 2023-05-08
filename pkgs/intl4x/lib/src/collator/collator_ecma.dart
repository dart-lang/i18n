// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../options.dart';
@JS()
import '../utils.dart';
import 'collator.dart';
import 'collator_options.dart';

Collator getCollator(String locale) => CollatorECMA(locale);

@JS('Intl.Collator')
class CollatorJS {
  external factory CollatorJS([String locale, Object options]);
  external int compare(String a, String b);
}

@JS('Intl.Collator.supportedLocalesOf')
external List<String> supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

class CollatorECMA extends Collator {
  CollatorECMA(super.locale);

  // @override
  // List<String> supportedLocalesOf(List<String> locales) {
  //   var o = newObject<Object>();
  //   setProperty(o, 'localeMatcher', localeMatcher.jsName);
  //   return supportedLocalesOfJS(locales.map(localeToJs).toList(), o);
  // }

  @override
  int compareImpl(
    String a,
    String b, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Usage usage = Usage.sort,
    Sensitivity? sensitivity,
    bool ignorePunctuation = false,
    bool numeric = false,
    CaseFirst? caseFirst,
    String? collation,
  }) {
    var o = newObject<Object>();
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
    return CollatorJS(localeToJs(locale), o).compare(a, b);
  }
}
