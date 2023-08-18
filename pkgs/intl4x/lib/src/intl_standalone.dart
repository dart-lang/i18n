// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'locale/locale.dart';

Locale findSystemLocale() {
  try {
    return Locale.parse(Platform.localeName);
  } catch (e) {
    return const Locale(language: 'en', region: 'US');
  }
}
