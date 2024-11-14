// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class MessageFileMetadata {
  final String hash;
  final String path;
  final String locale;

  MessageFileMetadata({
    required this.hash,
    required this.path,
    required this.locale,
  });
}
