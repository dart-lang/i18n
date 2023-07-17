// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale.dart';
import '../options.dart';
import '../utils.dart';
import 'list_format_impl.dart';
import 'list_format_options.dart';

ListFormatImpl? getListFormatterECMA(
  Locale locale,
  LocaleMatcher localeMatcher,
) =>
    _ListFormatECMA.tryToBuild(locale, localeMatcher);

@JS('Intl.ListFormat')
class ListFormatJS {
  external factory ListFormatJS([List<String> locale, Object options]);
  external String format(List<String> list);
}

@JS('Intl.ListFormat.supportedLocalesOf')
external List<String> supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

class _ListFormatECMA extends ListFormatImpl {
  _ListFormatECMA(super.locales);

  static ListFormatImpl? tryToBuild(
    Locale locale,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(locale, localeMatcher);
    return supportedLocales.isNotEmpty
        ? _ListFormatECMA(supportedLocales.first)
        : null;
  }

  static List<String> supportedLocalesOf(
    String locale,
    LocaleMatcher localeMatcher,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return List.from(supportedLocalesOfJS([localeToJsFormat(locale)], o));
  }

  @override
  String formatImpl(List<String> list, ListFormatOptions options) {
    return ListFormatJS([localeToJsFormat(locale)], options.toJsOptions())
        .format(list);
  }
}

extension on ListFormatOptions {
  Object toJsOptions() {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    setProperty(o, 'type', type.name);
    setProperty(o, 'style', style.name);
    return o;
  }
}
