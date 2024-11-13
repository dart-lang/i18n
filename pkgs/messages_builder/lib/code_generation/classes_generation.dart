// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../located_message_file.dart';
import 'class_generation.dart';
import 'constructor_generation.dart';
import 'field_generation.dart';
import 'method_generation.dart';

class ClassesGeneration {
  final GenerationOptions options;
  final String? context;
  final LocatedMessageFile parent;
  final Iterable<LocatedMessageFile> children;
  final Map<String, String> emptyFiles;

  ClassesGeneration({
    required this.options,
    required this.context,
    required this.parent,
    required this.children,
    required this.emptyFiles,
  });

  List<Spec> generate() {
    final constructors = ConstructorGeneration(options).generate();

    final fields = FieldGeneration(
      options,
      children,
      parent.locale,
    ).generate();

    final methods = MethodGeneration(
      options,
      context,
      parent.file.messages,
      emptyFiles,
    ).generate();

    final classes = ClassGeneration(
      options,
      parent.file.messages,
      context,
      constructors,
      fields,
      methods,
    ).generate();

    return classes;
  }
}
