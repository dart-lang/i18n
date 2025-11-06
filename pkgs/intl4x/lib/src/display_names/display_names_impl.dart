// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale/locale.dart';
import '../utils.dart';
import 'display_names_options.dart';
import 'display_names_stub.dart'
    if (dart.library.js_interop) 'display_names_ecma.dart';
import 'display_names_stub_4x.dart'
    if (dart.library.ffi) 'display_names_4x.dart';

/// This is an intermediate to defer to the actual implementations of
/// Display naming.
abstract class DisplayNamesImpl {
  final Locale locale;
  final DisplayNamesOptions options;

  DisplayNamesImpl(this.locale, this.options);

  String ofLanguage(Locale locale);

  String ofRegion(String regionCode);

  static DisplayNamesImpl build(Locale locale, DisplayNamesOptions options) =>
      buildFormatter(locale, options, getDisplayNamesECMA, getDisplayNames4X);
}
