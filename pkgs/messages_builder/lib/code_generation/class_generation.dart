// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../parameterized_message.dart';

class ClassGeneration {
  final List<ParameterizedMessage> messages;
  final String? context;

  final List<Constructor> constructors;
  final List<Field> fields;
  final List<Method> methods;

  ClassGeneration(
    this.messages,
    this.context,
    this.constructors,
    this.fields,
    this.methods,
  );

  String getClassName(String? context) =>
      _toCamelCase('${context ?? ''}Messages');

  List<Spec> generate() => <Spec>[
        Class(
          (cb) => cb
            ..name = getClassName(context)
            ..constructors.addAll(constructors)
            ..fields.addAll(fields)
            ..methods.addAll(methods),
        ),
      ];
}

String _toCamelCase(String input) => input
    .split('_')
    .map((e) => e.substring(0, 1).toUpperCase() + e.substring(1))
    .join();
