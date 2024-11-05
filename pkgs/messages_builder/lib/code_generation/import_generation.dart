// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';

class ImportGeneration {
  final GenerationOptions options;
  final Iterable<String> emptyFiles;

  ImportGeneration(this.options, this.emptyFiles);

  List<Directive> generate() {
    final serializationImports = switch (options.deserialization) {
      DeserializationType.web => [
          Directive.import('package:messages/messages_json.dart')
        ],
    };
    final pluralImports = switch (options.pluralSelector) {
      PluralSelectorType.intl => [Directive.import('package:intl/intl.dart')],
      PluralSelectorType.intl4x => [
          Directive.import('package:intl4x/intl4x.dart')
        ],
      PluralSelectorType.custom => <Directive>[],
    };

    final deferredImports = emptyFiles.map((emptyFilePath) {
      return Directive.importDeferredAs('$emptyFilePath.g.dart', emptyFilePath);
    });

    return [
      ...serializationImports,
      ...pluralImports,
      ...deferredImports,
    ];
  }
}
