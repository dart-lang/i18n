// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Note: the contents of this file have been inlined from package:web/web.dart.
// We may periodically want to re-sync this, and / or look there when necessary
// to expose additional API.

import 'dart:js_interop';

@JS()
external Window get window;

extension type Window._(JSObject _) implements JSObject {
  external Navigator get navigator;

  external JSPromise<Response> fetch(
    JSAny /*RequestInfo*/ input, [
    JSObject /*RequestInit*/ init,
  ]);
}

extension type Navigator._(JSObject _) implements JSObject {
  external String get language;
}

extension type Response._(JSObject _) implements JSObject {
  external int get status;
  external JSPromise<JSString> text();
}
