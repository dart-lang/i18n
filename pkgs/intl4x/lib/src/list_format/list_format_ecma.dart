// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../../intl4x.dart';
@JS()
import '../utils.dart';
import 'list_formatter.dart';

ListFormatter getListFormatter(Intl intl, ListFormatOptions options) =>
    ListFormatECMA(intl, options);

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

class ListFormatECMA extends ListFormatter {
  ListFormatECMA(super.intl, super.options);

  @override
  String formatImpl(List<String> list) {
    var o = newObject<Object>();
    setProperty(o, 'sign', options.localeMatcher.jsName);
    setProperty(o, 'type', options.type.name);
    setProperty(o, 'style', options.style.name);
    return ListFormatJS(localeToJs(intl.locale), o).format(list);
  }

  @override
  List<String> supportedLocalesOf(List<String> locales) {
    var o = newObject<Object>();
    setProperty(o, 'localeMatcher', options.localeMatcher.jsName);
    return supportedLocalesOfJS(locales.map(localeToJs).toList(), o);
  }
}
