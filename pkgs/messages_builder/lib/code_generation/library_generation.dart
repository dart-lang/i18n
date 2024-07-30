// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';
import 'class_generation.dart';
import 'constructor_generation.dart';
import 'field_generation.dart';
import 'method_generation.dart';

class LibraryGeneration {
  final GenerationOptions options;
  final String? context;
  final String locale;
  final List<MessageWithMetadata> messages;
  final Map<String, ({String id, String hasch})> localeToResourceInfo;

  LibraryGeneration(
    this.options,
    this.context,
    this.locale,
    this.messages,
    this.localeToResourceInfo,
  );

  Library generate() {
    final constructors = ConstructorGeneration(options).generate();

    final fields = FieldGeneration(
      options,
      localeToResourceInfo,
      locale,
    ).generate();

    final methods = MethodGeneration(
      options,
      context,
      messages,
    ).generate();

    final classes = ClassGeneration(
      options,
      messages,
      context,
      constructors,
      fields,
      methods,
    ).generate();

    return Library((b) => b..body.addAll(classes));
  }
}
