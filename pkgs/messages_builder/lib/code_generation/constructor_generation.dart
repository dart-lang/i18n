// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';
import 'package:messages_builder/code_generation/generation.dart';

import '../generation_options.dart';

class ConstructorGeneration extends Generation<Constructor> {
  final GenerationOptions options;

  ConstructorGeneration(this.options);

  @override
  List<Constructor> generate() {
    var nativeConstructor = Constructor((cb) => cb
      ..requiredParameters.add(
        Parameter(
          (pb) => pb
            ..name = '_loadingStrategy'
            ..toThis = true,
        ),
      )
      ..optionalParameters.addAll([
        if (options.useCleaner)
          Parameter(
            (pb) => pb
              ..name = 'cleaner'
              ..toThis = true
              ..named = true,
          ),
      ]));
    var webConstructor = Constructor((cb) => cb
      ..optionalParameters.addAll([
        if (options.useCleaner)
          Parameter(
            (pb) => pb
              ..name = 'cleaner'
              ..toThis = true
              ..named = true,
          ),
      ])
      ..body = options.makeAsync ? null : Code('loadAllLocales();'));
    return [options.isWeb ? webConstructor : nativeConstructor];
  }
}
