// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../display_names.dart';
import '../locale.dart';
import '../test_checker.dart';
import 'display_names_impl.dart';

class DisplayNames {
  final DisplayNamesOptions _options;
  final DisplayNamesImpl impl;

  DisplayNames(this._options, this.impl);

  String _of(String object, DisplayType type) {
    if (isInTest) {
      return '$object//${impl.locale}';
    } else {
      return impl.ofImpl(object, _options, type);
    }
  }

  String ofDateTime(DateTimeField field) =>
      _of(field.name, DisplayType.dateTimeField);

  String ofLanguage(Locale locale) => _of(locale, DisplayType.language);

  String ofRegion(String regionCode) => _of(regionCode, DisplayType.region);

  String ofScript(String scriptCode) => _of(scriptCode, DisplayType.script);

  String ofCurrency(String currencyCode) =>
      _of(currencyCode, DisplayType.currency);

  String ofCalendar(Calendar calendar) =>
      _of(calendar.jsName, DisplayType.calendar);
}
