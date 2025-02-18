// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@JS('Intl')
library;

import 'dart:js_interop';

import '../locale/locale.dart';
import '../options.dart';
import 'collation_impl.dart';
import 'collation_options.dart';

CollationImpl? getCollatorECMA(
  Locale locale,
  CollationOptions options,
  LocaleMatcher localeMatcher,
) =>
    CollationECMA.tryToBuild(locale, options, localeMatcher);

extension type Collator._(JSObject _) implements JSObject {
  external Collator([JSArray<JSString> locales, JSAny options]);
  external int compare(String a, String b);

  external static JSArray<JSString> supportedLocalesOf(
      JSArray<JSString> locales,
      [JSAny options]);
}

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
    final o = {'localeMatcher': localeMatcher.jsName}.jsify()!;
    return Collator.supportedLocalesOf([locale.toLanguageTag().toJS].toJS, o)
        .toDart
        .whereType<String>()
        .map(Locale.parse)
        .toList();
  }

  @override
  int compareImpl(String a, String b) {
    final collatorJS = Collator(
      [locale.toLanguageTag().toJS].toJS,
      options.toJsOptions(),
    );
    return collatorJS.compare(a, b);
  }
}

extension on CollationOptions {
  JSAny toJsOptions() => {
        'localeMatcher': localeMatcher.jsName,
        'usage': usage.name,
        if (sensitivity != null) 'sensitivity': sensitivity!.jsName,
        'ignorePunctuation': ignorePunctuation,
        'numeric': numeric,
        'caseFirst': caseFirst.jsName,
        if (collation != null) 'collation': collation,
      }.jsify()!;
}
