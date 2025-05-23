// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../bindings/lib.g.dart' as icu;

import 'locale.dart';

extension Locale4X on Locale {
  icu.Locale to4X() {
    final icu4xLocale = icu.Locale.unknown()..language = language;
    if (region != null) icu4xLocale.setRegion(region!);
    if (script != null) icu4xLocale.setScript(script!);
    return icu4xLocale;
  }
}
