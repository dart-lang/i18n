// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// This contains a reader that accesses data using the HttpRequest
/// facility, and thus works only in the web browser.

library http_request_data_reader;

import 'dart:async';
import 'package:http/http.dart';
import 'intl_helpers.dart';

class HttpRequestDataReader implements LocaleDataReader {
  /// The base url from which we read the data.
  String url;

  HttpRequestDataReader(this.url);

  @override
  Future<String> read(String locale) {
    final Client client = Client();
    return _getString('$url$locale.json', client).timeout(
      Duration(seconds: 5),
      onTimeout: () {
        client.close();
        throw TimeoutException('Timeout while reading $locale');
      },
    );
  }

  Future<String> _getString(String url, Client client) async {
    final response = await client.get(Uri.parse(url));

    if ((response.statusCode >= 200 && response.statusCode < 300) ||
        response.statusCode == 0 ||
        response.statusCode == 304) {
      return response.body;
    } else {
      throw Exception('Failed to load $url');
    }
  }
}
