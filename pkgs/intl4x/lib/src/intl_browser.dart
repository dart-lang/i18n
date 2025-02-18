// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'locale/locale.dart';

Locale findSystemLocale() => Locale.parse(window.navigator.language);

@JS()
external Window get window;

extension type Window._(JSObject _) implements JSObject {
  external Navigator get navigator;
}

extension type Navigator._(JSObject _) implements JSObject {
  external String get language;
}
