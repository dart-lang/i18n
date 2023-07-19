// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'locale_native.dart' if (dart.library.js) 'locale_browser.dart';

class Locale {
  final String language;
  final String variant;
  final String region;

  const Locale({
    required this.language,
    this.region = '',
    this.variant = '',
  });

  String toLanguageTag([String separator = '-']) {
    return [
      language,
      if (variant.isNotEmpty) variant,
      if (region.isNotEmpty) region,
    ].join(separator);
  }

  static Locale parse(String s) => parseLocale(s);
}

// TODO: add all locales which are supported by ICU4X / Browsers
const List<Locale> allLocales = [
  Locale(language: 'de', region: 'DE'),
  Locale(language: 'en', region: 'US'),
  Locale(language: 'zh', variant: 'Hant'),
];
