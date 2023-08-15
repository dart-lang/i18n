// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

///This class tries to improve code speed
///by adding cache functionality as well as helper
///methods to FileSystemEntity

class FFileSystemEntity {
  final FileSystemEntity entity;
  final FileSystemEntityType type;

  FFileSystemEntity({
    //cache the type
    required this.type,
    required this.entity,
  });

  bool get isDir => type == FileSystemEntityType.directory;
  bool get isFile => type == FileSystemEntityType.file;
  bool get isDartFile => entity.path.toLowerCase().endsWith('.dart');
  String get path => entity.path;
}
