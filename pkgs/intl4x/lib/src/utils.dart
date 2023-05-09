// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'ecma/ecma_policy.dart';
import 'locale.dart';
import 'options.dart';

/// In js, locales are not written using an underscore but using a dash.
List<String> localeToJs(List<Locale> locale) =>
    locale.map((e) => e.replaceAll('_', '-')).toList();

T buildFormatter<T>(
  List<Locale> locales,
  LocaleMatcher localeMatcher,
  EcmaPolicy ecmaPolicy,
  T? Function(List<Locale> locales, LocaleMatcher localeMatcher) builderECMA,
  T Function(List<Locale> locales) builder4X,
) {
  if (ecmaPolicy.useFor(locales)) {
    return builderECMA(locales, localeMatcher) ?? builder4X(locales);
  } else {
    return builder4X(locales);
  }
}
