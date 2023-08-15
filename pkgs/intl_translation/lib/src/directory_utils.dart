// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:path/path.dart' as path;
import 'ffile_system_entity.dart';

/// Takes a file with a list of file paths, one per line, and returns the names
/// as paths in terms of the directory containing [fileName].
Iterable<String> linesFromFile(String? fileName) {
  if (fileName == null) {
    return [];
  }
  var file = File(fileName);
  return file
      .readAsLinesSync()
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .map((name) => _relativeToBase(fileName, name));
}

/// If [filename] is relative, make it relative to the dirname of base.
///
/// This is useful if we're running tests in a separate directory.
String _relativeToBase(String base, String filename) {
  if (path.isRelative(filename)) {
    return path.join(path.dirname(base), filename);
  } else {
    return filename;
  }
}

Future<List<String>> getDartFilesInFolder(String folderPath) async {
  var dir = Directory(folderPath);
  // ignore: omit_local_variable_types
  List<String> results = [];
  if (!dir.existsSync()) {
    return results;
  }
  var filesAndFolders = await getFilesAndFoldersInDir(dir);
  for (var i = 0; i < filesAndFolders.length; i++) {
    var entity = filesAndFolders[i];
    if (entity.isDartFile) {
      results.add(entity.path);
      continue;
    }
    if (entity.isDir) {
      var results2 = await getDartFilesInFolder(entity.path);
      results = [...results, ...results2];
      continue;
    }
  }
  return results;
}

/// Scan directory and return all the files and folders
Future<List<FFileSystemEntity>> getFilesAndFoldersInDir(Directory dir) async {
  // ignore: omit_local_variable_types
  List<FFileSystemEntity> results = [];
  // ignore: omit_local_variable_types
  Stream<FileSystemEntity> contents = dir.list(
    recursive: false,
    followLinks: false,
  );
  await for (FileSystemEntity entity in contents) {
    var type = await FileSystemEntity.type(entity.path);
    var entity2 = FFileSystemEntity(
      entity: entity,
      type: type,
    );

    if (!entity2.isDir && !entity2.isFile) {
      continue;
    }

    results.add(entity2);
  }
  return results;
}
