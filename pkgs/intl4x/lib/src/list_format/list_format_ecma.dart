// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../locale/locale.dart';
import '../options.dart';
import 'list_format_impl.dart';
import 'list_format_options.dart';

ListFormatImpl? getListFormatterECMA(
  Locale locale,
  ListFormatOptions options,
  LocaleMatcher localeMatcher,
) => _ListFormatECMA.tryToBuild(locale, options, localeMatcher);

@JS('Intl.ListFormat')
extension type ListFormat._(JSObject _) implements JSObject {
  external factory ListFormat([JSArray<JSString> locale, JSAny options]);
  external String format(JSArray<JSString> list);

  external static JSArray<JSString> supportedLocalesOf(
    JSArray<JSString> locales, [
    JSAny options,
  ]);
}

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
    final o = {'localeMatcher': localeMatcher.jsName}.jsify()!;
    return ListFormat.supportedLocalesOf(
      [locale.toLanguageTag().toJS].toJS,
      o,
    ).toDart.whereType<String>().map(Locale.parse).toList();
  }

  @override
  String formatImpl(List<String> list) {
    return ListFormat(
      [locale.toLanguageTag().toJS].toJS,
      options.toJsOptions(),
    ).format(list.map((e) => e.toJS).toList().toJS);
  }
}

extension on ListFormatOptions {
  JSAny toJsOptions() =>
      {
        'localeMatcher': localeMatcher.jsName,
        'type': type.jsName,
        'style': style.name,
      }.jsify()!;
}
