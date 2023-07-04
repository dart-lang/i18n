// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'ecma/ecma_policy.dart';
import 'locale.dart';
import 'options.dart';

/// In js, locales are not written using an underscore but using a dash.
String localeToJsFormat(Locale locale) => locale.replaceAll('_', '-');

T buildFormatter<T>(
  Locale locale,
  LocaleMatcher localeMatcher,
  EcmaPolicy ecmaPolicy,
  T? Function(Locale locales, LocaleMatcher localeMatcher) builderECMA,
  T Function(Locale locales) builder4X,
) {
  if (ecmaPolicy.useBrowser(locale)) {
    return builderECMA(locale, localeMatcher) ?? builder4X(locale);
  } else {
    return builder4X(locale);
  }
}
