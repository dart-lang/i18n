// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// This contains a reader that accesses data using the HttpRequest facility,
/// and thus works only in the web browser.
library;

import 'dart:async';
import 'dart:js_interop';

import 'intl_helpers.dart';
import 'web.dart';

class HttpRequestDataReader implements LocaleDataReader {
  /// The base url from which we read the data.
  final String url;

  HttpRequestDataReader(this.url);

  @override
  Future<String> read(String locale) {
    return _getString('$url$locale.json').timeout(
      Duration(seconds: 5),
      onTimeout: () {
        throw TimeoutException('Timeout while reading $locale');
      },
    );
  }

  Future<String> _getString(String url) async {
    final response = await window.fetch(url.toJS).toDart;

    if ((response.status >= 200 && response.status < 300) ||
        response.status == 0 ||
        response.status == 304) {
      return (await response.text().toDart).toDart;
    } else {
      throw Exception('Failed to load $url');
    }
  }
}
