// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart' show findSystemLocale;
import '../locale/locale.dart' show Locale;
import '../test_checker.dart';
import 'display_names_impl.dart';
import 'display_names_options.dart' show DisplayNamesOptions;

class DisplayNames {
  final DisplayNamesImpl _impl;

  DisplayNames({
    Locale? locale,
    DisplayNamesOptions options = const DisplayNamesOptions(),
  }) : _impl = DisplayNamesImpl.build(locale ?? findSystemLocale(), options);

  String ofLanguage(Locale locale) => _of(locale, _impl.ofLanguage);

  String ofRegion(String regionCode) => _of(regionCode, _impl.ofRegion);

  String _of<T>(T object, String Function(T field) implementation) {
    if (isInTest) {
      return '$object//${_impl.locale}';
    } else {
      return implementation(object);
    }
  }
}
