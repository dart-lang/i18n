// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale/locale.dart';
import 'collation_impl.dart';
import 'collation_options.dart';

CollationImpl? getCollatorECMA(
  Locale locale,
  CollationOptions options,
  LocaleMatcher localeMatcher,
) =>
    CollationECMA.tryToBuild(locale, options, localeMatcher);

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
  CollationECMA(super.locale, super.options);

  static CollationImpl? tryToBuild(
    Locale locale,
    CollationOptions options,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(localeMatcher, locale);
    return supportedLocales.isNotEmpty
        ? CollationECMA(supportedLocales.first, options)
        : null;
  }

  static List<Locale> supportedLocalesOf(
    LocaleMatcher localeMatcher,
    Locale locale,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return List<dynamic>.from(supportedLocalesOfJS([locale.toLanguageTag()], o))
        .whereType<String>()
        .map(Locale.parse)
        .toList();
  }

  @override
  int compareImpl(String a, String b) {
    final collatorJS = CollatorJS(
      [locale.toLanguageTag()],
      options.toJsOptions(),
    );
    return collatorJS.compare(a, b);
  }
}

extension on CollationOptions {
  Object toJsOptions() {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    setProperty(o, 'usage', usage.name);
    if (sensitivity != null) {
      setProperty(o, 'sensitivity', sensitivity!.jsName);
    }
    setProperty(o, 'ignorePunctuation', ignorePunctuation);
    setProperty(o, 'numeric', numeric);
    setProperty(o, 'caseFirst', caseFirst.jsName);
    if (collation != null) {
      setProperty(o, 'collation', collation);
    }
    return o;
  }
}
