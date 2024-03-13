// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale/locale.dart';
import 'list_format_impl.dart';
import 'list_format_options.dart';

ListFormatImpl? getListFormatterECMA(
  Locale locale,
  ListFormatOptions options,
  LocaleMatcher localeMatcher,
) =>
    _ListFormatECMA.tryToBuild(locale, options, localeMatcher);

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
  _ListFormatECMA(super.locale, super.options);

  static ListFormatImpl? tryToBuild(
    Locale locale,
    ListFormatOptions options,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(locale, localeMatcher);
    return supportedLocales.isNotEmpty
        ? _ListFormatECMA(supportedLocales.first, options)
        : null;
  }

  static List<Locale> supportedLocalesOf(
    Locale locale,
    LocaleMatcher localeMatcher,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return List<dynamic>.from(supportedLocalesOfJS([locale.toLanguageTag()], o))
        .whereType<String>()
        .map(Locale.parse)
        .toList();
  }

  @override
  String formatImpl(List<String> list) {
    return ListFormatJS([locale.toLanguageTag()], options.toJsOptions())
        .format(list);
  }
}

extension on ListFormatOptions {
  Object toJsOptions() {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    setProperty(o, 'type', type.jsName);
    setProperty(o, 'style', style.name);
    return o;
  }
}
