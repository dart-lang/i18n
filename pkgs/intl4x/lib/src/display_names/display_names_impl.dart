// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../ecma/ecma_policy.dart';
import '../locale/locale.dart';
import '../options.dart';
import '../utils.dart';
import 'display_names_4x.dart';
import 'display_names_options.dart';
import 'display_names_stub.dart' if (dart.library.js) 'display_names_ecma.dart';

/// This is an intermediate to defer to the actual implementations of
/// Display naming.
abstract class DisplayNamesImpl {
  final Locale locale;

  DisplayNamesImpl(this.locale);

  String ofDateTime(DateTimeField field, DisplayNamesOptions options);

  String ofLanguage(Locale locale, DisplayNamesOptions options);

  String ofRegion(String regionCode, DisplayNamesOptions options);

  String ofScript(String scriptCode, DisplayNamesOptions options);

  String ofCurrency(String currencyCode, DisplayNamesOptions options);

  String ofCalendar(Calendar calendar, DisplayNamesOptions options);

  factory DisplayNamesImpl.build(
    Locale locale,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locale,
        localeMatcher,
        ecmaPolicy,
        getDisplayNamesECMA,
        getDisplayNames4X,
      );
}
