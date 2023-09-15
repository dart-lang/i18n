// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

abstract class Generation<T> {
  List<T> generate();
}

String enumName(String? context) => '${context ?? ''}MessagesEnum';
String indicesName(String? context) => '${context ?? ''}MessagesIndex';

String getDataFileName(String e) => e.split('.').first;
