// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';
import 'class_generation.dart';
import 'constructor_generation.dart';
import 'field_generation.dart';
import 'generation.dart';
import 'import_generation.dart';
import 'method_generation.dart';

class LibraryGeneration extends Generation<Library> {
  final GenerationOptions options;
  final String? context;
  final Map<String, String> localeCarbPaths;
  final MessageListWithMetadata messageList;
  final Map<String, String> resourceToHash;

  LibraryGeneration(
    this.options,
    this.messageList,
    this.localeCarbPaths,
    this.resourceToHash,
  ) : context = messageList.context;

  @override
  List<Library> generate() {
    final imports = ImportGeneration(options, resourceToHash).generate();
    final constructors = ConstructorGeneration(options).generate();

    final fields = FieldGeneration(
      options,
      localeCarbPaths,
      messageList,
      resourceToHash,
    ).generate();

    final methods = MethodGeneration(
      options,
      context,
      messageList,
      resourceToHash,
    ).generate();

    final classes = ClassGeneration(
      options,
      messageList,
      constructors,
      fields,
      methods,
    ).generate();

    return [
      Library((b) => b
        ..directives.addAll(imports)
        ..body.addAll(classes))
    ];
  }
}
