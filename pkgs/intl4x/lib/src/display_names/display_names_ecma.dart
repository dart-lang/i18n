// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale.dart';
import '../options.dart';
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
  external String of(String object);
}

@JS('Intl.DisplayNames.supportedLocalesOf')
external List<String> _supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

class _DisplayNamesECMA extends DisplayNamesImpl {
  _DisplayNamesECMA(super.locale);

  static DisplayNamesImpl? tryToBuild(
    Locale locale,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(localeMatcher, locale);
    return supportedLocales.isNotEmpty
        ? _DisplayNamesECMA(supportedLocales.first)
        : null; //TODO: Add support to force return an instance instead of null.
  }

  static List<Locale> supportedLocalesOf(
    LocaleMatcher localeMatcher,
    Locale locale,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return List.from(_supportedLocalesOfJS([locale.toLanguageTag()], o))
        .whereType<String>()
        .map(Locale.parse)
        .toList();
  }

  String of(DisplayNamesOptions options, DisplayType type, String jsName) {
    final displayNamesJS = _DisplayNamesJS(
      [locale.toLanguageTag()],
      options.toJsOptions(type),
    );
    return displayNamesJS.of(jsName);
  }

  @override
  String ofCalendar(Calendar calendar, DisplayNamesOptions options) =>
      of(options, DisplayType.calendar, calendar.jsName);

  @override
  String ofCurrency(String currencyCode, DisplayNamesOptions options) =>
      of(options, DisplayType.currency, currencyCode);

  @override
  String ofDateTime(DateTimeField field, DisplayNamesOptions options) =>
      of(options, DisplayType.dateTimeField, field.name);

  @override
  String ofLanguage(Locale locale, DisplayNamesOptions options) =>
      of(options, DisplayType.language, locale.toLanguageTag());

  @override
  String ofRegion(String regionCode, DisplayNamesOptions options) =>
      of(options, DisplayType.region, regionCode);

  @override
  String ofScript(String scriptCode, DisplayNamesOptions options) =>
      of(options, DisplayType.script, scriptCode);
}

extension on DisplayNamesOptions {
  Object toJsOptions(DisplayType type) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    setProperty(o, 'style', style.name);
    setProperty(o, 'type', type.name);
    setProperty(o, 'languageDisplay', languageDisplay.name);
    setProperty(o, 'fallback', fallback.name);
    return o;
  }
}
