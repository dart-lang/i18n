// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale.dart';
import '../options.dart';
@JS()
import '../utils.dart';
import 'list_format.dart';
import 'list_format_options.dart';

ListFormat? getListFormatterECMA(
  List<Locale> locales,
  LocaleMatcher localeMatcher,
) =>
    _ListFormatECMA.tryToBuild(locales, localeMatcher);

@JS('Intl.ListFormat')
class ListFormatJS {
  external factory ListFormatJS([String locale, Object options]);
  external String format(List<String> list);
}

@JS('Intl.ListFormat.supportedLocalesOf')
external List<String> supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

class _ListFormatECMA extends ListFormat {
  _ListFormatECMA(super.locale);

  static ListFormat? tryToBuild(
      List<Locale> locales, LocaleMatcher localeMatcher) {
    final supportedLocales = supportedLocalesOf(locales, localeMatcher);
    return supportedLocales.isNotEmpty
        ? _ListFormatECMA(supportedLocales.first)
        : null;
  }

  static List<String> supportedLocalesOf(
    List<String> locales,
    LocaleMatcher localeMatcher,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return supportedLocalesOfJS(locales.map(localeToJs).toList(), o);
  }

  @override
  String formatImpl(
    List<String> list, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Type type = Type.conjunction,
    ListStyle style = ListStyle.long,
  }) {
    final o = newObject<Object>();
    setProperty(o, 'sign', localeMatcher.jsName);
    setProperty(o, 'type', type.name);
    setProperty(o, 'style', style.name);
    return ListFormatJS(localeToJs(locale), o).format(list);
  }
}
