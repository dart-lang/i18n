// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import 'generation.dart';

class ConstructorGeneration extends Generation<Constructor> {
  final GenerationOptions options;

  ConstructorGeneration(this.options);

  @override
  List<Constructor> generate() {
    final nativeConstructor = Constructor((cb) => cb
      ..requiredParameters.addAll([
        Parameter(
          (pb) => pb
            ..name = '_fileLoader'
            ..toThis = true,
        ),
        Parameter((pb) => pb
          ..name = 'intlObject'
          ..toThis = true),
      ])
      ..optionalParameters.addAll([
        if (options.useCleaner)
          Parameter(
            (pb) => pb
              ..name = 'cleaner'
              ..toThis = true
              ..named = true,
          ),
      ]));
    return [nativeConstructor];
  }
}
