// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import 'generation.dart';

class ImportGeneration extends Generation<Directive> {
  final GenerationOptions options;

  ImportGeneration(this.options);

  @override
  List<Directive> generate() {
    final serializationImports = switch (options.deserialization) {
      DeserializationType.web => [
          Directive.import('package:messages/messages_json.dart')
        ],
    };
    return serializationImports;
  }
}
