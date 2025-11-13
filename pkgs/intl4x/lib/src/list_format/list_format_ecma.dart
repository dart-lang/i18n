// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import '../locale/locale.dart';
import 'list_format_impl.dart';
import 'list_format_options.dart';

ListFormatImpl getListFormatterECMA(Locale locale, ListFormatOptions options) =>
    _ListFormatECMA.tryToBuild(locale, options);

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

  static ListFormatImpl tryToBuild(Locale locale, ListFormatOptions options) {
    final supportedLocales = supportedLocalesOf(locale);
    return _ListFormatECMA(
      supportedLocales.firstOrNull ?? Locale.parse('und'),
      options,
    );
  }

  static List<Locale> supportedLocalesOf(Locale locale) => ListFormat.supportedLocalesOf(
      [locale.toLanguageTag().toJS].toJS,
    ).toDart.whereType<String>().map(Locale.parse).toList();

  @override
  String formatImpl(List<String> list) => ListFormat(
      [locale.toLanguageTag().toJS].toJS,
      options.toJsOptions(),
    ).format(list.map((e) => e.toJS).toList().toJS);
}

extension on ListFormatOptions {
  JSAny toJsOptions() => {'type': type.jsName, 'style': style.name}.jsify()!;
}
