// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';
import 'package:messages_builder/code_generation/generation.dart';

import '../generation_options.dart';

class ImportGeneration extends Generation<Directive> {
  final GenerationOptions options;
  final Map<String, String> resourceToHash;

  ImportGeneration(this.options, this.resourceToHash);

  @override
  List<Directive> generate() {
    var nativeImports = [
      Directive.import('dart:typed_data'),
      Directive.import('package:messages/message_native.dart'),
    ];
    var webImports = [
      Directive.import('package:messages/message_json.dart'),
    ];
    var resourceFileNames = resourceToHash.keys.map(getDataFileName);
    var deferredImports = resourceFileNames.map((name) => options.makeAsync
        ? Directive.importDeferredAs('$name.carb.dart', name)
        : Directive.import('$name.carb.dart', as: name));
    var imports = [
      Directive.import('package:messages/message_format.dart'),
      if (options.isNative) ...nativeImports,
      if (options.isWeb) ...webImports,
      if (options.isWeb) ...deferredImports,
    ];
    return imports;
  }
}
