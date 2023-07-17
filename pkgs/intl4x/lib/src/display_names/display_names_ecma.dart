// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale.dart';
import '../options.dart';
@JS()
import '../utils.dart';
import 'display_names_impl.dart';
import 'display_names_options.dart';

DisplayNamesImpl? getDisplayNamesECMA(
  Locale locale,
  LocaleMatcher localeMatcher,
) =>
    _DisplayNamesECMA.tryToBuild(locale, localeMatcher);

@JS('Intl.DisplayNames')
class _DisplayNamesJS {
  external factory _DisplayNamesJS([List<String> locale, Object options]);
  external String format(Object num);
}

@JS('Intl.DisplayNames.supportedLocalesOf')
external List<String> _supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

class _DisplayNamesECMA extends DisplayNamesImpl {
  _DisplayNamesECMA(super.locales);

  static DisplayNamesImpl? tryToBuild(
    Locale locale,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(localeMatcher, locale);
    return supportedLocales.isNotEmpty
        ? _DisplayNamesECMA(supportedLocales.first)
        : null; //TODO: Add support to force return an instance instead of null.
  }

  static List<String> supportedLocalesOf(
    LocaleMatcher localeMatcher,
    Locale locale,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return List.from(_supportedLocalesOfJS([localeToJsFormat(locale)], o));
  }

  @override
  String ofImpl(Object number, DisplayNamesOptions options) {
    final numberFormatJS = _DisplayNamesJS(
      [localeToJsFormat(locale)],
      options.toJsOptions(),
    );
    return numberFormatJS.format(number);
  }
}

extension on DisplayNamesOptions {
  Object toJsOptions() {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    setProperty(o, 'style', style.name);
    setProperty(o, 'type', type.name);
    setProperty(o, 'languageDisplay', languageDisplay.name);
    setProperty(o, 'fallback', fallback.name);
    return o;
  }
}
