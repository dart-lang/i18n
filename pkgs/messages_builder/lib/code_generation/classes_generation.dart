// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';
import 'class_generation.dart';
import 'constructor_generation.dart';
import 'field_generation.dart';
import 'message_file_metadata.dart';
import 'method_generation.dart';

class ClassesGeneration {
  final GenerationOptions options;
  final String? context;
  final String initialLocale;
  final List<ParameterizedMessage> messages;
  final Iterable<MessageFileMetadata> messageFilesMetadata;
  final Map<String, String> emptyFiles;

  ClassesGeneration({
    required this.options,
    required this.context,
    required this.initialLocale,
    required this.messages,
    required this.messageFilesMetadata,
    required this.emptyFiles,
  });

  List<Spec> generate() {
    final constructors = ConstructorGeneration(options).generate();

    final fields = FieldGeneration(
      options,
      messageFilesMetadata,
      initialLocale,
    ).generate();

    final methods = MethodGeneration(
      options,
      context,
      messages,
      emptyFiles,
    ).generate();

    final classes = ClassGeneration(
      options,
      messages,
      context,
      constructors,
      fields,
      methods,
    ).generate();

    return classes;
  }
}
