// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../locale/locale.dart';
import '../options.dart';
import 'display_names_impl.dart';
import 'display_names_options.dart';

DisplayNamesImpl? getDisplayNamesECMA(
  Locale locale,
  DisplayNamesOptions options,
  LocaleMatcher localeMatcher,
) => _DisplayNamesECMA.tryToBuild(locale, options, localeMatcher);

@JS('Intl.DisplayNames')
extension type DisplayNames._(JSObject _) implements JSObject {
  external factory DisplayNames([JSArray<JSString> locales, JSAny options]);
  external String of(String object);

  external static JSArray<JSString> supportedLocalesOf(
    JSArray<JSString> locales, [
    JSAny options,
  ]);
}

class _DisplayNamesECMA extends DisplayNamesImpl {
  _DisplayNamesECMA(super.locale, super.options);

  static DisplayNamesImpl? tryToBuild(
    Locale locale,
    DisplayNamesOptions options,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(localeMatcher, locale);
    return supportedLocales.isNotEmpty
        ? _DisplayNamesECMA(supportedLocales.first, options)
        : null; //TODO: Add support to force return an instance instead of null.
  }

  static List<Locale> supportedLocalesOf(
    LocaleMatcher localeMatcher,
    Locale locale,
  ) {
    final o = {'localeMatcher': localeMatcher.jsName}.jsify()!;
    return DisplayNames.supportedLocalesOf(
      [locale.toLanguageTag().toJS].toJS,
      o,
    ).toDart.whereType<String>().map(Locale.parse).toList();
  }

  String of(DisplayNamesOptions options, DisplayType type, String jsName) =>
      DisplayNames(
        [locale.toLanguageTag().toJS].toJS,
        options.toJsOptions(type),
      ).of(jsName);

  @override
  String ofCalendar(Calendar calendar) =>
      of(options, DisplayType.calendar, calendar.jsName);

  @override
  String ofCurrency(String currencyCode) =>
      of(options, DisplayType.currency, currencyCode);

  @override
  String ofDateTime(DateTimeField field) =>
      of(options, DisplayType.dateTimeField, field.name);

  @override
  String ofLanguage(Locale locale) =>
      of(options, DisplayType.language, locale.toLanguageTag());

  @override
  String ofRegion(String regionCode) =>
      of(options, DisplayType.region, regionCode);

  @override
  String ofScript(String scriptCode) =>
      of(options, DisplayType.script, scriptCode);
}

extension on DisplayNamesOptions {
  JSAny toJsOptions(DisplayType type) =>
      {
        'localeMatcher': localeMatcher.jsName,
        'style': style.name,
        'type': type.name,
        'languageDisplay': languageDisplay.name,
        'fallback': fallback.name,
      }.jsify()!;
}
