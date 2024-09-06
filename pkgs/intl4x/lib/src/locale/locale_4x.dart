// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../bindings/lib.g.dart' as icu;

import 'locale.dart';
import 'locale_native.dart';

extension Locale4XTransformer on Locale {
  icu.Locale to4X() {
    if (this is IcuLocale) {
      return (this as IcuLocale).locale;
    } else {
      final icu4xLocale = icu.Locale.und()..language = language;
      if (region != null) icu4xLocale.region = region!;
      if (script != null) icu4xLocale.script = script!;
      return icu4xLocale;
    }
  }
}
