// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../parameterized_message.dart';
import 'class_generation.dart';
import 'constructor_generation.dart';
import 'field_generation.dart';
import 'method_generation.dart';

class ClassesGeneration {
  final String? context;
  final String initialLocale;
  final List<ParameterizedMessage> messages;
  final Iterable<({String locale, String path, String hash})> children;

  final DeserializationType deserialization;
  final PluralSelectorType pluralSelectorType;

  ClassesGeneration({
    required this.context,
    required this.initialLocale,
    required this.messages,
    required this.children,
    required this.deserialization,
    required this.pluralSelectorType,
  });

  List<Spec> generate() {
    final constructors = ConstructorGeneration(pluralSelectorType).generate();

    final fields = FieldGeneration(
      children,
      initialLocale,
      pluralSelectorType,
    ).generate();

    final methods = MethodGeneration(
      deserialization,
      context,
      messages,
    ).generate();

    final classes = ClassGeneration(
      messages,
      context,
      constructors,
      fields,
      methods,
    ).generate();

    return classes;
  }
}
