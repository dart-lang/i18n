// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';

class ImportGeneration {
  final PluralSelectorType pluralSelectorType;
  final DeserializationType deserialization;

  ImportGeneration(
    this.pluralSelectorType,
    this.deserialization,
  );

  List<Directive> generate() {
    final serializationImports = switch (deserialization) {
      DeserializationType.web => [
          Directive.import('package:messages/messages_json.dart')
        ],
    };
    final pluralImports = switch (pluralSelectorType) {
      PluralSelectorType.intl => [Directive.import('package:intl/intl.dart')],
      PluralSelectorType.intl4x => [
          Directive.import('package:intl4x/intl4x.dart')
        ],
      PluralSelectorType.custom => <Directive>[],
    };

    return [
      ...serializationImports,
      ...pluralImports,
    ];
  }
}
