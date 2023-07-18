// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale.dart';
import 'display_names_impl.dart';
import 'display_names_options.dart';

DisplayNamesImpl getDisplayNames4X(Locale locale) => DisplayNames4X(locale);

class DisplayNames4X extends DisplayNamesImpl {
  DisplayNames4X(super.locale);

  @override
  String ofCalendar(Calendar calendar, DisplayNamesOptions options) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  String ofCurrency(String currencyCode, DisplayNamesOptions options) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  String ofDateTime(DateTimeField field, DisplayNamesOptions options) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  String ofLanguage(Locale locale, DisplayNamesOptions options) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  String ofRegion(String regionCode, DisplayNamesOptions options) {
    throw UnimplementedError('Insert diplomat bindings here');
  }

  @override
  String ofScript(String scriptCode, DisplayNamesOptions options) {
    throw UnimplementedError('Insert diplomat bindings here');
  }
}
