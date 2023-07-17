// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../display_names.dart';
import '../test_checker.dart';
import 'display_names_impl.dart';

class DisplayNames {
  final DisplayNamesOptions _options;
  final DisplayNamesImpl impl;

  DisplayNames(this._options, this.impl);

  String of(String object) {
    if (isInTest) {
      return '$object//${impl.locale}';
    } else {
      return impl.ofImpl(object, _options);
    }
  }
}
