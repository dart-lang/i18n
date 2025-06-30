// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../display_names.dart';
import '../locale/locale.dart';
import '../test_checker.dart';
import 'display_names_impl.dart';

class DisplayNames {
  final DisplayNamesImpl _impl;

  DisplayNames._(this._impl);

  String ofDateTime(DateTimeField field) => _of(field, _impl.ofDateTime);

  String ofLanguage(Locale locale) => _of(locale, _impl.ofLanguage);

  String ofRegion(String regionCode) => _of(regionCode, _impl.ofRegion);

  String ofScript(String scriptCode) => _of(scriptCode, _impl.ofScript);

  String ofCurrency(String currencyCode) => _of(currencyCode, _impl.ofCurrency);

  String ofCalendar(Calendar calendar) => _of(calendar, _impl.ofCalendar);

  String _of<T>(T object, String Function(T field) implementation) {
    if (isInTest) {
      return '$object//${_impl.locale}';
    } else {
      return implementation(object);
    }
  }
}

DisplayNames buildDisplayNames(DisplayNamesImpl impl) => DisplayNames._(impl);
