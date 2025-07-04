// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'ecma/ecma_native.dart' if (dart.library.js) 'ecma/ecma_web.dart';
import 'locale/locale.dart';
import 'options.dart';

T buildFormatter<T, Options>(
  Locale locale,
  Options options,
  LocaleMatcher localeMatcher,
  T? Function(Locale locales, Options options, LocaleMatcher localeMatcher)
  builderECMA,
  T Function(Locale locales, Options options) builder4X,
) {
  return useBrowser
      ? builderECMA(locale, options, localeMatcher) ??
          builder4X(locale, options)
      : builder4X(locale, options);
}

extension Mapper<T extends Object> on T {
  R map<R>(R Function(T value) f) => f(this);
}
