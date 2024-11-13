// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'message_file.dart';

/// A [MessageFile] with its [path].
class LocatedMessageFile {
  final String path;
  final MessageFile file;
  String get locale => file.locale ?? 'en_US';
  String get hash => file.hash;

  String namespacedPath(String packageName) => 'packages/$packageName/$path';

  LocatedMessageFile({required this.path, required this.file});
}
