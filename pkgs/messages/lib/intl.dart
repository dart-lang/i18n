// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class Intl {
  static MessageLookup? l;

  static String message(
    String s, {
    required List<String> args,
    required String id,
  }) {
    if (l != null) return l!.getById(id, args);
    for (var i = 0; i < args.length; i++) {
      s = s.replaceAll('#$i', args[i]);
    }
    return s;
  }
}

abstract class MessageLookup {
  String getById(String id, List<dynamic> args);
}
