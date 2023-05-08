// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../../intl4x.dart';
import '../options.dart';
@JS()
import '../utils.dart';
import 'list_format.dart';

ListFormat getListFormatter(String locale) => ListFormatECMA(locale);

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

class ListFormatECMA extends ListFormat {
  ListFormatECMA(super.locale);

  // @override
  // List<String> supportedLocalesOf(List<String> locales) {
  //   var o = newObject<Object>();
  //   setProperty(o, 'localeMatcher', options.localeMatcher.jsName);
  //   return supportedLocalesOfJS(locales.map(localeToJs).toList(), o);
  // }

  @override
  String formatImpl(
    List<String> list, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Type type = Type.conjunction,
    ListStyle style = ListStyle.long,
  }) {
    var o = newObject<Object>();
    setProperty(o, 'sign', localeMatcher.jsName);
    setProperty(o, 'type', type.name);
    setProperty(o, 'style', style.name);
    return ListFormatJS(localeToJs(locale), o).format(list);
  }
}
