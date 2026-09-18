// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// This contains a reader that accesses data from local files, so it can't
/// be run in the browser.
library;

import 'dart:io';

import 'package:path/path.dart';

import 'intl_helpers.dart';

class FileDataReader implements LocaleDataReader {
  /// The base path from which we will read data.
  String path;

  FileDataReader(this.path);

  /// Read the locale data found for [locale] on our [path].
  @override
  Future<String> read(String locale) {
    var filePath = join(path, '$locale.json');
    if (!isWithin(path, filePath)) {
      throw ArgumentError.value(
        locale,
        'locale',
        'Resolves outside the data directory',
      );
    }
    var file = File(filePath);
    return file.readAsString();
  }
}
