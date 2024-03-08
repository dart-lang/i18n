// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart' show ResourceIdentifier;

import '../data.dart';
import '../ecma/ecma_policy.dart';
import '../locale/locale.dart';
import '../options.dart';
import '../utils.dart';
import 'display_names_4x.dart'
    if (dart.library.js) 'display_names_stub_4x.dart';
import 'display_names_options.dart';
import 'display_names_stub.dart' if (dart.library.js) 'display_names_ecma.dart';

/// This is an intermediate to defer to the actual implementations of
/// Display naming.
abstract class DisplayNamesImpl {
  final Locale locale;
  final DisplayNamesOptions options;

  DisplayNamesImpl(this.locale, this.options);

  String ofDateTime(DateTimeField field);

  String ofLanguage(Locale locale);

  String ofRegion(String regionCode);

  String ofScript(String scriptCode);

  String ofCurrency(String currencyCode);

  String ofCalendar(Calendar calendar);

  @ResourceIdentifier('DisplayNames')
  static DisplayNamesImpl build(
    Locale locale,
    Data data,
    DisplayNamesOptions options,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locale,
        data,
        options,
        localeMatcher,
        ecmaPolicy,
        getDisplayNamesECMA,
        getDisplayNames4X,
      );
}
