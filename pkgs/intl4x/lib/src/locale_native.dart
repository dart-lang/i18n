// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'locale.dart';

Locale parseLocaleWithSeparatorPlaceholder(String s, [String separator = '-']) {
  final parsed = s.split(separator);
  return Locale(
    language: parsed[0],
    region: parsed.length > 1 ? parsed[1] : '',
    variant: parsed.length > 1 ? parsed.last : '',
  );
}

//TODO: Switch to ICU4X!
Locale parseLocale(String s, [String separator = '-']) {
  if (s.contains('_')) {
    return parseLocaleWithSeparatorPlaceholder(s, '_');
  } else {
    return parseLocaleWithSeparatorPlaceholder(s);
  }
}
