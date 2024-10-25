// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:io';

import 'package:package_config/package_config.dart';
import 'package:pub_semver/pub_semver.dart';

/// Looks for a package surrounding [file] and, if found, returns the default
/// language version specified by that package.
Future<Version?> findPackageLanguageVersion(File file) async {
  try {
    var config = await findPackageConfig(file.parent);
    if (config?.packageOf(file.absolute.uri)?.languageVersion
        case var languageVersion?) {
      return Version(languageVersion.major, languageVersion.minor, 0);
    }
  } catch (error) {
    // If we fail to find or read a config, just silently do nothing and
    // default to the latest language version.
  }

  return null;
}
