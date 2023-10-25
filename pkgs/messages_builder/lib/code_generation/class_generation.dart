// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';
import 'generation.dart';

class ClassGeneration extends Generation<Spec> {
  final GenerationOptions options;
  final List<MessageWithMetadata> messages;
  final String? context;

  final List<Constructor> constructors;
  final List<Field> fields;
  final List<Method> methods;

  ClassGeneration(
    this.options,
    this.messages,
    this.context,
    this.constructors,
    this.fields,
    this.methods,
  );

  String getClassName(String? context) => '${context ?? ''}Messages';

  @override
  List<Spec> generate() {
    final classes = <Spec>[
      Class(
        (cb) => cb
          ..name = getClassName(context)
          ..constructors.addAll(constructors)
          ..fields.addAll(fields)
          ..methods.addAll(methods),
      ),
    ];
    if (options.findByType == IndexType.integer) {
      classes.add(Class((cb) => cb
        ..name = indicesName(context)
        ..fields.addAll(
          List.generate(
              messages.length,
              (index) => messages[index].nameIsDartConform
                  ? Field(
                      (evb) => evb
                        ..name = messages[index].name
                        ..type = const Reference('int')
                        ..assignment = Code('$index')
                        ..static = true
                        ..modifier = FieldModifier.constant,
                    )
                  : null).whereType<Field>(),
        )));
    }
    if (options.findByType == IndexType.enumerate || options.messageCalls) {
      classes.add(Enum((cb) => cb
        ..name = enumName(context)
        ..values.addAll(List.generate(
            messages.length,
            (index) => messages[index].nameIsDartConform
                ? EnumValue(
                    (evb) => evb..name = messages[index].name,
                  )
                : null).whereType<EnumValue>())));
    }
    return classes;
  }
}
