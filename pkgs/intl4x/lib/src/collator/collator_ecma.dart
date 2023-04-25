// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/intl.dart';
@JS()
import 'package:intl4x/src/utils.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'collator_impl.dart';
import 'collator_options.dart';

Collator getCollator(Intl intl, CollatorOptions options) =>
    CollatorECMA(intl, options);

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
  CollatorECMA(super.intl, super.numberFormatOptions);

  @override
  int compareImpl(String a, String b) {
    var o = newObject<Object>();
    setProperty(o, 'localeMatcher', options.localeMatcher.jsName);
    setProperty(o, 'usage', options.usage.name);
    if (options.sensitivity != null) {
      setProperty(o, 'sensitivity', options.sensitivity!.jsName);
    }
    setProperty(o, 'ignorePunctuation', options.ignorePunctuation);
    setProperty(o, 'numeric', options.numeric);
    if (options.caseFirst != null) {
      setProperty(o, 'caseFirst', options.caseFirst!.jsName);
    }
    if (options.collation != null) {
      setProperty(o, 'collation', options.collation!);
    }
    return CollatorJS(localeToJs(intl.locale), o).compare(a, b);
  }

  @override
  List<String> supportedLocalesOf(
      List<String> locales, LocaleMatcher localeMatcher) {
    var o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return supportedLocalesOfJS(locales.map(localeToJs).toList(), o);
  }
}
