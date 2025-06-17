// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'ecma/ecma_policy.dart';
import 'locale/locale.dart';
import 'options.dart';

T buildFormatter<T, Options>(
  Locale locale,
  Options options,
  LocaleMatcher localeMatcher,
  EcmaPolicy ecmaPolicy,
  T? Function(Locale locales, Options options, LocaleMatcher localeMatcher)
  builderECMA,
  T Function(Locale locales, Options options) builder4X,
) {
  if (ecmaPolicy.useBrowser(locale)) {
    return builderECMA(locale, options, localeMatcher) ??
        builder4X(locale, options);
  } else {
    return builder4X(locale, options);
  }
}

extension Mapper<T extends Object> on T {
  S map<S>(S Function(T value) f) => f(this);
}
