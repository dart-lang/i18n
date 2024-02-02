// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../data.dart';
import '../locale/locale.dart';
import '../options.dart';
import 'display_names_impl.dart';
import 'display_names_options.dart';

DisplayNamesImpl getDisplayNames4X(
  Locale locale,
  Data data,
  DisplayNamesOptions options,
) =>
    DisplayNames4X(locale, data, options);

class DisplayNames4X extends DisplayNamesImpl {
  DisplayNames4X(super.locale, Data data, super.options);

  @override
  String ofCalendar(Calendar calendar) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  String ofCurrency(String currencyCode) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  String ofDateTime(DateTimeField field) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  String ofLanguage(Locale locale) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  String ofRegion(String regionCode) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  String ofScript(String scriptCode) {
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
