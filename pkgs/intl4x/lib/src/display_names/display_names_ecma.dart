// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../locale/locale.dart';
import 'display_names_impl.dart';
import 'display_names_options.dart';

DisplayNamesImpl getDisplayNamesECMA(
  Locale locale,
  DisplayNamesOptions options,
) => _DisplayNamesECMA.tryToBuild(locale, options);

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

  static DisplayNamesImpl tryToBuild(
    Locale locale,
    DisplayNamesOptions options,
  ) {
    final supportedLocales = supportedLocalesOf(locale);
    return _DisplayNamesECMA(
      supportedLocales.firstOrNull ?? Locale.parse('und'),
      options,
    );
  }

  static List<Locale> supportedLocalesOf(Locale locale) =>
      DisplayNames.supportedLocalesOf(
        [locale.toLanguageTag().toJS].toJS,
      ).toDart.whereType<String>().map(Locale.parse).toList();

  String of(DisplayNamesOptions options, DisplayType type, String jsName) =>
      DisplayNames(
        [locale.toLanguageTag().toJS].toJS,
        options.toJsOptions(type),
      ).of(jsName);

  @override
  String ofLanguage(Locale locale) =>
      of(options, DisplayType.language, locale.toLanguageTag());

  @override
  String ofRegion(String regionCode) =>
      of(options, DisplayType.region, regionCode);
}

extension on DisplayNamesOptions {
  JSAny toJsOptions(DisplayType type) => {
    'style': style.name,
    'type': type.name,
    'languageDisplay': languageDisplay.name,
    'fallback': fallback.name,
  }.jsify()!;
}
