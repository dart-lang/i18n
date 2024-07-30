// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';

class ConstructorGeneration {
  final GenerationOptions options;

  ConstructorGeneration(this.options);

  List<Constructor> generate() {
    final nativeConstructor = Constructor((cb) => cb
      ..requiredParameters.addAll([
        if (options.pluralSelector == PluralSelectorType.custom)
          Parameter((pb) => pb
            ..name = 'pluralSelector'
            ..toThis = true),
      ]));
    return [nativeConstructor];
  }
}
